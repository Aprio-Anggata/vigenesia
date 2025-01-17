import 'dart:convert';

List<MotivasiModel> motivasiModelFromJson(String str) =>
    List<MotivasiModel>.from(
        json.decode(str).map((x) => MotivasiModel.fromJson(x)));

String motivasiModelToJson(List<MotivasiModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MotivasiModel {
  MotivasiModel({
    this.id,
    this.isiMotivasi,
    this.idUser,
    this.nama,
    this.tanggalInput,
    this.tanggalUpdate,
    this.likes,
  });

  final String? id;
  final String? isiMotivasi;
  final String? idUser;
  final String? nama;
  final DateTime? tanggalInput;
  final String? tanggalUpdate;
  final String? likes;

  factory MotivasiModel.fromJson(Map<String, dynamic> json) => MotivasiModel(
        id: json['id'] as String?,
        isiMotivasi: json['isi_motivasi'] as String?,
        idUser: json['iduser'] as String?,
        nama: json['nama'] as String?,
        tanggalInput: json['tanggal_input'] != null
            ? DateTime.parse(json['tanggal_input'])
            : null,
        tanggalUpdate: json['tanggal_update'] as String?,
        likes: json['likes'] as String?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "isi_motivasi": isiMotivasi,
        "iduser": idUser,
        "nama": nama,
        "tanggal_input": tanggalInput != null
            ? "${tanggalInput!.year.toString().padLeft(4, '0')}-${tanggalInput!.month.toString().padLeft(2, '0')}-${tanggalInput!.day.toString().padLeft(2, '0')}"
            : null,
        "tanggal_update": tanggalUpdate,
        "likes": likes,
      };
}
