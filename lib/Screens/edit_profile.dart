import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Screens/profile.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class EditProfile extends StatefulWidget {
  final String? idUser;
  final String? nama;
  final String? profesi;
  final String? email;
  const EditProfile({
    Key? key,
     this.idUser, 
     this.nama,
     this.profesi,
     this.email})
    : super(key: key
  );

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String baseurl = url;
  var dio = Dio();

  Future<dynamic> putPost(String iduser, String nama, String profesi) async {
    Map<String, dynamic> data = {
      "iduser": iduser,
      "nama": nama,
      "profesi": profesi,
    };

    var response = await dio.put('$baseurl/vigenesia/api/PUTprofile',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));
    print("---> ${response.data} + ${response.statusCode}");
    return response.data;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController profesiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.nama ?? '';
    profesiController.text = widget.profesi ?? '';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
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
                        "Ubah Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Card(
                          margin: EdgeInsets.only(bottom: 25.0, top: 8),
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: Column(
                              children: [
                                Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 100.0,
                                        height: 100.0,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                                'assets/images/profile.png'),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        widget.nama ?? '',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: CupertinoColors.activeBlue),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        widget.email ?? '',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: CupertinoColors.systemGrey),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                FormBuilderTextField(
                                  name: "name",
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(),
                                      labelText: "Nama"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                FormBuilderTextField(
                                  name: "profesi",
                                  controller: profesiController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 10),
                                      border: OutlineInputBorder(),
                                      labelText: "Profesi"),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await putPost(
                                              widget.idUser ?? '',
                                              nameController.text,
                                              profesiController.text)
                                          .then((value) => {
                                                if (value != null)
                                                  {
                                                    pushNewScreen(
                                                      context,
                                                      screen: Profile(
                                                        nama:
                                                            nameController.text,
                                                        idUser: widget.idUser ?? '',
                                                        profesi:
                                                            profesiController
                                                                .text,
                                                        email: widget.email ?? '',
                                                      ),
                                                      withNavBar: true,
                                                      pageTransitionAnimation:
                                                          PageTransitionAnimation
                                                              .cupertino,
                                                    ),
                                                    ArtSweetAlert.show(
                                                        context: context,
                                                        artDialogArgs: ArtDialogArgs(
                                                            type:
                                                                ArtSweetAlertType
                                                                    .success,
                                                            title: "Success",
                                                            text:
                                                                "Data anda berhasil di update"))
                                                  }
                                              });
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
                                        "Ubah",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
