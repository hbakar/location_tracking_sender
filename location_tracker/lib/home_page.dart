import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late IO.Socket socket;
  double? latitude;
  double? longitude;
  static final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io("http://192.168.1.156:3700", <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connect();

      socket.onConnect((data) => {print("Connect: ${socket.id}")});
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: globalKey,
          child: Column(children: [
            FormHelper.inputFieldWidget(
              context,
              "Latitude",
              "Latitude",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return '* Required';
                }
                return null;
              },
              (onSaved) {
                latitude = double.parse(onSaved);
              },
              borderRadius: 10,
            ),
            SizedBox(
              height: 10,
            ),
            FormHelper.inputFieldWidget(
              context,
              "Longitude",
              "Longitude",
              (onValidate) {
                if (onValidate.isEmpty) {
                  return '* Required';
                }
                return null;
              },
              (onSaved) {
                longitude = double.parse(onSaved);
              },
              borderRadius: 10,
            ),
            SizedBox(
              height: 10,
            ),
            FormHelper.submitButton("Send Location", () {
              if (validateAndSave()) {
                var coords = {
                  "lat": latitude,
                  "lng": longitude,
                };

                socket.emit('position-change', jsonEncode(coords));
              }
            })
          ]),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
