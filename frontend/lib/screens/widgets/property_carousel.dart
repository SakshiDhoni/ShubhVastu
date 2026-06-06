import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui';

class PropertyCarousel extends StatefulWidget {
  final VoidCallback onCardTap;

  const PropertyCarousel({super.key, required this.onCardTap});

  @override
  _PropertyCarouselState createState() => _PropertyCarouselState();
}

class _PropertyCarouselState extends State<PropertyCarousel> {
  PageController? _pageController;
  final int _initialPage = 10000;
  late double _currentPage;
  Timer? _timer;
  double? _lastFraction;

  // Sample Property Data
  final List<Map<String, String>> _properties = [

      {
      'image': 'assets/picture/carousel_1.jpg', 
      'title': 'Kedarnath - 3 BHK & Road Front Shops', 
      'address': 'Indira Nagar, Jagannath Chowk, Nashik',
      'price': 'Contact for Price'
    },
    {
      'image': 'assets/picture/carousel_2.jpg', 
      'title': 'Omkareshwar Infratech - 2 & 3 BHK Luxurious Flats & Commercial Shops', 
      'address': 'Rasbihari Meri Link Road, Nashik', 
      'price': 'Contact for Price'
    },
    {
      'image': 'assets/picture/carousel_3.jpg',
      'title': 'Richmond - 3 BHK Luxurious Flats', 
      'address': 'Shri Hari Kute Marg, Nashik',   
      'price': 'Contact for Price'
    },
    
    {
      'image': 'assets/picture/villa_1.jpg', 
      'title': 'Modern Villa', 
      'address': 'Bandra West, Mumbai', 
      'price': '₹ 5.5 Cr'
    },
    {
      'image': 'assets/picture/penthouse_1.jpg', 
      'title': 'Luxury Penthouse', 
      'address': 'Worli Sea Face, Mumbai', 
      'price': '₹ 12.0 Cr'
    },
    {
      'image': 'assets/picture/cottage_1.jpg', 
      'title': 'Cozy Cottage', 
      'address': 'Lonavala, Maharashtra',
      'price': '₹ 2.1 Cr'
    },
    {
      'image': 'assets/picture/beach_house_1.jpg', 
      'title': 'Beach House', 
      'address': 'Alibaug, Maharashtra',
      'price': '₹ 4.8 Cr'
    },
    {
      'image': 'assets/picture/apartment_1.jpg',
      'title': 'Seaview Apartment',
      'address': 'Marine Drive, Mumbai',
      'price': '₹ 15.5 Cr'
    },
    {
      'image': 'assets/picture/villa_2.jpg',
      'title': 'Hill Station Villa',
      'address': 'Khandala, Maharashtra',
      'price': '₹ 4.2 Cr'
    },
    {
      'image': 'assets/picture/duplex_1.jpg',
      'title': 'Smart Home Duplex',
      'address': 'Powai, Mumbai',
      'price': '₹ 6.8 Cr'
    },
    {
      'image': 'assets/picture/mansion_1.jpg',
      'title': 'Riverside Mansion',
      'address': 'Karjat, Maharashtra',
      'price': '₹ 3.5 Cr'
    },
    {
      'image': 'assets/picture/studio_1.jpg',
      'title': 'Premium Studio',
      'address': 'Andheri West, Mumbai',
      'price': '₹ 1.8 Cr'
    },
    {
      'image': 'assets/picture/retreat_1.jpg',
      'title': 'Forest Retreat',
      'address': 'Mahabaleshwar, Maharashtra',
      'price': '₹ 2.9 Cr'
    },
  
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = _initialPage.toDouble();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    double width = MediaQuery.of(context).size.width;
    double fraction = width < 800 ? 0.90 : 0.75;
    
    if (_lastFraction == null || _lastFraction != fraction) {
      _lastFraction = fraction;
      
      int targetPage = _initialPage;
      if (_pageController != null) {
        try {
          targetPage = _pageController!.page?.round() ?? _initialPage;
          _pageController!.dispose();
        } catch (_) {}
      }
      
      _pageController = PageController(initialPage: targetPage, viewportFraction: fraction);
      _pageController!.addListener(() {
        setState(() {
          _currentPage = _pageController!.page!;
        });
      });
      
      _timer?.cancel();
      _startAutoSlide();
    }
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController != null && _pageController!.hasClients) {
        _pageController!.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_pageController == null) {
      return const SizedBox.shrink();
    }

    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800;
    double carouselHeight = isMobile ? 440 : 540;

    return SizedBox(
      height: carouselHeight, // Responsive height of the cards
      child: PageView.builder(
        controller: _pageController!,
        itemBuilder: (context, index) {
          int actualIndex = index % _properties.length;
          double distance = (index - _currentPage).abs();
          
          double scale = (1 - (distance * 0.25)).clamp(0.75, 1.0);
          double opacity = (1 - (distance * 0.5)).clamp(0.5, 1.0);

          return GestureDetector(
            onTap: () {
              if (distance < 0.5) {
                // Approximate center card clicked
                widget.onCardTap();
              } else {
                // Allow clicking side cards to bring them to center
                _pageController!.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeInOutCubic,
                );
              }
            },
            child: Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: _buildCard(_properties[actualIndex]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(Map<String, String> property) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = width < 800;
    double cardPadding = isMobile ? 12.0 : 32.0;
    double titleFontSize = isMobile ? 18.0 : 24.0;
    double addressFontSize = isMobile ? 11.0 : 13.0;
    double priceFontSize = isMobile ? 14.0 : 16.0;
    double iconSize = isMobile ? 14.0 : 18.0;
    double verticalSpacing = isMobile ? 8.0 : 16.0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black.withOpacity(0.8), width: 3.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 20,
            offset: const Offset(0, 15),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
          child: Padding(
            padding: EdgeInsets.all(cardPadding), // Responsive frame thickness
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Blurred background image to fill the card
                  Image.asset(
                    property['image']!,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.2),
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
                      ),
                    ),
                  ),
                  // Blur effect over the background image
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Crisp foreground image that is completely visible
                  Positioned.fill(
                    child: Image.asset(
                      property['image']!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    bottom: isMobile ? 8 : 16,
                    left: isMobile ? 8 : 16,
                    right: isMobile ? 8 : 16,
                    child: Builder(
                      builder: (context) {
                        final String title = property['title'] ?? '';
                        String projectName = title;
                        String detailsText = "";
                        if (title.contains(" - ")) {
                          final parts = title.split(" - ");
                          projectName = parts[0];
                          detailsText = parts[1];
                        }

                        return Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 16,
                            vertical: isMobile ? 10 : 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65), // Dark pill
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                projectName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isMobile ? 16 : 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (detailsText.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  detailsText,
                                  style: TextStyle(
                                    color: Colors.grey[350],
                                    fontSize: isMobile ? 12 : 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Divider(
                                color: Colors.white.withOpacity(0.15),
                                height: 1,
                                thickness: 1,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.location_on, color: Colors.white70, size: iconSize),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      property['address'] ?? '',
                                      style: TextStyle(color: Colors.grey[300], fontSize: addressFontSize),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isMobile ? 4 : 8),
                              Row(
                                children: [
                                  Icon(Icons.account_balance_wallet, color: Colors.white70, size: iconSize),
                                  const SizedBox(width: 8),
                                  Text(
                                    property['price'] ?? '',
                                    style: TextStyle(color: Colors.greenAccent, fontSize: priceFontSize, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
