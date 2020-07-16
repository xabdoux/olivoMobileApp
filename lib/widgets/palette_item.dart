import 'package:flutter/material.dart';

class PalettesItem extends StatelessWidget {
  final int index;
  final int sac;
  final double weight;
  final String type;

  PalettesItem(this.index, this.sac, this.weight, {this.type = "principale"});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      height: 70,
      //width: deviceSize.width * 0.9,
      decoration: BoxDecoration(
        color: Color(0xfff5f5f5),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 70,
            width: 60,
            decoration: BoxDecoration(
              color:
                  type == "principale" ? Colors.green[300] : Colors.yellow[600],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                "${index + 1}",
                style: TextStyle(
                    color: type == "principale" ? Colors.white : Colors.black,
                    fontSize: 26,
                    fontFamily: 'Bree'),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  "$sac",
                  style: TextStyle(
                      color: Color(0xff0f3443),
                      fontSize: 26,
                      fontFamily: 'Bree'),
                ),
                Text(
                  "${weight.toStringAsFixed(1)} Kg",
                  style: TextStyle(
                      color: Color(0xff0f3443),
                      fontSize: 26,
                      fontFamily: 'Bree'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
