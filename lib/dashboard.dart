// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, use_key_in_widget_constructors, use_build_context_synchronously, unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mq4_mq7_gas_detector/global_var.dart' as globals;
import 'package:mq4_mq7_gas_detector/methane_info.dart';
import 'package:mq4_mq7_gas_detector/monoxide_info.dart';
import 'dart:async';
import 'notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Dashboard extends StatefulWidget {
  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  List<TextEditingController> _data = [TextEditingController()];
  bool status = false;
  Timer? timer;
  double Metana = 0;
  double CO = 0;

  final TextEditingController _monoxideHighController = TextEditingController();
  final TextEditingController _methaneHighController = TextEditingController();
  // final TextEditingController _methaneMedController = TextEditingController();
  // final TextEditingController _methaneLowController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();

  void initState() {
    super.initState();
    _monoxideHighController.text = "150";
    _methaneHighController.text = "50000";
    getEndpoint();
    notif.initialize(flutterLocalNotificationsPlugin);
    timer =
        Timer.periodic(Duration(milliseconds: 500), (Timer t) => updateValue());
  }

  void getEndpoint() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? endpoint = prefs.getString('endpoint');
    if (endpoint != null) {
      setState(() {
        _data[0].text = endpoint;
        globals.endpoint = endpoint;
        print(globals.endpoint);
      });
    } else {
      _data[0].text = "0.0.0.0";
      globals.endpoint = "0.0.0.0";
    }
  }

  void updateValue() async {
    var url = Uri.parse("http://${globals.endpoint}/getValue");
    try {
      final response = await http.get(url).timeout(
        const Duration(seconds: 1),
        onTimeout: () {
          // Time has run out, do what you wanted to do.
          return http.Response(
              'Error', 408); // Request Timeout response status code
        },
      );
      print(response.statusCode);
      // context.loaderOverlay.hide();
      if (response.statusCode == 200) {
        var respon = Json.tryDecode(response.body);
        if (this.mounted) {
          setState(() {
            Metana = respon['mq4']['value'];
            CO = respon['mq7']['value'];
          });
        }
        if (respon['mq4']['notif']['show']) {
          notif.showNotif(
              id: respon['mq4']['notif']['id'],
              head: respon['mq4']['notif']['header'],
              body: respon['mq4']['notif']['body'],
              fln: flutterLocalNotificationsPlugin);
          await http.post(
            Uri.parse("http://${globals.endpoint}/updateNotif"),
            headers: <String, String>{
              'Content-Type':
                  'application/x-www-form-urlencoded; charset=UTF-8',
            },
            body: "sensor=MQ4",
          );
        }
        if (respon['mq7']['notif']['show']) {
          notif.showNotif(
              id: respon['mq7']['notif']['id'],
              head: respon['mq7']['notif']['header'],
              body: respon['mq7']['notif']['body'],
              fln: flutterLocalNotificationsPlugin);
          await http.post(
            Uri.parse("http://${globals.endpoint}/updateNotif"),
            headers: <String, String>{
              'Content-Type':
                  'application/x-www-form-urlencoded; charset=UTF-8',
            },
            body: "sensor=MQ7",
          );
        }
      }
    } on Exception catch (_) {
      // rethrow;
    }
  }

  // final String esp32IPAddress =
  //     '192.168.137.37'; // Ganti dengan alamat IP ESP32 Anda

  void lowerWindow() async {
    var url = Uri.parse('http://${globals.endpoint}/lower-window');
    try {
      var response = await http.post(url, body: {'command': 'lower'});
      if (response.statusCode == 200) {
        print('Window lowered successfully');
      } else {
        print('Failed to lower window');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void methaneSetting(String highValue) async {
    var url = Uri.parse('http://${globals.endpoint}/methane');
    try {
      var response = await http.post(url, body: {
        'high': highValue,
        // 'medium': medValue,
        // 'low': lowValue,
      });
      if (response.statusCode == 200) {
        print('Methane setting updated successfully');
      } else {
        print('Failed to update methane setting');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void monoxideSetting(String highValue) async {
    var url = Uri.parse('http://${globals.endpoint}/monoxide');
    try {
      var response = await http.post(url, body: {
        'high': highValue,
        // 'medium': medValue,
        // 'low': lowValue,
      });
      if (response.statusCode == 200) {
        print('Monoxide setting updated successfully');
      } else {
        print('Failed to update methane setting');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _confirmMethaneSetting() {
    String highValue = _methaneHighController.text;
    // String medValue = _methaneMedController.text;
    // String lowValue = _methaneLowController.text;
    methaneSetting(highValue);

    Navigator.pop(context);
  }

  void _confirmMonoxideSetting() {
    String highValue = _monoxideHighController.text;
    // String medValue = _methaneMedController.text;
    // String lowValue = _methaneLowController.text;
    monoxideSetting(highValue);

    Navigator.pop(context);
  }

  void _resetMethaneSetting() {
    String highValue = "50000";
    // String medValue = _methaneMedController.text;
    // String lowValue = _methaneLowController.text;
    methaneSetting(highValue);
    _methaneHighController.text = highValue;

    Navigator.pop(context);
  }

  void _resetMonoxideSetting() {
    String highValue = "150";
    // String medValue = _methaneMedController.text;
    // String lowValue = _methaneLowController.text;
    _monoxideHighController.text = highValue;
    monoxideSetting(highValue);

    Navigator.pop(context);
  }

  // Future<void> sendCommandToESP32(String command) async {
  //   var url = Uri.parse("http://${globals.endpoint}/command");
  //   print(url);
  //   try {
  //     var response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       print('Window lowered successfully');
  //     } else {
  //       print('Failed to lower window');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        timer?.cancel();
        // Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 44, 138),
            // leading: IconButton(
            //   icon: Icon(Icons.arrow_back),
            //   onPressed: () => Phoenix.rebirth(context),
            // ),
            title: Text(
              "CH₄ & CO Monitoring",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.settings,
                      color: Colors.white, size: 20.0),
                  onPressed: () async {
                    //================================ ALERT UNTUK SETTING API ========================================
                    Alert(
                      context: context,
                      // type: AlertType.info,
                      desc: "Setting API",
                      content: Column(
                        children: <Widget>[
                          SizedBox(
                              height: MediaQuery.of(context).size.width / 15),
                          TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'IP Endpoint',
                              labelStyle: TextStyle(fontSize: 20),
                            ),
                            controller: _data[0],
                          ),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                            child: Text(
                              "Save",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () async {
                              if (_data[0].text.isEmpty) {
                                status = false;
                                Alert(
                                  context: context,
                                  type: AlertType.error,
                                  title: "Value Cannot be Empty!",
                                  buttons: [
                                    DialogButton(
                                      child: Text(
                                        "OK",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                      onPressed: () => Navigator.pop(context),
                                    )
                                  ],
                                ).show();
                              } else {
                                var url = Uri.parse(
                                    'http://' + _data[0].text + '/getValue');
                                try {
                                  final response = await http.get(url).timeout(
                                    const Duration(
                                        seconds: globals.httpTimeout),
                                    onTimeout: () {
                                      // Time has run out, do what you wanted to do.
                                      return http.Response('Error',
                                          408); // Request Timeout response status code
                                    },
                                  );
                                  // context.loaderOverlay.hide();
                                  if (response.statusCode == 200) {
                                    Alert(
                                      context: context,
                                      type: AlertType.success,
                                      title: "Connection OK",
                                      buttons: [
                                        DialogButton(
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20),
                                            ),
                                            onPressed: () async {
                                              final SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              setState(() {
                                                globals.endpoint =
                                                    _data[0].text;
                                                prefs.setString(
                                                    "endpoint", _data[0].text);
                                              });
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            })
                                      ],
                                    ).show();
                                  } else {
                                    Alert(
                                      context: context,
                                      type: AlertType.error,
                                      title: "Connection Failed!",
                                      desc: "Please check Endpoint IP",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "OK",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        )
                                      ],
                                    ).show();
                                  }
                                } on Exception catch (_) {
                                  Alert(
                                    context: context,
                                    type: AlertType.error,
                                    title: "Connection Failed!",
                                    desc: "Please check Endpoint IP",
                                    buttons: [
                                      DialogButton(
                                        child: Text(
                                          "OK",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                      )
                                    ],
                                  ).show();
                                  // rethrow;
                                }
                              }
                            }),
                      ],
                    ).show();

                    //================================ END ALERT UNTUK SETTING API ========================================
                  })
            ],
          ),
          body: StaggeredGridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0,
            mainAxisSpacing: 12.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            children: <Widget>[
              // DropdownItem(sendCommand: sendCommandToESP32),
              myCard("Metana (CH₄)", Metana.toString() + ' ppm',
                  Icon(Icons.gas_meter, color: Colors.white, size: 30.0),
                  onTap: () {
                Alert(
                  context: context,
                  title: 'Set Methane High Value',
                  content: Column(
                    children: <Widget>[
                      TextField(
                        controller: _methaneHighController,
                        keyboardType: TextInputType
                            .number, // Tipe keyboard untuk memasukkan angka
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly // Memastikan hanya digit yang diterima
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Methane High Value',
                        ),
                      ),
                      // TextField(
                      //   controller: _methaneMedController,
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'Enter Methane Medium Value',
                      //   ),
                      // ),
                      // TextField(
                      //   controller: _methaneLowController,
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'Enter Methane Low Value',
                      //   ),
                      // ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: _confirmMethaneSetting,
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    DialogButton(
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: _resetMethaneSetting,
                    ),
                    DialogButton(
                      child: Text(
                        "Info",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MethaneInfoPage()),
                        );
                      },
                    ),
                  ],
                ).show();
              }),
              myCard("Carbon Monoxide (CO)", CO.toString() + ' ppm',
                  Icon(Icons.gas_meter, color: Colors.white, size: 30.0),
                  onTap: () {
                Alert(
                  context: context,
                  title: 'Set Monoxide High Value',
                  content: Column(
                    children: <Widget>[
                      TextField(
                        controller: _monoxideHighController,
                        keyboardType: TextInputType
                            .number, // Tipe keyboard untuk memasukkan angka
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly // Memastikan hanya digit yang diterima
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Enter Methane High Value',
                        ),
                      ),
                      // TextField(
                      //   controller: _methaneMedController,
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'Enter Methane Medium Value',
                      //   ),
                      // ),
                      // TextField(
                      //   controller: _methaneLowController,
                      //   decoration: InputDecoration(
                      //     border: OutlineInputBorder(),
                      //     labelText: 'Enter Methane Low Value',
                      //   ),
                      // ),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: _confirmMonoxideSetting,
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                    DialogButton(
                      child: Text(
                        "Reset",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: _resetMonoxideSetting,
                    ),
                    DialogButton(
                      child: Text(
                        "Info",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MonoxideInfoPage()),
                        );
                      },
                    ),
                  ],
                ).show();
              }),
              ElevatedButton(
                onPressed: lowerWindow,
                child: Text('Lower Window'),
              ),
              // ElevatedButton(
              //   onPressed: _confirmMethaneSetting,
              //   child: Text('Set Methane High Value'),
              // ),
            ],
            staggeredTiles: [
              StaggeredTile.extent(2, 110.0),
              StaggeredTile.extent(2, 110.0),
              StaggeredTile.extent(2, 70.0),
              StaggeredTile.extent(2, 70.0),
              StaggeredTile.extent(2, 70.0),
            ],
          )),
    );
  }

  Widget _buildTile(Widget child, {Function()? onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  Widget myCard(String title, String value, Widget icon, {Function()? onTap}) {
    return _buildTile(
      Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title,
                      style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600)),
                  Text(value,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 28.0))
                ],
              ),
              Material(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(24.0),
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: icon,
                  )))
            ]),
      ),
      onTap: onTap,
    );
  }

  Widget myCard2(String title, String value, Widget icon) {
    return _buildTile(
      Padding(
          padding: const EdgeInsets.all(24.0),
          child: Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: TextStyle(
                        color: Colors.blueAccent, fontWeight: FontWeight.w600)),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(value),
                ),
              ],
            ),
          )),
    );
  }
}

class Json {
  static String? tryEncode(data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      return null;
    }
  }

  static dynamic tryDecode(data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return null;
    }
  }
}

class DropdownItem extends StatefulWidget {
  final Function(String) sendCommand;

  DropdownItem({required this.sendCommand});

  @override
  _DropdownItemState createState() => _DropdownItemState();
}

class _DropdownItemState extends State<DropdownItem> {
  String _selectedValue = 'Off';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Select an option:'),
            DropdownButton<String>(
              value: _selectedValue,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedValue = newValue!;
                });
                widget.sendCommand(_selectedValue);
              },
              items: <String>['On', 'Off']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
