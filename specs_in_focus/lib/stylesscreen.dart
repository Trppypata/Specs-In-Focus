import 'package:flutter/material.dart';
import 'LandingPage.dart';
import 'package:specs_in_focus/virtual_try_on_screen.dart';

void main() {
  runApp(const StylesScreen());
}

class StylesScreen extends StatelessWidget {
  const StylesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Specs In Focus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/LandingPage': (context) => LandingPage(),
        '/StylesScreen': (context) => StylesPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class StylesPage extends StatelessWidget {
  StylesPage({super.key});

  final List<String> imageAssets = [
    'assets/images/style1.jpg',
    'assets/images/style2.jpg',
    'assets/images/style3.jpg',
    'assets/images/style4.png',
    'assets/images/style5.jpg',
    'assets/images/style6.png',
    'assets/images/style7.jpg',
    'assets/images/style8.jpg',
    'assets/images/style9.jpg',
    'assets/images/style10.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/StylesScreen');
              },
              icon: const Icon(Icons.favorite_border_rounded),
              color: Colors.white,
              iconSize: 30,
              highlightColor: Colors.grey.shade300,
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/LandingPage');
              },
              icon: const Icon(Icons.home_rounded),
              color: Colors.white,
              iconSize: 30,
              highlightColor: Colors.grey.shade300,
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VirtualTryOnScreen()),
                );
              },
              icon: const Icon(Icons.camera_alt_rounded),
              color: Colors.white,
              iconSize: 30,
              highlightColor: Colors.grey.shade300,
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // or push to LandingPage if needed
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'specs',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              'in',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'focus',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black,
                child: Icon(Icons.headset_mic, color: Colors.white),
              ),
              onPressed: () {
                // Handle support button press here
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          const Text(
            'Styles',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 5),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: GridView.builder(
                itemCount: imageAssets.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      imageAssets[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return StylesPage();
  }
}
