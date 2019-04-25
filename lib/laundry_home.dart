import 'package:dhobhi/modal_sheet.dart';
import 'package:flutter/material.dart';

class LaundryHome extends StatefulWidget {
  @override
  _LaundryHomeState createState() => _LaundryHomeState();
}

class _LaundryHomeState extends State<LaundryHome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Transform.translate(
            child: Image(image: AssetImage('assets/laundry_machine.png')),
            offset: Offset(0, -50),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 45.0,
              child: RaisedButton(
                disabledColor: Colors.blue.shade200,
                color: Colors.blueAccent,
                disabledElevation: 0.0,
                elevation: 3.0,
                splashColor: Colors.blue.shade200,
                child: Text(
                  'Check In',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    fontFamily: 'Avenir-Bold',
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: () => {
                  showCheckInBottomSheet(context)
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 45.0,
              child: RaisedButton(
                disabledColor: Colors.blue.shade200,
                color: Colors.blueAccent,
                disabledElevation: 0.0,
                elevation: 3.0,
                splashColor: Colors.blue.shade200,
                child: Text(
                  'Check Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15.0,
                    fontFamily: 'Avenir-Bold',
                    color: Colors.white,
                  ),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                onPressed: () => {
                  showCheckOutBottomSheet(context)
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
