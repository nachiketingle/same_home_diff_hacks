
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
    rating = json["rating"];
    id = json["id"];
    // Do reviews
    reviewCount = json["review_count"];
    // Do image URL
    imageURLs = List();
    for(String url in json["photos"]) {
      imageURLs.add(url);
    }
    reviews = List();
    reviews.add(Review(
      3,
      "An Amzing Store",
      "Sunday, 30:00"
    ));

    reviews.add(Review(
        -1,
        "Undefined store. Could not find it",
        "Some random day"
    ));

    reviews.add(Review(
        5,
        "What was this! This was the worst store ever!"
            "I cannot believe they sold me this abombination. I come in and ask"
            "for some meat, and they send in a random objects. whjtjhjta"
            "lkjalskdjflkajsd;lkjf;lakshdfg"
            "ldfugiojieonrvodsfdihgoiahfdlkgnlsnkldhi8rhkjshgkj"
            "shkfhsgkhkjhkjhsmmvkhiuzhijkjkjkdfgkjdjfghjkjkhjhsm,oiu",
        "1/2/4/5"
    ));
  }

}