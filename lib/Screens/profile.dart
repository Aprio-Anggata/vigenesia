import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Models/profile_model.dart';
import 'package:vigenesia/Screens/edit_profile.dart';
import 'package:vigenesia/Screens/login.dart';

class Profile extends StatefulWidget {
  final String? idUser;
  final String? nama;
  final String? profesi;
  final String? email;

  const Profile({Key? key, this.idUser, this.nama, this.profesi, this.email}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String baseurl = url;
  var dio = Dio();

  Future<List<ProfileModel>> getData() async {
    var response =
        await dio.get("$baseurl/vigenesia/api/user?iduser=${widget.idUser}");
    print("Profile -> ${response.data}");

    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers =
          getUsersData.map((i) => ProfileModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception("Failed to load");
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
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
                top: 30.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          pushNewScreen(
                            context,
                            screen: EditProfile(
                              idUser: widget.idUser,
                              nama: widget.nama,
                              profesi: widget.profesi,
                              email: widget.email,
                            ),
                            withNavBar: true,
                            pageTransitionAnimation: PageTransitionAnimation.cupertino,
                          );
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
                              Icon(
                                CupertinoIcons.pencil_outline,
                                size: 20,
                                color: Colors.white, // Mengubah warna ikon menjadi putih
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "Ubah Profile",
                                style: TextStyle(
                                  color: Colors.white, // Mengubah warna teks menjadi putih
                                ),
                              ),
                            ],
                          ),
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
                                FutureBuilder(
                                  future: getData(),
                                  builder: (BuildContext context, AsyncSnapshot<List<ProfileModel>> snapshot) {
                                    if (snapshot.hasData) {
                                      return Center(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: 100.0,
                                              height: 100.0,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: new DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage('assets/images/profile.png'),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            for (var item in snapshot.data!)
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    item.nama ?? 'Nama tidak tersedia',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                      color: CupertinoColors.activeBlue,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    item.email ?? 'Email tidak tersedia',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      color: CupertinoColors.systemGrey,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () async {},
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: CupertinoColors.link,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(5),
                                                      ),
                                                      elevation: 15.0,
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        item.profesi ?? 'Profesi tidak tersedia',
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            (item.likes == '' || item.likes == null ? "0" : item.likes)!,
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600,
                                                              color: CupertinoColors.systemGrey,
                                                              letterSpacing: 2,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            "LIKES",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: CupertinoColors.systemBlue,
                                                              letterSpacing: 2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            item.tanggalInput ?? 'Tanggal tidak tersedia',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight: FontWeight.w600,
                                                              color: CupertinoColors.systemGrey,
                                                              letterSpacing: 2,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            "MEMBER SINCE",
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.w600,
                                                              color: CupertinoColors.systemBlue,
                                                              letterSpacing: 2,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )
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
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                getData();
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CupertinoColors.link,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 8.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.refresh_circled,
                                    size: 20,
                                    color: Colors.white, // Mengubah warna ikon menjadi putih
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text(
                                    "Refresh",
                                    style: TextStyle(
                                      color: Colors.white, // Mengubah warna teks menjadi putih
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              pushNewScreen(
                                context,
                                screen: Login(),
                                withNavBar: false,
                                pageTransitionAnimation: PageTransitionAnimation.cupertino,
                              );
                              ArtSweetAlert.show(
                                context: context,
                                artDialogArgs: ArtDialogArgs(
                                  type: ArtSweetAlertType.success,
                                  title: "Success",
                                  text: "See You Next Time :)",
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CupertinoColors.destructiveRed,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              elevation: 8.0,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  Text("Logout",
                                    style: TextStyle( color: Colors.white, // Mengubah warna teks menjadi putih)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
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