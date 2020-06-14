import 'dart:async';

import 'package:flutter/material.dart';
import 'Models/Review.dart';
import 'package:samehomediffhacks/Models/Restaurant.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RestaurantInfoPage extends StatefulWidget {
  _RestaurantInfoPageState createState() => _RestaurantInfoPageState();
}

class _RestaurantInfoPageState extends State<RestaurantInfoPage> {

  Restaurant _restaurant;
  CameraPosition camPos;
  Completer<GoogleMapController> _controller = Completer();
  Map<MarkerId, Marker> _markers = {};

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
            return Image.network(imageURL[index], width: 150, height: 150,);
          },
          separatorBuilder: (context, index) => Divider(indent: 5,),
          itemCount: imageURL.length
      ),
    );
  }

  /// Returns the list view for the reviews of the restaurants
  Widget _reviewsListView() {
    List<Review> reviews = _restaurant.reviews;

    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
          Review curr = reviews[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Column(
                        children: <Widget>[
                          Text(curr.text),
                          Text(curr.time, style: TextStyle(color: Colors.grey),)
                        ],
                      ),
                    ),
                    Text(curr.rating.toString())
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => Divider(),
          itemCount: reviews.length
      ),
    );
  }

  void initState() {
    super.initState();

  }

  Widget build(BuildContext context) {

    _restaurant = ModalRoute.of(context).settings.arguments;
    camPos = CameraPosition(
      target: LatLng(_restaurant.lat, _restaurant.lng),
      zoom: 15
    );

    _markers.clear();
    MarkerId markerID = MarkerId(_restaurant.name);
    _markers[markerID] = Marker(
      markerId: markerID,
      position: LatLng(_restaurant.lat, _restaurant.lng)
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_restaurant.name.toString()),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imagesListView(),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: camPos,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: Set.of(_markers.values),
              ),
            ),
            Text("Rating: " + _restaurant.rating.toString() + "     Price Range: " + _restaurant.priceRange.toString()),
            _reviewsListView(),
          ],
        ),
      ),
    );

  }

}