import "package:flutter/material.dart";

class Walkthrough {
  IconData icon;
  String title;
  String description;
  Widget extraWidget;
  
  Walkthrough({this.icon, this.title, this.description, this.extraWidget}) {
    if (extraWidget == null) {
      extraWidget = new Container();
    }
  }
}