import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

import '../providers/search_delegate.dart';
import '../screens/add_customer_screen.dart';
import '../widgets/deleted_list_item.dart';
import '../widgets/main_drawer.dart';
import '../providers/services.dart';

class DeletedEntriesScreen extends StatefulWidget {
  static const routeName = '/deleted-list';

  @override
  _DeletedEntriesScreenState createState() => _DeletedEntriesScreenState();
}

class _DeletedEntriesScreenState extends State<DeletedEntriesScreen> {
  var _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      _isLoading = true;

      Provider.of<Services>(context, listen: false)
          .fetchAndSetService('deleted')
          .then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        showDialog<void>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Oops! il y a eu un problème'),
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
        setState(() {
          _isLoading = false;
        });
      });
    }

    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final services =
        Provider.of<Services>(context, listen: true).deletedServices;
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
                  delegate: CustomSearchDelegate(source: "deleted"),
                );
              }),
        ],
        gradient: LinearGradient(
          colors: [Colors.green[400], Color(0xff0f3443)],
          stops: [0, 0.8],
        ),
      ),
      body: RefreshIndicator(
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
                                      DeletedListItem(
                                        type: services[i].type,
                                        scaffoldKey: _scaffoldKey,
                                        serviceId: services[i].id,
                                        fullName: services[i].customer.fullName,
                                        phone: services[i].customer.phoneNumber,
                                        tour: services[i].tour,
                                        nombrePalettes: services[i]
                                            .customer
                                            .palettes
                                            .length,
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
          onRefresh: () async {
            try {
              await Provider.of<Services>(context, listen: false)
                  .fetchAndSetService('deleted');
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
          }),
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
