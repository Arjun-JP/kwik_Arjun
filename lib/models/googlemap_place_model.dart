class GoogleMapPlace {
  final String description;
  final String placeId;
  final String? reference;
  final String mainText;
  final String secondaryText;

  GoogleMapPlace({
    required this.description,
    required this.placeId,
    this.reference,
    required this.mainText,
    required this.secondaryText,
  });

  factory GoogleMapPlace.fromJson(Map<String, dynamic> json) {
    final structured = json['structured_formatting'] ?? {};
    return GoogleMapPlace(
      description: json['description'] ?? '',
      placeId: json['place_id'] ?? '',
      reference: json['reference'],
      mainText: structured['main_text'] ?? '',
      secondaryText: structured['secondary_text'] ?? '',
    );
  }
}
