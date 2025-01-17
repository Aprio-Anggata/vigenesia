class LikeModel {
  LikeModel({
    this.id,
    this.idMotivasi,
    this.idUser,
    this.likes,
  });

  final String? id;
  final String? idMotivasi;
  final String? idUser;
  final String? likes;

  factory LikeModel.fromJson(Map<String, dynamic> json) => LikeModel(
        id: json["id"] as String?,
        idMotivasi: json["id_motivasi"] as String?,
        idUser: json["id_user"] as String?,
        likes: json["likes"] as String?,
      );
}
