class CastingDetails {
  final String header;
  final dynamic date; // Assuming date can be null or have a specific format
  final String phoneNumber;
  final String country;
  final dynamic contactDetails; // Assuming contactDetails can be null or have a specific format
  final String description;

  CastingDetails({
    required this.header,
    required this.date,
    required this.phoneNumber,
    required this.country,
    required this.contactDetails,
    required this.description,
  });

  factory CastingDetails.fromJson(Map<String, dynamic> json) {
    return CastingDetails(
      header: json['header'] ?? '',
      date: json['date'], // Adjust the data type as per the expected format
      phoneNumber: json['phoneNumber'] ?? '',
      country: json['country'] ?? '',
      contactDetails: json['contactDetails'], // Adjust the data type as per the expected format
      description: json['description'] ?? '',
    );
  }
}
