import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Models/Restaurant.dart';

class RestaurantInfoPage extends StatefulWidget {
  _RestaurantInfoPageState createState() => _RestaurantInfoPageState();
}

class _RestaurantInfoPageState extends State<RestaurantInfoPage> {

  Restaurant _restaurant;

  /// Returns the list view for the images based on the URL in the restaurant
  Widget _imagesListView() {
    List<String> imageURL = _restaurant.imageURLs;

    // If we don't have any images, these are the default
    if (imageURL == null) {
      imageURL = List<String>();
      imageURL.add('https://picsum.photos/250?image=9');
      imageURL.add('https://github.com/flutter/plugins/raw/master/packages/video_player/video_player/doc/demo_ipod.gif?raw=true');
    }
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Image.network(imageURL[index], width: 200, height: 200,);
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: imageURL.length
      ),
    );
  }

  Widget build(BuildContext context) {

    _restaurant = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("RestaurantInfo Page"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imagesListView(),
            Text("This is the Restaurant Info page"),
          ],
        ),
      ),
    );

  }

}