import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Lab11LastB extends StatefulWidget {
  const Lab11LastB({super.key});

  @override
  State<Lab11LastB> createState() => _Lab11LastBState();
}

class _Lab11LastBState extends State<Lab11LastB> {
  bool isToggle = true; // Toggle between ListView and GridView

   List<String> items = [
     'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
     'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
     'https://i0.wp.com/picjumbo.com/wp-content/uploads/beautiful-fall-waterfall-free-image.jpeg?w=600&quality=80',
     'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
     'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
     'https://i0.wp.com/picjumbo.com/wp-content/uploads/beautiful-fall-waterfall-free-image.jpeg?w=600&quality=80',
     'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
     'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
     'https://i0.wp.com/picjumbo.com/wp-content/uploads/beautiful-fall-waterfall-free-image.jpeg?w=600&quality=80',
     'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
     'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
     'https://i0.wp.com/picjumbo.com/wp-content/uploads/beautiful-fall-waterfall-free-image.jpeg?w=600&quality=80',
     'https://letsenhance.io/static/8f5e523ee6b2479e26ecc91b9c25261e/1015f/MainAfter.jpg',
     'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885_1280.jpg',
     'https://i0.wp.com/picjumbo.com/wp-content/uploads/beautiful-fall-waterfall-free-image.jpeg?w=600&quality=80',
   ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isToggle = !isToggle;
              });
            },
            icon: Icon(
              isToggle ? Icons.view_list : Icons.grid_view, // Toggle icon based on view
            ),
          ),
        ],
      ),
      body: Center(
        child: isToggle
            ? ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return (
              Image.network(items[index])
            );
          },
        )
            : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two columns for the grid
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(items[index])
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
