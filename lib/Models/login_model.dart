import 'dart:convert';
import 'package:date_format/date_format.dart';

LoginModels loginModelsFromJson(String str) =>
    LoginModels.fromJson(json.decode(str));

String loginModelsToJson(LoginModels data) => json.encode(data.toJson());

class LoginModels {
  LoginModels({
    this.isActive,
    this.message,
    this.data,
  });

  bool? isActive;
  String? message;
  Data? data;

  factory LoginModels.fromJson(Map<String, dynamic> json) => LoginModels(
        isActive: json["is_active"] as bool?,
        message: json["message"] as String?,
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  Data({
    this.iduser,
    this.nama,
    this.profesi,
    this.email,
    this.password,
    this.roleId,
    this.isActive,
    this.tanggalInput,
    this.modified,
  });

  String? iduser;
  String? nama;
  String? profesi;
  String? email;
  String? password;
  String? roleId;
  String? isActive;
  DateTime? tanggalInput;
  String? modified;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        iduser: json["iduser"] as String?,
        nama: json["nama"] as String?,
        profesi: json["profesi"] as String?,
        email: json["email"] as String?,
        password: json["password"] as String?,
        roleId: json["role_id"] as String?,
        isActive: json["is_active"] as String?,
        tanggalInput: json["tanggal_input"] != null
            ? DateTime.parse(json["tanggal_input"])
            : null,
        modified: json["modified"] != null
            ? formatDate(DateTime.parse(json["modified"]), [yyyy, '-', M, '-', d])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "iduser": iduser,
        "nama": nama,
        "profesi": profesi,
        "email": email,
        "password": password,
        "role_id": roleId,
        "is_active": isActive,
        "tanggal_input": tanggalInput != null
            ? "${tanggalInput!.year.toString().padLeft(4, '0')}-${tanggalInput!.month.toString().padLeft(2, '0')}-${tanggalInput!.day.toString().padLeft(2, '0')}"
            : null,
        "modified": modified,
      };
}
