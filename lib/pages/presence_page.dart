import 'package:flutter/material.dart';

class PresencePage extends StatefulWidget {
  const PresencePage({Key? key}) : super(key: key);

  @override
  _PresencePageState createState() => _PresencePageState();
}

class _PresencePageState extends State<PresencePage> {
  String? selectedStatus;
  String hintText = 'Status';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Presence"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Text("Ambil Foto selfie"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                width: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  shape: BoxShape.rectangle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  size: 150,
                  color: Colors.blue,
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Nama Pegawai", border: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "ID Pegawai", border: InputBorder.none),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: DropdownButton<String>(
                    hint: Text(hintText),
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue;
                        hintText = newValue ?? 'Status';
                      });
                    },
                    items: <String>['Check In', 'Check Out', 'Izin']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Presence Status: ${selectedStatus ?? 'Select a status'}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Keterangan", border: InputBorder.none),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
