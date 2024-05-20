import 'package:flutter/material.dart';

class TimeShiftBox extends StatelessWidget {
  const TimeShiftBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        Container(
          width: 170,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black)
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                children: [
                  Text("08:00",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text("Check In"),

                ],
              ),
            ),
          ),
        ),

        Container(

          width: 170,
          height: 80,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black)
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Column(
                children: [
                  Text("17:00",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text("Check Out"),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
