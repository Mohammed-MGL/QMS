import 'package:flutter/material.dart';
import 'package:qms/components/MyNavictionBar.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  bottomNavigationBar: MyNavictionBar(selectedItem: 1,),
      appBar: AppBar(backgroundColor: Colors.blue[700],
          titleSpacing: 00.0,
          centerTitle: true,
          toolbarHeight: 60.2,
          elevation: 10,
       title: Text('Favorite Centers',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'DancingScript',
                fontSize: 28,),),
                
),
      body: Center(child:Container()),
    
      
    );
  }
}