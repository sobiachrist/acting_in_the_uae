class CastingDetails {
  final String header;
  final String date;
  final String phoneNumber;
  final String country;
  final String contactDetails;
  final String description;

  CastingDetails({
    this.header = '',
    this.date = '',
    this.phoneNumber = '',
    this.country = '',
    this.contactDetails = '',
    this.description = '',
  });

  factory CastingDetails.fromJson(Map<String, dynamic> json) {
    return CastingDetails(
      header: json['header'] ?? '',
      date: json['date'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      country: json['country'] ?? '',
      contactDetails: json['contactDetails'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
