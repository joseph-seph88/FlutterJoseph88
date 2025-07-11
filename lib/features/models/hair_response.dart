class HairResponse {
  final int? id;
  final int? userId;
  final String resultImageName;
  final String resultImageUrl;
  final String createdAt;

  HairResponse({
    this.id,
    this.userId,
    required this.resultImageName,
    required this.resultImageUrl,
    required this.createdAt,
  });

  factory HairResponse.fromJson(Map<String, dynamic> json) {
    return HairResponse(
      id: json['id'] as int?,
      userId: json['userId'] as int?,
      resultImageName: json['resultImageName'] as String? ?? '',
      resultImageUrl: json['resultImageUrl'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'resultImageName': resultImageName,
      'resultImageUrl': resultImageUrl,
      'createdAt': createdAt,
    };
  }
}
