import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:samehomediffhacks/Models/Restaurant.dart';
import 'package:samehomediffhacks/GradientText.dart';
import 'package:flutter_star_rating/flutter_star_rating.dart';
import "dart:math";

class SwipeCard extends StatelessWidget {
  final Restaurant restaurant;
  final String stampPosition;
  final double angle;
  final double opacity;

  SwipeCard(
      {Key key,
      @required this.restaurant,
      this.stampPosition,
      this.angle,
      this.opacity})
      : super(key: key);

  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * .90;
    double cardHeight = MediaQuery.of(context).size.height * .6;

    Color nopeColor = Colors.redAccent.withOpacity(this.opacity);
    Color likeColor = Colors.greenAccent[400].withOpacity(this.opacity);

    LinearGradient nopeGradient = LinearGradient(
      colors: [nopeColor, Colors.deepOrange[300].withOpacity(opacity)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );
    LinearGradient likeGradient = LinearGradient(
      colors: [likeColor, Colors.greenAccent[100].withOpacity(opacity)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    Widget rightStamp = Transform.translate(
        offset: Offset(cardWidth * .35, cardHeight / 10),
        child: Transform.rotate(
            angle: pi / -12.0,
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: nopeColor, width: 10),
                    borderRadius: new BorderRadius.all(Radius.circular(20.0))),
                child: GradientText(
                  Text(
                    'NOPE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold),
                  ),
                  gradient: nopeGradient,
                ))));
    Widget leftStamp = Transform.translate(
        offset: Offset(cardWidth * .1, cardHeight / 10),
        child: Transform.rotate(
            angle: pi / 12.0,
            child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                    border: Border.all(color: likeColor, width: 10),
                    borderRadius: new BorderRadius.all(Radius.circular(20.0))),
                child: GradientText(
                    Text(
                      'LIKE',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    gradient: likeGradient))));

    return Transform.rotate(
        angle: this.angle,
        child: Container(
            width: cardWidth,
            height: cardHeight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Card(
              color: Colors.transparent,
              elevation: 4.0,
              child: Stack(children: <Widget>[
                Positioned.fill(
                    child: FittedBox(
                  child: Image.network(this.restaurant.imageURLs[0]),
                  fit: BoxFit.fill,
                )),
                Opacity(
                  opacity: .6,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.grey]),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: Container(
                            width: cardWidth,
                            height: cardHeight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Flexible(
                                        flex: 3,
                                        fit: FlexFit.loose,
                                        child: FittedBox(
                                            child: Text(
                                          '${this.restaurant.name}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 35,
                                              fontWeight: FontWeight.bold),
                                        ))),
                                    if (this.restaurant.priceRange != null)
                                      Flexible(
                                          flex: 1,
                                          child: Text(
                                            '  ${this.restaurant.priceRange}',
                                            style: TextStyle(
                                                color: Colors.greenAccent,
                                                fontSize: 35,
                                                fontWeight: FontWeight.normal),
                                          ))
                                  ],
                                ),
                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: StarRating(
                                        rating: this.restaurant.rating,
                                        starConfig: StarConfig(
                                            size: 30,
                                            strokeColor: Colors.transparent,
                                            fillColor: Colors.yellowAccent))),
                                SizedBox(
                                  height: cardWidth * .05,
                                )
                              ],
                            )))),
                if (this.stampPosition == "left")
                  Container(
                    child: leftStamp,
                  ),
                if (this.stampPosition == "right")
                  Container(
                    child: rightStamp,
                  )
              ]),
            )));
  }
}
