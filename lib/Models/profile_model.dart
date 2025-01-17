import 'dart:convert';
import 'package:date_format/date_format.dart';

List<ProfileModel> profileModelFromJson(String str) => List<ProfileModel>.from(
    jsonDecode(str).map((x) => ProfileModel.fromJson(x)));

String profilModelToJson(List<ProfileModel> data) =>
    jsonEncode(List<dynamic>.from(data.map((e) => e.toJson())));

class ProfileModel {
  ProfileModel({
    this.iduser,
    this.nama,
    this.profesi,
    this.email,
    this.password,
    this.roleId,
    this.isActive,
    this.tanggalInput,
    this.modified,
    this.likes,
  });

  final String? iduser;
  final String? nama;
  final String? profesi;
  final String? email;
  final String? password;
  final String? roleId;
  final String? isActive;
  final String? tanggalInput;
  final String? modified;
  final String? likes;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        iduser: json["iduser"] as String?,
        nama: json["nama"] as String?,
        profesi: json["profesi"] as String?,
        email: json["email"] as String?,
        password: json["password"] as String?,
        roleId: json["role_id"] as String?,
        isActive: json["is_active"] as String?,
        tanggalInput: json["tanggal_input"] != null
            ? formatDate(DateTime.parse(json["tanggal_input"]), [d, ' ', M, ' ', yyyy])
            : null,
        modified: json["modified"] != null
            ? formatDate(DateTime.parse(json["modified"]), [yyyy, '-', M, '-', d])
            : null,
        likes: json["likes"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "iduser": iduser,
        "nama": nama,
        "profesi": profesi,
        "email": email,
        "password": password,
        "role_id": roleId,
        "is_active": isActive,
        "tanggal_input": tanggalInput,
        "modified": modified,
        "likes": likes,
      };
}
