import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Models/motivasi_model.dart';
import 'package:vigenesia/Screens/edit_page.dart';

class MotivasiUser extends StatefulWidget {
  final String? idUser;
  const MotivasiUser({Key? key, this.idUser}) : super(key: key);

  @override
  _MotivasiUserState createState() => _MotivasiUserState();
}

class _MotivasiUserState extends State<MotivasiUser> {
  String baseurl = url;
  String? id;
  var dio = Dio();

  List<MotivasiModel> listproduk = [];

  Future<dynamic> sendMotivasi(String isi) async {
    Map<String, dynamic> body = {
      "isi_motivasi": isi,
      "iduser": widget.idUser,
    };

    try {
      Response response = await dio.post(
        "$baseurl/vigenesia/api/dev/POSTmotivasi",
        data: body,
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      print("Respon -> ${response.data} + ${response.statusCode}");
      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  Future<dynamic> deletePost(String id) async {
    dynamic data = {
      "id": id,
    };

    try {
      Response response = await dio.delete(
        '$baseurl/vigenesia/api/dev/DELETEmotivasi',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {"Content-type": "application/json"},
        ),
      );
      return response;
    } catch (e) {
      print("Error di -> $e");
    }
  }

  Future<List<MotivasiModel>> getMotivasiData() async {
    var response = await dio.get("$baseurl/vigenesia/api/Get_motivasi?iduser=${widget.idUser}");
    print(" ${response.data}");

    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers = getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception("Failed to load");
    }
  }

  Future<void> _getData() async {
    setState(() {
      listproduk.clear();
    });

    var data = await getMotivasiData(); // Mengambil data
    setState(() {
      listproduk = data; // Memperbarui status komponen dengan data yang diambil
    });
  }

  @override
  void initState() {
    super.initState();
    _getData(); // Memanggil _getData untuk mengambil data pada saat inisialisasi
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produk'),
      ),
      body: listproduk.isEmpty
          ? Center(
              child: CircularProgressIndicator(), // Menampilkan indikator loading saat data sedang diambil
            )
          : ListView.builder(
              itemCount: listproduk.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(listproduk[index].nama ?? 'Nama tidak tersedia'),
                  subtitle: Text(listproduk[index].isiMotivasi ?? 'isiMotivasi tidak tersedia'),
                );
              },
            ),
    );
  }

  TextEditingController isiController = TextEditingController();

  Widget buildMotivasiForm(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 13,
                right: MediaQuery.of(context).size.width / 13,
                top: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Tambah Motivasi",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FormBuilderTextField(
                    controller: isiController,
                    name: "isi_motivasi",
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        await sendMotivasi(
                          isiController.text.toString(),
                        ).then((value) {
                          if (value != null) {
                            ArtSweetAlert.show(
                              context: context,
                              artDialogArgs: ArtDialogArgs(
                                type: ArtSweetAlertType.success,
                                title: "Success",
                                text: "Motivasi Berhasil Ditambahkan",
                              ),
                            );
                            _getData(); // Memanggil _getData untuk memperbarui data setelah pengiriman berhasil
                            isiController.text = "";
                          }
                        });
                        print("Sukses");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        elevation: 15.0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          "Daftar Motivasi",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _getData();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CupertinoColors.link,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          elevation: 15.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(CupertinoIcons.refresh_circled, size: 20),
                              SizedBox(width: 3),
                              Text("Refresh")
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  FutureBuilder(
                    future: getMotivasiData(),
                    builder: (BuildContext context, AsyncSnapshot<List<MotivasiModel>> snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              SizedBox(height: 8),
                              DataTable(
                                columns: [
                                  DataColumn(
                                    label: Text(
                                      "Like",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Isi Motivasi",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      "Action",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                                rows: snapshot.data!.map((item) {
                                  return DataRow(
                                    cells: [
                                      DataCell(Text(item.likes ?? '0')),
                                      DataCell(Text(item.isiMotivasi ?? 'Tidak tersedia')),
                                      DataCell(
                                        Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                pushNewScreen(
                                                  context,
                                                  screen: EditPage(
                                                    id: item.id,
                                                    isiMotivasi: item.isiMotivasi,
                                                    idUser: widget.idUser,
                                                  ),
                                                  withNavBar: true,
                                                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue[800],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(CupertinoIcons.pencil_circle),
                                              ),
                                            ),
                                            SizedBox(width: 3),
                                            ElevatedButton(
                                              onPressed: () async {
                                                ArtDialogResponse response = await ArtSweetAlert.show(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  artDialogArgs: ArtDialogArgs(
                                                    denyButtonText: "Cancel",
                                                    title: "Hapus Motivasi?",
                                                    text: "Apakah anda telah yakin?",
                                                    confirmButtonText: "Yes, Hapus",
                                                    type: ArtSweetAlertType.warning,
                                                  ),
                                                );

                                                if (response == '') {
                                                  return;
                                                }

                                                if (response.isTapConfirmButton) {
                                                  deletePost(item.id ?? '').then((value) {
                                                    if (value != null) {
                                                      ArtSweetAlert.show(
                                                        context: context,
                                                        artDialogArgs: ArtDialogArgs(
                                                          type: ArtSweetAlertType.success,
                                                          title: "Deleted!",
                                                        ),
                                                      );
                                                      _getData();
                                                    }
                                                  });
                                                  return;
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red[400],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.all(5),
                                                child: Icon(CupertinoIcons.trash_circle),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}