import 'package:flutter/material.dart';
import 'package:laptop_checkout/features/pages/camera_page.dart';
import 'package:laptop_checkout/features/pages/history_page.dart';
import 'package:laptop_checkout/features/pages/profile_page.dart';
import 'package:laptop_checkout/features/pages/student_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 1; // Start with Camera as default (middle)
  final PageController _pageController = PageController(initialPage: 1);

  // Page titles in Amharic for the AppBar
  final List<String> _pageTitles = [
    'ተማሪ መመዝገብ', // Register Student
    'ላፕቶፕ ቃኝ', // Scan Laptop
    'ታሪክ', // History
    'መገለጫ', // Profile
  ];

  final List<Widget> _pages = [
    const RegisterStudentPage(), // index 0
    const CameraPage(), // index 1
    const HistoryPage(), // index 2
    const ProfilePage(), // index 3
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.page != null) {
        final page = _pageController.page!.round();
        if (page >= 0 && page < _pages.length) {
          if (_currentIndex != page) {
            setState(() {
              _currentIndex = page;
            });
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    if (index >= 0 && index <= 2) {
      _pageController.jumpToPage(index);
    }
  }

  void _openProfile() {
    _pageController.jumpToPage(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_currentIndex],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF003366),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.menu_rounded,
            color: Color(0xFF003366),
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle_rounded,
              color: _currentIndex == 3
                  ? const Color(0xFF003366)
                  : const Color(0xFF003366).withOpacity(0.7),
              size: 28,
            ),
            onPressed: _openProfile,
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF003366),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.laptop_chromebook_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'BIT ካምፓስ ደህንነት', // BIT Campus Security
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'የላፕቶፕ ማረጋገጫ ሥርዓት', // Laptop Verification System
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.person_add_alt_1_rounded,
                color: _currentIndex == 0
                    ? const Color(0xFF003366)
                    : const Color(0xFF003366).withOpacity(0.7),
              ),
              title: Text(
                'ተማሪ መመዝገብ', // Register Student
                style: TextStyle(
                  color: _currentIndex == 0
                      ? const Color(0xFF003366)
                      : Colors.black87,
                  fontWeight:
                      _currentIndex == 0 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pageController.jumpToPage(0);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.qr_code_scanner_rounded,
                color: _currentIndex == 1
                    ? const Color(0xFF003366)
                    : const Color(0xFF003366).withOpacity(0.7),
              ),
              title: Text(
                'ላፕቶፕ ቃኝ', // Scan Laptop
                style: TextStyle(
                  color: _currentIndex == 1
                      ? const Color(0xFF003366)
                      : Colors.black87,
                  fontWeight:
                      _currentIndex == 1 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pageController.jumpToPage(1);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.history_rounded,
                color: _currentIndex == 2
                    ? const Color(0xFF003366)
                    : const Color(0xFF003366).withOpacity(0.7),
              ),
              title: Text(
                'ታሪክ', // History
                style: TextStyle(
                  color: _currentIndex == 2
                      ? const Color(0xFF003366)
                      : Colors.black87,
                  fontWeight:
                      _currentIndex == 2 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _pageController.jumpToPage(2);
              },
            ),
            const Divider(),
            ListTile(
              leading: Icon(
                Icons.person_rounded,
                color: _currentIndex == 3
                    ? const Color(0xFF003366)
                    : const Color(0xFF003366).withOpacity(0.7),
              ),
              title: Text(
                'መገለጫ', // Profile
                style: TextStyle(
                  color: _currentIndex == 3
                      ? const Color(0xFF003366)
                      : Colors.black87,
                  fontWeight:
                      _currentIndex == 3 ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                _openProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline_rounded,
                  color: Color(0xFF003366)),
              title: const Text(
                'እገዛ እና ድጋፍ', // Help & Support
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.description_rounded,
                  color: Color(0xFF003366)),
              title: const Text(
                'ፖሊሲዎች', // Policies
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Left: Add Student Button
              Expanded(
                child: _buildBottomBarItem(
                  icon: Icons.person_add_alt_1_rounded,
                  label: 'ተማሪ መዝግብ', // Add Student / Register Student
                  index: 0,
                  isActive: _currentIndex == 0,
                ),
              ),

              // Middle: Camera Button (Floating Action Style)
              Container(
                width: 80,
                alignment: Alignment.topCenter,
                child: FloatingActionButton(
                  onPressed: () => _pageController.jumpToPage(1),
                  backgroundColor: const Color(0xFF003366),
                  elevation: 2,
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF003366), Color(0xFF0056B3)],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF003366).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),

              // Right: History Button
              Expanded(
                child: _buildBottomBarItem(
                  icon: Icons.history_rounded,
                  label: 'ታሪክ', // History
                  index: 2,
                  isActive: _currentIndex == 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBarItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF003366) : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? const Color(0xFF003366) : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
