import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridViewStaticData extends StatelessWidget {
  GridViewStaticData({super.key});

  List<String> images = [
    'https://media.hswstatic.com/eyJidWNrZXQiOiJjb250ZW50Lmhzd3N0YXRpYy5jb20iLCJrZXkiOiJnaWZcL2dldHR5aW1hZ2VzLTg1MTIwNTUzLmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6ODI4fSwidG9Gb3JtYXQiOiJhdmlmIn19',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4IoiZyX73T-6i59-D4zDKuGxGtnVHEdLUQA&s',
    'https://media.hswstatic.com/eyJidWNrZXQiOiJjb250ZW50Lmhzd3N0YXRpYy5jb20iLCJrZXkiOiJnaWZcL2dldHR5aW1hZ2VzLTg1MTIwNTUzLmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6ODI4fSwidG9Gb3JtYXQiOiJhdmlmIn19',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4IoiZyX73T-6i59-D4zDKuGxGtnVHEdLUQA&s',
    'https://media.hswstatic.com/eyJidWNrZXQiOiJjb250ZW50Lmhzd3N0YXRpYy5jb20iLCJrZXkiOiJnaWZcL2dldHR5aW1hZ2VzLTg1MTIwNTUzLmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6ODI4fSwidG9Gb3JtYXQiOiJhdmlmIn19',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4IoiZyX73T-6i59-D4zDKuGxGtnVHEdLUQA&s',
    'https://media.hswstatic.com/eyJidWNrZXQiOiJjb250ZW50Lmhzd3N0YXRpYy5jb20iLCJrZXkiOiJnaWZcL2dldHR5aW1hZ2VzLTg1MTIwNTUzLmpwZyIsImVkaXRzIjp7InJlc2l6ZSI6eyJ3aWR0aCI6ODI4fSwidG9Gb3JtYXQiOiJhdmlmIn19',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4IoiZyX73T-6i59-D4zDKuGxGtnVHEdLUQA&s',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GridView with Static Images'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,  // Number of columns in the grid
          crossAxisSpacing: 8.0,  // Spacing between columns
          mainAxisSpacing: 8.0,  // Spacing between rows
        ),
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Card(
            child: Image.network(
              images[index],
              fit: BoxFit.cover,  // Makes sure the image fills the box
            ),
          );
        },
      ),
    );
  }
}

