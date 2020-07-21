import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import '../providers/search_delegate.dart';
import '../providers/service.dart';
import '../screens/add_customer_screen.dart';
import '../widgets/main_drawer.dart';
import '../widgets/customer_list_item.dart';
import '../providers/services.dart';

class CustomersListScreen extends StatefulWidget {
  static const routeName = '/customers-list';

  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  var _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      _isLoading = true;

      Provider.of<Services>(context, listen: false)
          .fetchAndSetService('principale')
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    isInit = false;
    super.didChangeDependencies();
  }

  List<int> getDuplicatedNumbers(List<Service> services) {
    List<int> checkedNumbers = [];
    List<int> duplicatedNumbers = [];
    services.forEach((service) {
      if (checkedNumbers.contains(service.tour)) {
        if (!(duplicatedNumbers.contains(service.tour))) {
          duplicatedNumbers.add(service.tour);
        }
      } else {
        checkedNumbers.add(service.tour);
      }
    });

    return duplicatedNumbers;
  }

  @override
  Widget build(BuildContext context) {
    final services =
        Provider.of<Services>(context, listen: true).principaleServices;
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      key: _scaffoldKey,
      drawer: MainDrawer(),
      appBar: GradientAppBar(
        centerTitle: true,
        title: Image.asset(
          'assets/images/olivo_white.png',
          height: 35,
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(source: "principale"),
                );
              }),
        ],
        gradient: LinearGradient(
          colors: [Colors.green[400], Color(0xff0f3443)],
          stops: [0, 0.8],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          try {
            await Provider.of<Services>(context, listen: false)
                .fetchAndSetService('principale');
          } on SocketException {
            showDialog<void>(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('oups! il y a eu un problème'),
                    content: Text("Le réseau est inaccessible"),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Ok'))
                    ],
                  );
                });
          } catch (error) {
            showDialog<void>(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    title: Text('oups! il y a eu un problème'),
                    content: Text(error.toString()),
                    actions: <Widget>[
                      FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Ok'))
                    ],
                  );
                });
          }
        },
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : services.length == 0
                ? Center(
                    child: Text(
                      'Pas de données',
                      style: TextStyle(fontSize: 25),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: ListView.builder(
                            //shrinkWrap: true,
                            itemCount: services.length,
                            itemBuilder: (ctx, i) => Column(
                                  children: <Widget>[
                                    i != 0
                                        ? Text('')
                                        : getDuplicatedNumbers(services)
                                                    .length >
                                                0
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                      right: 10,
                                                      left: 10,
                                                    ),
                                                    margin: EdgeInsets.only(
                                                      right: 20,
                                                      top: 10,
                                                      bottom: 10,
                                                    ),
                                                    width:
                                                        deviceSize.width * 0.8,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.red[300],
                                                    ),
                                                    child: FittedBox(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.warning,
                                                            color: Colors
                                                                .yellow[300],
                                                            size: 50,
                                                          ),
                                                          Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                ' Attention! il y a des numéros de tour en double',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        30),
                                                              ),
                                                              Text(
                                                                '${getDuplicatedNumbers(services)}',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 30,
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )
                                            : Text(''),
                                    CustomerListItem(
                                      scaffoldKey: _scaffoldKey,
                                      serviceId: services[i].id,
                                      fullName: services[i].customer.fullName,
                                      phone: services[i].customer.phoneNumber,
                                      tour: services[i].tour,
                                      type: services[i].type,
                                      nombrePalettes:
                                          services[i].customer.palettes.length,
                                      nombreSac: services[i]
                                          .customer
                                          .palettes
                                          .fold(0, (totalSac, palette) {
                                        return totalSac += palette.nombreSac;
                                      }),
                                      poids: services[i]
                                          .customer
                                          .palettes
                                          .fold(0, (poids, palette) {
                                        return poids += palette.poids;
                                      }),
                                      createdAt: services[i].createdAt,
                                      deletedAt: services[i].deletedAt,
                                    )
                                  ],
                                )),
                      )
                    ],
                  ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddCustomerScreen.routeName);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
    );
  }
}
