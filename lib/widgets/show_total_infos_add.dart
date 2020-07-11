import 'package:flutter/material.dart';

class ShowTotalInfosAdd extends StatelessWidget {
  final int totalPalettes;
  final int totalSac;
  final double totalWeight;
  ShowTotalInfosAdd(
      {@required this.totalSac,
      @required this.totalWeight,
      this.totalPalettes});
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
      height: 110,
      width: deviceSize.width * 0.9,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.white,
            Color(0xffCCCCCC),
          ]),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 1),
            )
          ]),
      child: Column(
        children: <Widget>[
          Container(
            height: 70,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/pallet.png',
                        height: 40,
                      ),
                      Text(
                        '$totalPalettes',
                        style: TextStyle(
                            color: Color(0xff0f3443),
                            fontSize: 26,
                            fontFamily: 'Bree'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/sacks.png',
                        height: 28,
                      ),
                      Text(
                        "$totalSac",
                        // service.customer.palettes.fold(0,
                        //     (totalSac, palette) {
                        //   return totalSac += palette.nombreSac;
                        // }).toString(),
                        style: TextStyle(
                            color: Color(0xff0f3443),
                            fontSize: 26,
                            fontFamily: 'Bree'),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/measure.png',
                        height: 30,
                      ),
                      FittedBox(
                        child: Text(
                          '${totalWeight.toStringAsFixed(1)}',
                          // service.customer.palettes.fold(0,
                          //     (poids, palette) {
                          //   return poids += palette.poids;
                          // }).toString(),
                          style: TextStyle(
                              color: Color(0xff0f3443),
                              fontSize: 26,
                              fontFamily: 'Bree'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
