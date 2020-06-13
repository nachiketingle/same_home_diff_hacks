
class Restaurant {
  String name;
  double lat;
  double lng;
  double rating;
  double priceRange;
  List<String> reviews;
  List<String> imageURLs;
  bool votedFor;

  Restaurant(this.name, this.lat, this.lng, this.rating, this.priceRange, this.reviews, this.imageURLs);

  Restaurant.minimum(this.name);

  Restaurant.fromJSON(Map<String, dynamic> json) {
    name = json["name"];
    lat = json["lat"];
    lng = json["lng"];
    priceRange = json["priceRange"];

    // Do reviews

    // Do image URL
  }

}