class Review {
  double rating;
  String text;
  String time;

  Review(this.rating, this.text, this.time);

  Review.fromJSON(Map<String, dynamic> json) {
    this.rating = json['rating'];
    this.text = json['text'];
    this.time = json['time'];
  }

}
