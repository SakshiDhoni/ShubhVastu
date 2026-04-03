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
  late PageController _pageController;
  final int _initialPage = 10000;
  late double _currentPage;
  Timer? _timer;

  // Sample Property Data
  final List<Map<String, String>> _properties = [
    {
      'image': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c', 
      'title': 'Modern Villa', 
      'address': 'Bandra West, Mumbai',
      'price': '₹ 5.5 Cr'
    },
    {
      'image': 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9', 
      'title': 'Luxury Penthouse', 
      'address': 'Worli Sea Face, Mumbai',
      'price': '₹ 12.0 Cr'
    },
    {
      'image': 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914', 
      'title': 'Cozy Cottage', 
      'address': 'Lonavala, Maharashtra',
      'price': '₹ 2.1 Cr'
    },
    {
      'image': 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750', 
      'title': 'Beach House', 
      'address': 'Alibaug, Maharashtra',
      'price': '₹ 4.8 Cr'
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = _initialPage.toDouble();
    
    _pageController = PageController(initialPage: _initialPage, viewportFraction: 0.65);
    
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });

    _startAutoSlide();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480, // Height of the cards
      child: PageView.builder(
        controller: _pageController,
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
                _pageController.animateToPage(
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
            padding: const EdgeInsets.all(32.0), // Increased frame thickness
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  Image.network(
                    property['image']!,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          property['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black87,
                                blurRadius: 10,
                                offset: Offset(0, 2),
                              )
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65), // Dark pill
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.white70, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      property['address']!,
                                      style: TextStyle(color: Colors.grey[300], fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.account_balance_wallet, color: Colors.white70, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    property['price']!,
                                    style: const TextStyle(color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
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
