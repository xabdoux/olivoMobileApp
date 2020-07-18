import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/blue_thermal_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/service.dart';
import '../providers/services.dart';
import 'deleted_entries_screen.dart';

class DeletedCustomerDetailsScreen extends StatefulWidget {
  static const routeName = '/deleted-customer-details';

  @override
  _DeletedCustomerDetailsScreenState createState() =>
      _DeletedCustomerDetailsScreenState();
}

class _DeletedCustomerDetailsScreenState
    extends State<DeletedCustomerDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  double totalSac(Service service) {
    return service.customer.palettes
        .fold(0, (sum, palette) => sum += palette.nombreSac);
  }

  double totalPoids(Service service) {
    return service.customer.palettes
        .fold(0, (sum, palette) => sum += palette.poids);
  }

  var _isLoading = false;

  bool init = true;
  @override
  void didChangeDependencies() {
    if (init) {
      final blueThermal = Provider.of<BlueThermalProvider>(context);
      if (blueThermal.isPathImageEmpty) {
        blueThermal.initSavetoPath();
      }
      init = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final String serviceId = ModalRoute.of(context).settings.arguments;
    final Service service = Provider.of<Services>(context, listen: false)
        .deletedServices
        .firstWhere((s) => s.id == serviceId);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: GradientAppBar(
        title: Text('Détails du client'),
        gradient: LinearGradient(
          colors: [Colors.green[400], Color(0xff0f3443)],
          stops: [0, 0.8],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 20),
              height: 500,
              //color: Colors.red[300],
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/backgroundOlive.jpg'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        //stops: [0.0, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: deviceSize.width * 0.1 / 2,
                    child: Container(
                      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                      height: 350,
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
                          Text(
                            '${service.customer.fullName}',
                            style: TextStyle(
                                color: Color(0xff0f3443),
                                fontSize: 26,
                                fontFamily: 'Bree'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () async {
                                  await launch(
                                      "tel:${service.customer.phoneNumber}");
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      '${service.customer.phoneNumber}',
                                      style: TextStyle(
                                          color: Colors.red[300],
                                          fontSize: 22,
                                          fontFamily: 'Bree'),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.phone_forwarded,
                                      size: 20,
                                      color: Colors.red[300],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 2,
                            color: Colors.red[300],
                            width: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.calendar_today,
                                  ),
                                  Text(
                                    DateFormat('dd / M, yyyy')
                                        .format(service.createdAt),
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 20,
                                        fontFamily: 'Bree'),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(Icons.access_time),
                                  Text(
                                    DateFormat('HH:mm').format(service.createdAt
                                        .add(Duration(hours: 1))),
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.5),
                                        fontSize: 20,
                                        fontFamily: 'Bree'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.delete_sweep,
                                    color: Colors.red[300],
                                  ),
                                  Text(
                                    DateFormat('dd / M, yyyy')
                                        .format(service.deletedAt),
                                    style: TextStyle(
                                        color: Colors.red[300],
                                        fontSize: 20,
                                        fontFamily: 'Bree'),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.red[300],
                                  ),
                                  Text(
                                    DateFormat('HH:mm').format(service.deletedAt
                                        .add(Duration(hours: 1))),
                                    style: TextStyle(
                                        color: Colors.red[300],
                                        fontSize: 20,
                                        fontFamily: 'Bree'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                service.type == "principale"
                                    ? "Principale"
                                    : "Attente",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Color(0xff0f3443),
                                    fontFamily: 'Bree'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            height: 70,
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/pallet.png',
                                        height: 40,
                                      ),
                                      Text(
                                        '${service.customer.palettes.length}',
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/sacks.png',
                                        height: 28,
                                      ),
                                      Text(
                                        service.customer.palettes.fold(0,
                                            (totalSac, palette) {
                                          return totalSac += palette.nombreSac;
                                        }).toString(),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Image.asset(
                                        'assets/images/measure.png',
                                        height: 30,
                                      ),
                                      FittedBox(
                                        child: Text(
                                          service.customer.palettes.fold(0,
                                              (poids, palette) {
                                            return poids += palette.poids;
                                          }).toString(),
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
                    ),
                  ),
                  Positioned(
                    top: 110,
                    left: (deviceSize.width - 80) / 2,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.red[300],
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff0f3443).withOpacity(0.5),
                            spreadRadius: 4,
                            blurRadius: 10,
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                        child: FittedBox(
                          child: Text(
                            '${service.tour}',
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20),
              width: deviceSize.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: service.customer.palettes.length,
                itemBuilder: (ctx, index) => Container(
                  margin: EdgeInsets.only(bottom: 20),
                  height: 60,
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
                    children: <Widget>[
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.red[300],
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            bottomLeft: const Radius.circular(10.0),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                                color: Colors.white,
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
                              "${service.customer.palettes[index].nombreSac}",
                              style: TextStyle(
                                  color: Color(0xff0f3443),
                                  fontSize: 26,
                                  fontFamily: 'Bree'),
                            ),
                            Text(
                              "${service.customer.palettes[index].poids} Kg",
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
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Color(0xff2cabe3), shape: BoxShape.circle),
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : IconButton(
                          icon: Icon(Icons.restore, color: Colors.white),
                          onPressed: () async {
                            final confirme = await showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (ctx) => Dialog(
                                child: Container(
                                  height: 200,
                                  width: deviceSize.width * 0.8,
                                  child: Column(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          color: Colors.grey[200],
                                          width: double.infinity,
                                          padding: EdgeInsets.only(left: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'Confirmer',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 20),
                                                textAlign: TextAlign.center,
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
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
                                          padding: EdgeInsets.only(
                                              left: 10, right: 30),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      flex: 1,
                                                      child: Icon(
                                                        Icons.warning,
                                                        color: Colors.blue[300],
                                                        size: 40,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 4,
                                                      child: Text(
                                                        'Voulez-vous vraiment restaurer ce client?',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey[700],
                                                            fontSize: 20),
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: <Widget>[
                                                    Container(
                                                      width: 80,
                                                      height: 40,
                                                      child: OutlineButton(
                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          'Non',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        textColor: Colors.grey,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
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
                                                            Navigator.of(
                                                                    context)
                                                                .pop(true),
                                                        padding:
                                                            EdgeInsets.all(10),
                                                        child: Text(
                                                          'Oui',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        color: Colors.blue[300],
                                                        textColor: Colors.white,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5)),
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
                                setState(() {
                                  _isLoading = true;
                                });
                                await Provider.of<Services>(context,
                                        listen: false)
                                    .restorService(serviceId);
                                Navigator.of(context).pushReplacementNamed(
                                    DeletedEntriesScreen.routeName);
                              } catch (error) {
                                _scaffoldKey.currentState
                                    .removeCurrentSnackBar();
                                _scaffoldKey.currentState.showSnackBar(
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
                                          error,
                                          style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  )),
                                );
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          }),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}
