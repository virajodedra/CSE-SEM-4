import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShowModalBottomDemo extends StatefulWidget {
  const ShowModalBottomDemo({super.key});

  @override
  State<ShowModalBottomDemo> createState() => _ShowModalBottomDemoState();
}

class _ShowModalBottomDemoState extends State<ShowModalBottomDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Show Modal Bottom Demo'),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                showModalBottomDemo();
              },
              child: Text('Submit'),
              color: Colors.greenAccent,
            ),
          ],
        ),
      ),
    );
  }

  void showModalBottomDemo() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          width: double.infinity,
          child: Column(
            children: [
              Text('That is the bottom sheet'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go Back'),
              ),
            ],
          ),
        );
      },
    );
  }
}








// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// class Showmodalbottomdemo extends StatefulWidget {
//   const Showmodalbottomdemo({super.key});
//
//   @override
//   State<Showmodalbottomdemo> createState() => _ShowmodalbottomdemoState();
// }
//
// class _ShowmodalbottomdemoState extends State<Showmodalbottomdemo> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//
//         title: Text(' Show Modal Bottom Demo'),
//         backgroundColor: Colors.green,
//
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             MaterialButton(onPressed: (){
//               Showmodalbottomdemo();
//             },child: Text('Submit'),
//             color: Colors.greenAccent,)
//           ],
//         ),
//       ),
//     );
//   }
//   void Showmodalbottomdemo(){
//     showBottomSheet(context: context, builder: (context){
//       return Container(
//         height: 200,
//         width: double.infinity,
//
//         child: Column(
//           children: [
//             Text('That is the bottom sheet'),
//             ElevatedButton(onPressed: (){
//               Navigator.pop(context);
//             }, child: Text('Go Back'))
//           ],
//         ),
//       );
//     });
//   }
// }
