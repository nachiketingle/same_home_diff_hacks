
import 'package:samehomediffhacks/Models/Review.dart';

class Restaurant {
  String name;
  String id;
  double lat;
  double lng;
  double rating;
  String priceRange;
  List<Review> reviews;
  List<String> imageURLs;
  int reviewCount;
  bool votedFor;
  int numVotes;

  Restaurant(this.name, this.lat, this.lng, this.rating, this.priceRange, this.reviews, this.imageURLs);

  Restaurant.minimum(this.name);

  Restaurant.fromJSON(Map<String, dynamic> json) {
    name = json["name"];
    lat = json["latitude"];
    lng = json["longitude"];
    priceRange = json["price"];
    rating = json["rating"] + 0.0;
    id = json["id"];
    // Do reviews
    reviewCount = json["review_count"];
    // Do image URL
    imageURLs = List();
    for(String url in json["photos"]) {
      imageURLs.add(url);
    }
    reviews = List();

    for(Map<String, dynamic> reviewJSON in json["reviews"]) {
      reviews.add(Review.fromJSON(reviewJSON));
    }

  }

}