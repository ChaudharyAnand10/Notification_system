import 'package:flutter/material.dart';

class ShowNotification extends StatefulWidget {
  final List<String> myList;

  const ShowNotification({super.key , required this.myList});

  @override
  State<ShowNotification> createState() => _ShowNotificationState();
}

class _ShowNotificationState extends State<ShowNotification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification List Page"),
         leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);   
      },
    ),
      ),
      body:  ListView.builder(
        itemCount: widget.myList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.myList[index]),
          );
        },
      ),
    );
  }
}