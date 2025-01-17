import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:vigenesia/Constant/const.dart';
import 'package:vigenesia/Models/like_model.dart';
import 'package:vigenesia/Models/motivasi_model.dart';
// import 'package:vigenesia/Models/profile_model.dart'; // Impor kelas ProfileModel
import 'package:http/http.dart' as http;

class MotivasiAll extends StatefulWidget {
  final String? idUser;
  const MotivasiAll({Key? key, this.idUser}) : super(key: key);

  @override
  _MotivasiAllState createState() => _MotivasiAllState();
}

class _MotivasiAllState extends State<MotivasiAll> {
  String baseurl = url;
  var dio = Dio();

  Future<List<MotivasiModel>> getData() async {
    var response = await dio.get('$baseurl/vigenesia/api/Get_motivasi');
    print(" ${response.data}");

    if (response.statusCode == 200) {
      var getUsersData = response.data as List;
      var listUsers = getUsersData.map((i) => MotivasiModel.fromJson(i)).toList();
      return listUsers;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<LikeModel?> getLike(String? idUser, String? idMotivasi) async {
    if (idUser == null || idMotivasi == null) {
      return null;
    }

    final response = await http.get(Uri.parse(
        "$baseurl/vigenesia/api/likes?id_motivasi=${idMotivasi}&id_user=${idUser}"));

    if (response.statusCode == 200) {
      return LikeModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<dynamic> putLike(String idUser, String idMotivasi) async {
    Map<String, dynamic> data = {
      "id_user": idUser,
      "id_motivasi": idMotivasi,
    };

    var response = await dio.put('$baseurl/vigenesia/api/likes',
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ));
    print("---> ${response.data} + ${response.statusCode}");
    return response.data;
  }

  Future<String?> fetchNameFromDatabase(String? idUser) async {
    if (idUser == null) return 'Nama tidak tersedia';
    var response = await dio.get('$baseurl/vigenesia/api/Get_nama?id_user=$idUser');
    print("Response status: ${response.statusCode}");
    print("Response data: ${response.data}");

    if (response.statusCode == 200) {
      return response.data['nama'];
    }
    return 'Nama tidak tersedia';
  }

  var isElipsis = true;

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
                        "Motivasi By All",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isElipsis = !isElipsis;
                          });
                        },
                        child: Text("Refresh/More.."),
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
                        FutureBuilder(
                          future: getData(),
                          builder: (BuildContext context, AsyncSnapshot<List<MotivasiModel>> snapshot) {
                            if (snapshot.hasData) {
                              return Column(
                                children: [
                                  for (var item in snapshot.data!)
                                    Card(
                                      margin: EdgeInsets.only(bottom: 25.0, top: 8),
                                      child: Padding(
                                        padding: EdgeInsets.all(30.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                FutureBuilder<String?>(
                                                  future: fetchNameFromDatabase(item.idUser),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return CircularProgressIndicator();
                                                    } else if (snapshot.hasError) {
                                                      return Text('Error: ${snapshot.error}');
                                                    } else if (snapshot.hasData) {
                                                      return Row(
                                                        children: [
                                                          Icon(
                                                            CupertinoIcons.person_crop_circle,
                                                            color: CupertinoColors.activeBlue,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            snapshot.data ?? 'Nama tidak tersedia',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.w500,
                                                              color: CupertinoColors.activeBlue,
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    } else {
                                                      return Text('Nama tidak tersedia');
                                                    }
                                                  },
                                                ),
                                                FutureBuilder(
                                                  future: getLike(widget.idUser, item.id),
                                                  builder: (context, snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return CircularProgressIndicator();
                                                    }
                                                    if (snapshot.hasData) {
                                                      var isLiked = (snapshot.data?.likes != null &&
                                                          int.parse(snapshot.data?.likes ?? '0') > 0)
                                                          ? true
                                                          : false;
                                                      int count = int.parse(snapshot.data?.likes ?? '0');

                                                      return StatefulBuilder(
                                                        builder: (context, setState) {
                                                          return LikeButton(
                                                            size: 20,
                                                            circleColor: CircleColor(
                                                              start: Color(0xff00ddff),
                                                              end: Color(0xff0099cc),
                                                            ),
                                                            bubblesColor: BubblesColor(
                                                              dotPrimaryColor: Color(0xff33b5e5),
                                                              dotSecondaryColor: Color(0xff0099cc),
                                                            ),
                                                            likeBuilder: (bool isCurrentlyLiked) {
                                                              return Icon(
                                                                CupertinoIcons.heart_fill,
                                                                color: isLiked ? Colors.red : Colors.grey,
                                                                size: 20,
                                                              );
                                                            },
                                                            likeCount: count,
                                                            countBuilder: (int? likeCount, bool isCurrentlyLiked, String text) {
                                                              var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                                                              Widget result;
                                                                                                                            if (likeCount == null || likeCount == 0) {
                                                                result = Text(
                                                                  "",
                                                                  style: TextStyle(color: color),
                                                                );
                                                              } else {
                                                                result = Text(
                                                                  text,
                                                                  style: TextStyle(color: color),
                                                                );
                                                              }
                                                              return result;
                                                            },
                                                            onTap: (bool isCurrentlyLiked) async {
                                                              await putLike(widget.idUser ?? '', item.id ?? '')
                                                                  .then((value) {
                                                                if (value != '') {
                                                                  print(isCurrentlyLiked ? "unliked" : "liked");
                                                                }
                                                              });
                                                              setState(() {
                                                                isLiked = !isCurrentlyLiked;
                                                                count = isLiked ? count + 1 : count - 1;
                                                              });
                                                              return !isCurrentlyLiked;
                                                            },
                                                          );
                                                        },
                                                      );
                                                    } else {
                                                      return LikeButton(
                                                        size: 20,
                                                        circleColor: CircleColor(
                                                          start: Color(0xff00ddff),
                                                          end: Color(0xff0099cc),
                                                        ),
                                                        bubblesColor: BubblesColor(
                                                          dotPrimaryColor: Color(0xff33b5e5),
                                                          dotSecondaryColor: Color(0xff0099cc),
                                                        ),
                                                        likeBuilder: (bool isCurrentlyLiked) {
                                                          return Icon(
                                                            CupertinoIcons.heart_fill,
                                                            color: isCurrentlyLiked ? Colors.red : Colors.grey,
                                                            size: 20,
                                                          );
                                                        },
                                                        likeCount: int.parse(item.likes ?? '0'),
                                                        countBuilder: (int? likeCount, bool isCurrentlyLiked, String text) {
                                                          var color = isCurrentlyLiked ? Colors.deepPurpleAccent : Colors.grey;
                                                          Widget result;
                                                          if (likeCount == null || likeCount == 0) {
                                                            result = Text(
                                                              "",
                                                              style: TextStyle(color: color),
                                                            );
                                                          } else {
                                                            result = Text(
                                                              text,
                                                              style: TextStyle(color: color),
                                                            );
                                                          }
                                                          return result;
                                                        },
                                                        onTap: (bool isCurrentlyLiked) async {
                                                          await putLike(widget.idUser ?? '', item.id ?? '')
                                                              .then((value) {
                                                            if (value != '') {
                                                              print(isCurrentlyLiked ? "unliked" : "liked");
                                                            }
                                                          });
                                                          setState(() {
                                                            int likeCount = int.parse(item.likes ?? '0');
                                                            bool isLiked = !isCurrentlyLiked;
                                                            likeCount = isLiked ? likeCount + 1 : likeCount - 1;
                                                          });
                                                          return !isCurrentlyLiked;
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              item.isiMotivasi ?? 'Motivasi tidak tersedia',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 1.2,
                                                color: CupertinoColors.systemGrey,
                                                height: 1.35,
                                              ),
                                              textAlign: TextAlign.justify,
                                              overflow: isElipsis ? TextOverflow.ellipsis : TextOverflow.visible,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
