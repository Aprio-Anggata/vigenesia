import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Screens/motivasi_user.dart';

class EditPage extends StatefulWidget {
  final String? idUser;
  final String? id;
  final String? isiMotivasi;
  const EditPage({Key? key, this.id, this.isiMotivasi, this.idUser}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String baseurl = url;

  var dio = Dio();

  Future<dynamic> putPost(String? isiMotivasi, String? ids) async {
    Map<String, dynamic> data = {
      "isi_motivasi": isiMotivasi,
      "id": ids,
    };

    var response = await dio.put('$baseurl/vigenesia/api/dev/PUTmotivasi',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));
    print("---> ${response.data} + ${response.statusCode}");
    return response.data;
  }

  TextEditingController isiMotivasiC = TextEditingController();

  @override
  void initState() {
    super.initState();
    isiMotivasiC.text = widget.isiMotivasi ?? '';
    print(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 13,
                right: MediaQuery.of(context).size.width / 13,
                top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(CupertinoIcons.arrow_left),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Edit Motivasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: CupertinoColors.systemBlue,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: FormBuilderTextField(
                    name: "isi_motivasi",
                    controller: isiMotivasiC,
                    decoration: InputDecoration(
                      labelText: "New Data",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  child: ElevatedButton(
                    onPressed: () async {
                      await putPost(isiMotivasiC.text, widget.id)
                          .then((value) => {
                                if (value != null)
                                  {
                                    pushNewScreen(
                                      context,
                                      screen: MotivasiUser(idUser: widget.idUser ?? ''),
                                      withNavBar: true,
                                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                                    ),
                                    ArtSweetAlert.show(
                                        context: context,
                                        artDialogArgs: ArtDialogArgs(
                                            type: ArtSweetAlertType.success,
                                            title: "Success",
                                            text: "Update Motivasi Berhasil."))
                                  }
                              });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800], // Mengganti primary dengan backgroundColor
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
