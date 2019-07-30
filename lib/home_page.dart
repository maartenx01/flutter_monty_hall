import 'package:flutter/material.dart';
import 'package:pro_final_project/game_door.dart';
import 'package:pro_final_project/database_helpers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameDoor> doorsList;
  var player;
  var api_response;
  var prize;
  var toggle_setting;
  var response_val;
  var decode_val;
  var init_choice;
  var game_result;
  var game_switch_action;
  Record record = Record();
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    doorsList = doInit();
    api_response = getRand();
    game_result = "";
    game_switch_action = "";
  }

  List<GameDoor> doInit() {
    player = new List();

    var gameDoors = <GameDoor>[
      new GameDoor(id: 1, text: "Door: 1"),
      new GameDoor(id: 2, text: "Door: 2"),
      new GameDoor(id: 3, text: "Door: 3"),
    ];
    return gameDoors;
  }

  Future<http.Response> getRand() async {
    return await http.get('https://qrng.anu.edu.au/API/jsonI.php?length=1&type=uint8');
  }

  setSetting(int val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('setting', val);
  }

  getSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int setting = (prefs.getInt('setting') ?? 0);
    print('Toggle: $setting');
    return setting;
  }

  void playGame(List<GameDoor> lst, int index) async {
    setState(() {
      lst[index].text = "Guess";
      lst[index].background = Colors.indigo;
      lst[index].enabled = false;
      lst[(index + 1) % 3].enabled = false;
      lst[(index + 2) % 3].enabled = false;
      init_choice = index;
      });
    api_response.then((val) =>
        setState(() {
          response_val = val;
          decode_val = json.decode(response_val.body);
          prize = decode_val['data'][0] % 3;
        })
    );
  }

  void martyReveal(List<GameDoor> lst) async {
    setState(() {
      if (lst[0].text == "Guess" && prize == 1) {
        lst[2].text = "Goat";
        lst[2].background = Colors.brown;
      }
      if (lst[1].text == "Guess" && prize == 0) {
        lst[2].text = "Goat";
        lst[2].background = Colors.brown;
      }

      if (lst[0].text == "Guess" && prize == 2) {
        lst[1].text = "Goat";
        lst[1].background = Colors.brown;
      }
      if (lst[2].text == "Guess" && prize == 0) {
        lst[1].text = "Goat";
        lst[1].background = Colors.brown;
      }

      if (lst[2].text == "Guess" && prize == 1) {
        lst[0].text = "Goat";
        lst[0].background = Colors.brown;
      }
      if (lst[1].text == "Guess" && prize == 2) {
        lst[0].text = "Goat";
        lst[0].background = Colors.brown;
      }
      if (lst[1].text == "Guess" && prize == 1) {
        lst[0].text = "Goat";
        lst[0].background = Colors.brown;
      }
      if (lst[2].text == "Guess" && prize == 2) {
        lst[1].text = "Goat";
        lst[1].background = Colors.brown;
      }
      if (lst[0].text == "Guess" && prize == 0) {
        lst[2].text = "Goat";
        lst[2].background = Colors.brown;
      }
    });
  }

  void toggle(List<GameDoor> lst) async {
    toggle_setting = await getSetting();
    if (toggle_setting == 0) {
      if ((lst[0].background == Colors.indigo &&
          lst[1].background == Colors.green) ||
          (lst[1].background == Colors.indigo &&
              lst[0].background == Colors.green) ||
          (lst[0].background == Colors.indigo &&
              lst[2].background == Colors.green) ||
          (lst[2].background == Colors.indigo &&
              lst[0].background == Colors.green) ||
          (lst[1].background == Colors.indigo &&
              lst[2].background == Colors.green) ||
          (lst[2].background == Colors.indigo &&
              lst[1].background == Colors.green)) {
        // do nothing
      } else {
        setState(() {
          if (lst[0].background == Colors.indigo &&
              lst[1].background == Colors.grey) {
            lst[0].background = Colors.grey;
            lst[0].text = "Door: 1";
            lst[1].background = Colors.indigo;
            lst[1].text = "Guess";
          } else if (lst[1].background == Colors.indigo &&
              lst[2].background == Colors.grey) {
            lst[1].background = Colors.grey;
            lst[1].text = "Door: 2";
            lst[2].background = Colors.indigo;
            lst[2].text = "Guess";
          } else if (lst[2].background == Colors.indigo &&
              lst[0].background == Colors.grey) {
            lst[2].background = Colors.grey;
            lst[2].text = "Door: 3";
            lst[0].background = Colors.indigo;
            lst[0].text = "Guess";
          } else if (lst[0].background == Colors.indigo &&
              lst[2].background == Colors.grey) {
            lst[0].background = Colors.grey;
            lst[0].text = "Door: 1";
            lst[2].background = Colors.indigo;
            lst[2].text = "Guess";
          } else if (lst[2].background == Colors.indigo &&
              lst[1].background == Colors.grey) {
            lst[2].background = Colors.grey;
            lst[2].text = "Door: 3";
            lst[1].background = Colors.indigo;
            lst[1].text = "Guess";
          } else if (lst[1].background == Colors.indigo &&
              lst[0].background == Colors.grey) {
            lst[1].background = Colors.grey;
            lst[1].text = "Door: 2";
            lst[0].background = Colors.indigo;
            lst[0].text = "Guess";
          }
        });
      };
    }
    print(decode_val);
    print(decode_val['data'][0]);
    print("toogle prize_door: $prize");
  }

  void winner(List<GameDoor> lst) async {
    setState(() {
      if (lst[0].text == "Guess" && prize == 1) {
        lst[0].text = "Better Luck Next Time";
        lst[1].text = "Pot of Gold";
        lst[1].background = Colors.green;
        game_result = "Loss";
        print("result $game_result");
      }
      if (lst[1].text == "Guess" && prize == 0) {
        lst[1].text = "Better Luck Next Time";
        lst[0].text = "Pot of Gold";
        lst[0].background = Colors.green;
        game_result = "Loss";
        print("result $game_result");
      }

      if (lst[0].text == "Guess" && prize == 2) {
        lst[0].text = "Better Luck Next Time";
        lst[2].text = "Pot of Gold";
        lst[2].background = Colors.green;
        game_result = "Loss";
        print("result $game_result");
      }
      if (lst[2].text == "Guess" && prize == 0) {
        lst[2].text = "Better Luck Next Time";
        lst[0].text = "Pot of Gold";
        lst[0].background = Colors.green;
        game_result = "Loss";
        print("result $game_result");
      }

      if (lst[2].text == "Guess" && prize == 1) {
        lst[2].text = "Better Luck Next Time";
        lst[1].text = "Pot of Gold";
        lst[1].background = Colors.green;
        game_result = "Loss";
        print("result $game_result");
      }
      if (lst[1].text == "Guess" && prize == 2) {
        lst[1].text = "Better Luck Next Time";
        lst[2].text = "Pot of Gold";
        lst[2].background = Colors.green;
        game_result = "Loss";
        print("result $game_result");
      }

      if (lst[1].text == "Guess" && prize == 1) {
        lst[1].text = "Winner, Winner, Chicken Dinner!";
        lst[1].background = Colors.green;
        game_result = "Win";
        print("result $game_result");
      }
      if (lst[2].text == "Guess" && prize == 2) {
        lst[2].text = "Winner, Winner, Chicken Dinner!";
        lst[2].background = Colors.green;
        game_result = "Win";
        print("result $game_result");
      }
      if (lst[0].text == "Guess" && prize == 0) {
        lst[0].text = "Winner, Winner, Chicken Dinner!";
        lst[0].background = Colors.green;
        game_result = "Win";
        print("result $game_result");
      }

      if (game_result == "Win") {
        if (lst[init_choice].background == Colors.green) {
          game_switch_action = "No Switch";
        } else {
          game_switch_action = "Switched";
        }
      } else {
        if (lst[init_choice].background == Colors.indigo) {
          game_switch_action = "No Switch";
        } else {
          game_switch_action = "Switched";
        }
      }
      print("result $game_result");
      record.result = game_result;
      record.switched = game_switch_action;
    });
    int id = await helper.insert(record);
    print('inserted row: $id');
    print(decode_val);
    print(decode_val['data'][0]);
    print("check_winner prize_door: $prize");
    print("result $game_result");
    print("decision $game_switch_action");
    print("record $record");
  }

  void resetGame() async {
    setState(() {
      doorsList = doInit();
      api_response = getRand();
    });
    print("reset");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Marty Hall: Let's Make a Deal!"),
        ),
        drawer: new Drawer(
          child: ListView(
            children: <Widget>[
              new ListTile(
                title: new Text("Switch Toggle Preference"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      // return object of type Dialog
                      return AlertDialog(
                        title: new Text("Switch Toggle Setting"),
                        content: new Text("This will enable/diable switch button"),
                        actions: <Widget>[
                          // usually buttons at the bottom of the dialog
                          new FlatButton(
                            child: new Text("Enable"),
                            onPressed: () {
                              setSetting(0);
                              Navigator.of(context).pop();
                            },
                          ),
                          new FlatButton(
                            child: new Text("Disable"),
                            onPressed: () {
                              setSetting(1);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              ),
              new ListTile(
                title: new Text("View Results"),
                onTap: () {
                  // database
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DatabaseView()),
                  );
                }),
            ],
          ),
        ),
        body: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.all(9.0),
                child: new Text("Pick a door.")
              ),
              new Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 9.0),
                  itemCount: doorsList.length,
                  itemBuilder: (context, i) => new SizedBox(
                    width: 100,
                    height: 100,
                      child: new RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      onPressed: doorsList[i].enabled ? ()=> playGame(doorsList, i) : null,
                      child: new Text(
                        doorsList[i].text,
                        style: new TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      color: doorsList[i].background,
                      disabledColor: doorsList[i].background,
                    ),
                  ),
                ),
              ),
              new RaisedButton(
                child: new Text(
                  "Reveal goat",
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.deepOrangeAccent,
                padding: const EdgeInsets.all(20.0),
                onPressed: ()=> martyReveal(doorsList),
              ),
              new RaisedButton(
                child: new Text(
                  "Switch doors",
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.orangeAccent,
                padding: const EdgeInsets.all(20.0),
                onPressed: ()=> toggle(doorsList),
              ),
              new RaisedButton(
                child: new Text(
                  "Show Me the Money!",
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.deepOrange,
                padding: const EdgeInsets.all(20.0),
                onPressed: ()=> winner(doorsList),
              ),
              new RaisedButton(
                child: new Text(
                  "Replay",
                  style: new TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                color: Colors.orange,
                padding: const EdgeInsets.all(20.0),
                onPressed: resetGame,
              )
            ],
        )
    );
  }
}

class DatabaseView extends StatelessWidget {
  DatabaseHelper helper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Previous Results")),
      body: FutureBuilder<List<Record>>(
        future: DatabaseHelper.instance.getRecords(),
        builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Record item = snapshot.data[index];
                return Container(
                  child: ListTile(
                    leading: Text(item.id.toString()),
                    title: Text(item.result),
                    subtitle: Text(item.switched),
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}