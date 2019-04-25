import 'package:flutter/material.dart';
import 'package:rounded_modal/rounded_modal.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert' as JSON;
import 'package:dhobhi/api_static.dart';
import 'package:dhobhi/circulation_post.dart';
import 'package:fluttertoast/fluttertoast.dart';

Widget buildTextField(IconData icon, String labelText,
    TextEditingController controller, BuildContext context) {
  return Padding(
    padding:
        const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Icon(icon),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(10.0),
              labelText: labelText,
              labelStyle: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Avenir-Black',
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
              border: UnderlineInputBorder(),
            ),
            style: TextStyle(
              fontSize: 15.0,
              fontFamily: 'Avenir-Bold',
              color: Colors.black87,
            ),
            cursorColor: Colors.red,
            controller: controller,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    ),
  );
}

void showCheckInBottomSheet(BuildContext context) {
  showRoundedModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return ModalSheetContent(check: true);
    },
  );
}

void showCheckOutBottomSheet(BuildContext context) {
  showRoundedModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return ModalSheetContent(check: false);
    },
  );
}

class ModalSheetContent extends StatefulWidget {
  @override
  _ModalSheetContentState createState() => _ModalSheetContentState();

  final bool check;
  ModalSheetContent({this.check});
}

class _ModalSheetContentState extends State<ModalSheetContent> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController clothesController = TextEditingController();

  String buttonText = 'ENTER CARD NO';
  bool enableCheckInButton = false;
  bool enableCheckOutButton = false;

  @override
  void initState() {
    super.initState();
    cardNumberController.addListener(validate);
    clothesController.addListener(validate);
  }

  void validate() {
    if (widget.check) {
      if (cardNumberController.text.length != 4) {
        setState(() {
          buttonText = "ENTER VALID CARD NO";
          enableCheckInButton = false;
        });
      } else if (clothesController.text == '') {
        setState(() {
          buttonText = "ENTER CLOTHES";
          enableCheckInButton = false;
        });
      } else if (int.parse(clothesController.text) > 15) {
        setState(() {
          buttonText = "ENTER VALID CLOTHES";
          enableCheckInButton = false;
        });
      } else {
        setState(() {
          buttonText = "CHECK IN";
          enableCheckInButton = true;
        });
      }
    } else {
      if (cardNumberController.text.length != 4) {
        setState(() {
          buttonText = "ENTER VALID CARD NO";
          enableCheckOutButton = false;
        });
      } else {
        setState(() {
          buttonText = "CHECK OUT";
          enableCheckOutButton = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.check) {
      return buildCheckIn();
    } else {
      return buildCheckOut();
    }
  }

  Widget buildCheckIn() {
    return Container(
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height * 0.45,
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 5.0, left: 15.0),
            child: Text(
              'Check In',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                fontFamily: 'Avenir-Black',
              ),
            ),
          ),
          buildTextField(
              Icons.credit_card, 'Card Number', cardNumberController, context),
          buildTextField(Icons.dehaze, 'Clothes', clothesController, context),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 45.0,
                child: RaisedButton(
                  disabledColor: Colors.blue.shade200,
                  color: Colors.blue,
                  disabledElevation: 0.0,
                  elevation: 3.0,
                  splashColor: Colors.blue.shade200,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      fontFamily: 'Avenir-Bold',
                      color: Colors.white,
                    ),
                  ),
                  onPressed: enableCheckInButton ? () => checkIn() : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<http.Response> createCheckInPost(CheckInPost post) async {
    final response = await http.post(CirculationStatic.keyCheckInURL,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: postCheckInToJson(post));

    return response;
  }

  Future<http.Response> createCheckOutPost(CheckOutPost post) async {
    final response = await http.post(CirculationStatic.keyCheckOutURL,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: postCheckOutToJson(post));

    return response;
  }

  checkIn() {
    CheckInPost post = CheckInPost(
        cardNumber: cardNumberController.text, clothes: clothesController.text);

    createCheckInPost(post).then((response) {
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Checked In Successfully!",
          fontSize: 13.0,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIos: 1,
        );
      } else if (response.statusCode == 400) {
        var json = JSON.jsonDecode(response.body);
        assert(json is Map);
        List msg = json["card_no"];
        if (msg[0] == "This field must be unique.") {
          Fluttertoast.showToast(
            msg:
                "Card number ${cardNumberController.text} is already checked in.",
            fontSize: 13.0,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIos: 1,
          );
        } else {
          Fluttertoast.showToast(
            msg: "Card number ${cardNumberController.text} is invalid.",
            fontSize: 13.0,
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIos: 1,
          );
        }
      }
    }).catchError((error) {
      print('error : $error');
    });
  }

  checkOut() {
    CheckOutPost post = CheckOutPost(cardNumber: cardNumberController.text);

    createCheckOutPost(post).then((response) {
      if (response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: "Checked Out Successfully!",
          fontSize: 13.0,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIos: 1,
        );
      } else if (response.statusCode == 500) {
        Fluttertoast.showToast(
          msg:
              "Card number ${cardNumberController.text} is not checked in.",
          fontSize: 13.0,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIos: 1,
        );
      } else if (response.statusCode == 400) {
        Fluttertoast.showToast(
          msg: "Card number ${cardNumberController.text} is invalid.",
          fontSize: 13.0,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIos: 1,
        );
      } else {
        print(response.statusCode);
      }
    }).catchError((Object error) {
      Fluttertoast.showToast(
        msg: "Oops! Please check your Internet.",
        fontSize: 13.0,
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIos: 1,
      );
    }).catchError((error) {
      print("error : $error");
    });
  }

  Widget buildCheckOut() {
    return Container(
      alignment: Alignment.topCenter,
      height: MediaQuery.of(context).size.height * 0.35,
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 5.0, left: 15.0),
            child: Text(
              'Check Out',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
                fontFamily: 'Avenir-Black',
              ),
            ),
          ),
          buildTextField(
              Icons.credit_card, 'Card Number', cardNumberController, context),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 45.0,
                child: RaisedButton(
                  disabledColor: Colors.blue.shade200,
                  color: Colors.blue,
                  disabledElevation: 0.0,
                  elevation: 3.0,
                  splashColor: Colors.blue.shade200,
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      fontFamily: 'Avenir-Bold',
                      color: Colors.white,
                    ),
                  ),
                  onPressed: enableCheckOutButton ? () => checkOut() : null,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
