import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../screens/awaiting_customer_detailsScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/services.dart';

class AwaitingListItem extends StatelessWidget {
  final String serviceId;
  final String fullName;
  final String phone;
  final int tour;
  final double poids;
  final int nombrePalettes;
  final int nombreSac;
  final DateTime createdAt;
  final DateTime deletedAt;
  final String type;
  final GlobalKey<ScaffoldState> scaffoldKey;

  AwaitingListItem({
    @required this.scaffoldKey,
    @required this.serviceId,
    @required this.fullName,
    @required this.phone,
    @required this.tour,
    @required this.poids,
    @required this.nombrePalettes,
    @required this.nombreSac,
    @required this.createdAt,
    @required this.deletedAt,
    @required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Dismissible(
      key: UniqueKey(),
      background: buildBackgroundDismissible(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {},
      confirmDismiss: (direction) async {
        final confirme = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (ctx) => Dialog(
            backgroundColor: Colors.red[300],
            child: Container(
              height: 200,
              width: deviceSize.width * 0.8,
              child: Column(
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: Container(
                      color: Colors.red[300],
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Confirmer',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                          )
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 4,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 10, right: 30),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.warning,
                                    color: Colors.red[300],
                                    size: 40,
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Text(
                                    'Voulez-vous vraiment supprimer ce client?',
                                    style: TextStyle(
                                        color: Colors.grey[700], fontSize: 20),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 80,
                                  height: 40,
                                  child: OutlineButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Non',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    textColor: Colors.grey,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 100,
                                  height: 40,
                                  child: FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      'Oui',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    color: Colors.red[300],
                                    textColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
        if (confirme) {
          try {
            await Provider.of<Services>(context, listen: false)
                .deleteCustomer(serviceId, isPrincipale: false);
            return true;
          } catch (error) {
            scaffoldKey.currentState.removeCurrentSnackBar();
            scaffoldKey.currentState.showSnackBar(
              SnackBar(
                  content: FittedBox(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.warning,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      error.toString(),
                      style: TextStyle(color: Colors.orange, fontSize: 16),
                    ),
                  ],
                ),
              )),
            );
            return false;
          }
        } else {
          return false;
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, bottom: 5),
        width: deviceSize.width,
        height: 150,
        child: Stack(
          alignment: Alignment.centerRight,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 20),
              width: deviceSize.width * 0.8,
              height: 150,
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FittedBox(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        AwaitingCustmerDetailsScreen.routeName,
                                        arguments: serviceId);
                                  },
                                  child: Text(
                                    '$fullName',
                                    style: TextStyle(
                                        color: Color(0xff0f3443),
                                        fontSize: 26,
                                        fontFamily: 'Bree'),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                DateFormat('dd / M, yyyy').format(createdAt),
                                style: TextStyle(
                                  color: Color(0xff0f3443),
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent[700],
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.yellowAccent.withOpacity(0.3),
                                      spreadRadius: 1,
                                      blurRadius: 3,
                                      offset: Offset(
                                          0, 0), // changes position of shadow
                                    )
                                  ],
                                ),
                                height: 2,
                                width: 50,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    poids.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontFamily: 'Bree',
                                      fontSize: 20,
                                      color: Color.fromRGBO(15, 52, 67, 0.8),
                                    ),
                                  ),
                                  Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/measure.png',
                                        height: 20,
                                      ),
                                      Text(
                                        'KG',
                                        style: TextStyle(
                                            fontFamily: 'Bree',
                                            fontSize: 10,
                                            color: Colors.grey[200]),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '$nombrePalettes',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Bree',
                                      color: Color.fromRGBO(15, 52, 67, 0.8),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/pallet.png',
                                    height: 25,
                                  )
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    '$nombreSac',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Bree',
                                      color: Color.fromRGBO(15, 52, 67, 0.8),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(
                                    'assets/images/sacks.png',
                                    height: 18,
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                            icon: Icon(
                              Icons.phone_forwarded,
                              color: Theme.of(context).accentColor,
                            ),
                            onPressed: () async {
                              await launch("tel:$phone");
                            },
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              right: deviceSize.width * 0.75,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                      AwaitingCustmerDetailsScreen.routeName,
                      arguments: serviceId);
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.yellow[600],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 4,
                        blurRadius: 10,
                        offset: Offset(0, 2), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        '$tour',
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildBackgroundDismissible() {
    return Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        padding: EdgeInsets.only(right: 20),
        alignment: Alignment.centerRight,
        color: Colors.red[200],
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ));
  }
}
