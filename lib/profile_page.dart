import 'dart:ffi';

import 'package:covid_help/Quiz.dart';
import 'package:draw_graph/draw_graph.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:draw_graph/models/feature.dart';

class UserProfilePage extends StatefulWidget {
  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {


  _UserProfilePageState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _profileView(),
      );
  }
}

Widget _profileView() {
  return Container(
    //child: SizedBox(height: 20),
    child: HeaderSection(
    ),
    //SizedBox(height: 40),
    //],
  );
}

class HeaderSection extends StatelessWidget {
  var fam;
  HeaderSection({
    Key key,
  }) : super();


  void handleClick(String value, BuildContext context) {
    switch (value) {
      case 'Logout':
        print("logout");
        break;
      case 'Settings':
        break;
      case 'Take Survey':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Survey(),
          ),
        );
        break;
    }
  }

  final List<Feature> features = [
    Feature(
      title: "M 1",
      color: Colors.blue,
      data: [0.3, 0.6, 0.8, 0.9, 1, 1.2],
    ),
    Feature(
      title: "M 2",
      color: Colors.black,
      data: [1, 0.8, 0.6, 0.7, 0.3, 0.1],
    ),
    Feature(
      title: "M 3",
      color: Colors.orange,
      data: [0.4, 0.2, 0.9, 0.5, 0.6, 0.4],
    ),
  ];


  @override
  Widget build(BuildContext context) {
    final FirebaseDatabase fb = FirebaseDatabase.instance;
    final ref = fb.reference();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
              fontFamily: 'Roboto', color: Colors.black, fontSize: 28),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: (choice) => handleClick(choice, context),
            itemBuilder: (BuildContext context) {
              return {'Logout', 'Settings', 'Take Survey'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(
                    choice,
                    style: TextStyle(fontFamily: 'Roboto'),
                  ),
                );
              }).toList();
            },
          ),
        ],
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  image: DecorationImage(
                      image: AssetImage("images/3658058.jpg"), fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: FutureBuilder(
                    future: ref.once(),
                    builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        values.forEach((key, values) {
                        });
                        return Text(
                                values["Profile"]["Name"].toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    fontFamily: 'Roboto'),
                              );
                      }
                      return CircularProgressIndicator();
                    })

              ),

              Container(
                  alignment: Alignment.center,
                  child: FutureBuilder(
                      future: ref.once(),
                      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic> values = snapshot.data.value;
                          values.forEach((key, values) {
                          });
                          return Text(
                            values["Profile"]["Username"].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 18,
                                fontFamily: 'Roboto'),
                          );
                        }
                        return CircularProgressIndicator();
                      })
              ),
              Container(
                  alignment: Alignment.center,
                  child: FutureBuilder(
                      future: ref.once(),
                      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic> values = snapshot.data.value;
                          values.forEach((key, values) {
                          });
                          return Text(
                            values["Profile"]["Bio"].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                fontFamily: 'Roboto'),
                          );
                        }
                        return CircularProgressIndicator();
                      })

              ),
              SizedBox(height: 15),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.center,
                child: LineGraph(
                  features: features,
                  size: Size(380, 280),
                  labelX: ['Day 1', 'Day 2', 'Day 3', 'Day 4', 'Day 5', 'Day 6'],
                  labelY: ['25%', '45%', '65%', '75%', '85%', '100%'],
                  showDescription: true,
                  graphColor: Colors.black87,
                ),
              ),
              SizedBox(height: 25),

              Container(
                  alignment: Alignment.center,
                  child: FutureBuilder(
                      future: ref.once(),
                      builder: (context, AsyncSnapshot<DataSnapshot> snapshot) {
                        if (snapshot.hasData) {
                          Map<dynamic, dynamic> values = snapshot.data.value;
                          values.forEach((key, values) {
                          });
                          fam = values["Family Member"];
                          return Text(
                            "Family Members",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                fontFamily: 'Roboto'),
                          );
                        }
                        return CircularProgressIndicator();
                      })
              ),

              SizedBox(height: 20),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child:Column(
                    children: <Widget>[
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(10.0),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Dismissible(
                              background: Container(
                                alignment: Alignment.centerLeft,
                                color: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.delete),
                                ),
                              ),
                              key: ValueKey(index),
                              child: Card(
                                margin: const EdgeInsets.all(0.0),
                                child: ListTile(
                                  leading: IconButton(
                                    onPressed: () {},
                                    icon: Icon(Icons.data_usage),
                                  ),
                                  trailing: Icon(Icons.arrow_forward_ios),
                                  title: Text(fam["Fm"+(index+1).toString()]["Name"].toString()),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(fam["Fm"+(index+1).toString()]["Relation"].toString()),
                                      Text(""),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
