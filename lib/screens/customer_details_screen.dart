import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/blue_thermal_provider.dart';
import '../providers/service.dart';
import '../providers/services.dart';
import '../screens/blue_thermal_screen.dart';
import '../screens/edit_customer_screen.dart';

class CustomerDetailsScreen extends StatefulWidget {
  static const routeName = '/customer-details';

  @override
  _CustomerDetailsScreenState createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var _isLoading = false;

  int totalSac(Service service) {
    return service.customer.palettes
        .fold(0, (sum, palette) => sum += palette.nombreSac);
  }

  String totalPrice(Service service) {
    final poids = service.customer.palettes
        .fold(0, (poid, palette) => poid += palette.poids);
    if (poids <= 400) {
      return "200.0";
    }
    return (poids / 2).toStringAsFixed(1);
  }

  Future<void> confirmDelete(Size deviceSize, String serviceId,
      GlobalKey<ScaffoldState> scaffoldKey) async {
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
        setState(() {
          _isLoading = true;
        });
        await Provider.of<Services>(context, listen: false)
            .deleteCustomer(serviceId);
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
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
      }
    }
  }

  double totalPoids(Service service) {
    return service.customer.palettes
        .fold(0, (sum, palette) => sum += palette.poids);
  }

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
    final BlueThermalProvider blueThermal =
        Provider.of<BlueThermalProvider>(context);
    final String serviceId = ModalRoute.of(context).settings.arguments;
    Service service = Provider.of<Services>(context)
        .principaleServices
        .firstWhere((s) => s.id == serviceId, orElse: () => null);

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: GradientAppBar(
        title: Text('Détails du client'),
        gradient: LinearGradient(
          colors: [Colors.green[400], Color(0xff0f3443)],
          stops: [0, 0.8],
        ),
        actions: <Widget>[
          Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.print),
                tooltip: 'Réglage',
                onPressed: () {
                  Navigator.of(context).pushNamed(BlueThermalScreen.routeName);
                },
              ),
              Positioned(
                top: 9,
                left: 8,
                child: Icon(
                  Icons.settings,
                  color: Colors.grey,
                  size: 12,
                ),
              ),
            ],
          )
        ],
      ),
      body: service == null
          ? Center(child: Text('Pas de données'))
          : SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        height: 420,
                        child: Stack(
                          children: <Widget>[
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/backgroundOlive.jpg'),
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
                                ),
                              ),
                            ),
                            Positioned(
                              top: 100,
                              left: deviceSize.width * 0.1 / 2,
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 50, left: 20, right: 20),
                                height: 280,
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
                                    FittedBox(
                                      child: Text(
                                        '${service.customer.fullName}',
                                        style: TextStyle(
                                            color: Color(0xff0f3443),
                                            fontSize: 26,
                                            fontFamily: 'Bree'),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                                    color: Colors.green[400],
                                                    fontSize: 22,
                                                    fontFamily: 'Bree'),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Icon(
                                                Icons.phone_forwarded,
                                                size: 20,
                                                color: Colors.green,
                                              )
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
                                      color: Colors.green[300],
                                      width: 40,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  fontSize: 20,
                                                  fontFamily: 'Bree'),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(Icons.access_time),
                                            Text(
                                              DateFormat('HH:mm').format(service
                                                  .createdAt
                                                  .add(Duration(hours: 1))),
                                              style: TextStyle(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
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
                                    FittedBox(
                                      child: Text(
                                        "${totalPrice(service)} Dh",
                                        style: TextStyle(
                                            color: Colors.green[800],
                                            fontSize: 25,
                                            fontFamily: 'Bree'),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 70,
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Image.asset(
                                                  'assets/images/sacks.png',
                                                  height: 28,
                                                ),
                                                Text(
                                                  service.customer.palettes
                                                      .fold(0,
                                                          (totalSac, palette) {
                                                    return totalSac +=
                                                        palette.nombreSac;
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
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Image.asset(
                                                  'assets/images/measure.png',
                                                  height: 30,
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    service.customer.palettes
                                                        .fold(0,
                                                            (poids, palette) {
                                                      return poids +=
                                                          palette.poids;
                                                    }).toStringAsFixed(1),
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff0f3443),
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
                              top: 60,
                              left: (deviceSize.width - 80) / 2,
                              child: Container(
                                padding: EdgeInsets.all(10),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Color(0xff0f3443),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xff0f3443).withOpacity(0.5),
                                      spreadRadius: 4,
                                      blurRadius: 10,
                                      offset: Offset(
                                          0, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: FittedBox(
                                    child: Text(
                                      '${service.tour}',
                                      style: TextStyle(
                                          fontSize: 30, color: Colors.white),
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
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.green[300],
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(
                                        "${service.customer.palettes[index].nombreSac}",
                                        style: TextStyle(
                                            color: Color(0xff0f3443),
                                            fontSize: 26,
                                            fontFamily: 'Bree'),
                                      ),
                                      Text(
                                        "${service.customer.palettes[index].poids.toStringAsFixed(1)} Kg",
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.red[300],
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  confirmDelete(
                                      deviceSize, serviceId, _scaffoldKey);
                                }),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Color(0xff53e69d),
                                shape: BoxShape.circle),
                            child: IconButton(
                                icon: Icon(
                                  Icons.print,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  if (blueThermal.selectedDevice == null) {
                                    _scaffoldKey.currentState
                                        .removeCurrentSnackBar();
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.warning,
                                              color: Colors.yellow,
                                            ),
                                            Text(
                                              ' Aucune imprimante sélectionnée',
                                              style: TextStyle(
                                                color: Colors.yellow,
                                              ),
                                            )
                                          ],
                                        ),
                                        action: SnackBarAction(
                                          label: 'Réglage',
                                          textColor: Colors.white,
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                BlueThermalScreen.routeName);
                                          },
                                        ),
                                      ),
                                    );
                                  } else if (!blueThermal.isConnected) {
                                    _scaffoldKey.currentState
                                        .removeCurrentSnackBar();
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        content: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.warning,
                                              color: Colors.yellow,
                                            ),
                                            Text(
                                              " Non connecté à l'imprimante",
                                              style: TextStyle(
                                                color: Colors.yellow,
                                              ),
                                            )
                                          ],
                                        ),
                                        action: SnackBarAction(
                                          label: 'Réglage',
                                          textColor: Colors.white,
                                          onPressed: () {
                                            Navigator.of(context).pushNamed(
                                                BlueThermalScreen.routeName);
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    blueThermal.printTicket(
                                        service,
                                        totalSac(service),
                                        totalPoids(service),
                                        context);
                                  }
                                }),
                          ),
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Color(0xff707cd2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      EditCustomerScreen.routeName,
                                      arguments: serviceId);
                                }),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 60,
                      )
                    ],
                  ),
                  _isLoading
                      ? Center(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.black45,
                            ),
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Center()
                ],
              ),
            ),
    );
  }
}
