void main() {
  List url = [
    "https://youtube.com/shorts/FIZI3k7mTvA?si=JYdvfxqETAQjql8K",
    "https://youtu.be/lNv2aSuxM3M?si=kFU6P-N4HjXQcZbB",
    "https://m.youtube.com/watch?v=HVjlOWUwk3g"
  ];
  for (var uri in url) {
    final host = Uri.parse(uri).host;
    if (host == "m.youtube.com" ||
        host == "youtu.be" ||
        host == "youtube.com") {
      print("Its youtube link");
    }
  }
}
