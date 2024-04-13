import 'package:flutter/material.dart';
import 'national_screen.dart';
import 'provincial_screen.dart';
import 'international_screen.dart';
import 'checklist_screen.dart';
import 'history_screen.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSliderIndex = 0;
  // ignore: unused_field
  int _selectedIndex = 0; 

  final List<String> _sliderImages = [
    'assets/images/traviss.jpg',
    'assets/images/raisa.jpg',
    'assets/images/nostress.jpg',
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'name': 'Internasional',
      'description': 'Artis-artis terkenal dari berbagai negara di seluruh dunia.',
      'totalArtists': '3',
      'icon': Icons.public_rounded,
      'targetScreen': InternationalScreen(),
    },
    {
      'name': 'Nasional',
      'description': 'Artis-artis ternama dari dalam negeri.',
      'totalArtists': '3',
      'icon': Icons.flag_rounded,
      'targetScreen': NationalScreen(),
    },
    {
      'name': 'Provinsi',
      'description': 'Artis-artis lokal dari berbagai provinsi di Indonesia.',
      'totalArtists': '3',
      'icon': Icons.location_city_rounded,
      'targetScreen': ProvincialScreen(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentSliderIndex = index;
                  });
                },
              ),
              items: _sliderImages.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _sliderImages.map((image) {
                int index = _sliderImages.indexOf(image);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentSliderIndex == index ? Colors.blue : Colors.blue.withOpacity(0.4),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryButton(_categories[index], context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                child: Text(
                  '"Ayo hubungi artismu dengan cepat melalui ArtistContact"',
                  style: TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(Map<String, dynamic> category, BuildContext context) {
    return InkWell(
      onTap: () => _navigateToCategory(context, category['targetScreen']),
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  category['icon'],
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Text(
                  category['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              category['description'],
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Jumlah Artis: ${category['totalArtists']}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCategory(BuildContext context, Widget targetScreen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => targetScreen));
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 0) {
        
        return;
      } else if (index == 1) {
        
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChecklistScreen()));
      } else if (index == 2) {
        
        Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryScreen()));
      }
    });
  }

  void _onHomeTapped() {
    
  }
}

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
  ));
}
