require('dotenv').config();
console.log("🔹 Starting server...");

const express = require('express');
const cors = require('cors');
const multer = require('multer');
const admin = require('firebase-admin');
const twilio = require('twilio');
const nodemailer = require('nodemailer');
const cloudinary = require('cloudinary').v2;
const streamifier = require('streamifier');

// --- Firebase Admin Init ---
try {
  const serviceAccount = require('./serviceAccountKey.json');
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
  });
  const db = admin.firestore();
  console.log("✅ Firebase initialized");
} catch (e) {
  console.error("❌ Firebase Admin Init Error: Make sure 'serviceAccountKey.json' exists and is valid.", e.message);
  process.exit(1); // Exit if Firebase can't initialize
}


// --- Cloudinary Config ---
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});
console.log("✅ Cloudinary configured");

// --- Express Setup ---
const app = express();
app.use(cors());
app.use(express.json());

// --- Multer Setup for file uploads ---
const upload = multer({
  storage: multer.memoryStorage()
}).any();

// --- Twilio & Nodemailer Setup ---
const client = twilio(process.env.TWILIO_SID, process.env.TWILIO_TOKEN);
const twilioFrom = process.env.TWILIO_NUMBER;
const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: +process.env.SMTP_PORT, // The '+' converts string to number
  secure: process.env.SMTP_SECURE === 'true',
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  },
});

// --- Helper function to upload a buffer to Cloudinary ---
function streamUpload(buffer) {
  return new Promise((resolve, reject) => {
    const uploadStream = cloudinary.uploader.upload_stream({
      folder: 'ctoc_broker'
    },
      (err, result) => {
        if (err) {
          reject(err);
        } else {
          resolve(result.secure_url);
        }
      }
    );
    streamifier.createReadStream(buffer).pipe(uploadStream);
  });
}

// =================================================================
// --- API ENDPOINTS ---
// =================================================================

// --- User Registration ---
app.post('/api/register', async (req, res) => {
  console.log('▶️ POST /api/register called...');
  const {
    email,
    password,
    username
  } = req.body;

  if (!email || !password || !username) {
    return res.status(400).json({
      error: 'Email, password, and username are required'
    });
  }

  try {
    const user = await admin.auth().createUser({
      email,
      password,
      displayName: username
    });
    console.log("✅ Firebase Auth user created:", user.uid);

    // Also store user in Firestore for more details
    await admin.firestore().collection('users').doc(user.uid).set({
      uid: user.uid,
      email: email,
      username: username,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
    console.log("✅ User data stored in Firestore for:", user.uid);


    res.status(200).json({
      message: 'User registered successfully',
      uid: user.uid
    });
  } catch (e) {
    console.error("❌ /api/register error:", e.message);
    res.status(500).json({
      error: e.code === 'auth/email-already-exists' ? 'That email address is already in use.' : e.message
    });
  }
});

// --- Notification Sender ---
app.post('/api/notify', async (req, res) => {
  console.log('▶️ POST /api/notify called...');
  const { to, text, channel } = req.body;
  if (!to || !text || !channel) {
    return res.status(400).json({ error: 'to, text, and channel are required' });
  }

  try {
    if (channel === 'whatsapp') {
      console.log(`Attempting to send WhatsApp to: ${to}`);
      const message = await client.messages.create({
        body: text,
        from: `whatsapp:${twilioFrom}`,
        to: `whatsapp:${to}`
      });
      console.log('✅ WhatsApp sent successfully, SID:', message.sid);
    } else if (channel === 'email') {
      console.log(`Attempting to send Email to: ${to}`);
      const info = await transporter.sendMail({
        from: `CtoC Broker <${process.env.SMTP_USER}>`,
        to: to,
        subject: 'Welcome from CtoC Broker!',
        text: text
      });
      console.log('✅ Email sent successfully, Message ID:', info.messageId);
    } else {
      throw new Error('Invalid notification channel specified.');
    }
    res.status(200).json({ status: 'Notification sent successfully' });
  } catch (e) {
    console.error('❌ /api/notify error:', e.message);
    res.status(500).json({ error: 'Failed to send notification. Check server logs and .env credentials.' });
  }
});


// --- Get Available Properties ---
app.get('/api/properties', async (req, res) => {
  console.log('▶️ GET /api/properties called...');
  try {
    const snapshot = await admin.firestore().collection('contractor_properties').orderBy('createdAt', 'desc').get();
    let properties = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    // Filter out booked properties
    properties = properties.filter(p => !p.isBooked);

    res.status(200).json({ properties });
  } catch (e) {
    console.error('❌ /api/properties error:', e.message);
    res.status(500).json({ error: e.message });
  }
});

// --- Add a new Property (for Contractors) ---
app.post('/api/contractor_property', upload, async (req, res) => {
  console.log('▶️ POST /api/contractor_property called...');
  try {
    const { name, location, amount, contractorName, contractorPhone } = req.body;
    const imageFiles = req.files || [];

    if (!name || !location || !amount || imageFiles.length === 0) {
      return res.status(400).json({ error: 'Name, location, amount, and at least one image are required' });
    }

    // Upload images to Cloudinary
    const imageUrls = [];
    for (const file of imageFiles) {
      const url = await streamUpload(file.buffer);
      imageUrls.push(url);
    }
    console.log(`✅ Uploaded ${imageUrls.length} images to Cloudinary.`);

    const newProperty = {
      name,
      location,
      amount: Number(amount),
      contractorName: contractorName || '',
      contractorPhone: contractorPhone || '',
      imageUrls,
      isBooked: false,
      bookedBy: null,
      bookedAt: null,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    const docRef = await admin.firestore().collection('contractor_properties').add(newProperty);
    console.log('✅ New property added to Firestore with ID:', docRef.id);

    res.status(201).json({ success: true, id: docRef.id, data: newProperty });
  } catch (e) {
    console.error('❌ /api/contractor_property error:', e.message);
    res.status(500).json({ error: e.message });
  }
});

// ... You can add the other endpoints (cars, booking, etc.) here following the same detailed pattern ...

// =================================================================
// --- SERVER START ---
// =================================================================

const PORT = process.env.PORT || 3000;
app.get('/', (req, res) => res.send('CtoC Broker backend is running.'));
app.listen(PORT, () => console.log(`🚀 Backend listening on http://localhost:${PORT}`));