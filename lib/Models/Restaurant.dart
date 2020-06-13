
class Restaurant {
  String name;
  String id;
  double lat;
  double lng;
  double rating;
  String priceRange;
  List<String> reviews;
  List<String> imageURLs;
  int reviewCount;
  bool votedFor;

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
  }

}