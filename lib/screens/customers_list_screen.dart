import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/textfield_provider.dart';
import 'package:olivoalcazar/screens/add_customer_screen.dart';
import 'package:olivoalcazar/widgets/main_drawer.dart';
import '../widgets/customer_list_item.dart';
import '../widgets/search_customer_list.dart';
import 'package:provider/provider.dart';
import '../providers/services.dart';

class CustomersListScreen extends StatefulWidget {
  static const routeName = '/customers-list';

  @override
  _CustomersListScreenState createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  var _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _isLoading = true;
    Future.delayed(Duration.zero).then((_) async {
      try {
        await Provider.of<Services>(context, listen: false)
            .fetchAndSetService('principale');

        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        showDialog<void>(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Somthing went wrong'),
                content: Text(error),
                actions: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Okey'))
                ],
              );
            });
        setState(() {
          _isLoading = false;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final services =
        Provider.of<Services>(context, listen: false).principaleServices;
    Provider.of<TextfieldProvider>(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: MainDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Olivo',
          style: TextStyle(fontSize: 30, shadows: [
            Shadow(blurRadius: 40, color: Colors.yellow, offset: Offset.zero)
          ]),
        ),
      ),
      body: RefreshIndicator(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    SearchCustomerList(),
                    Flexible(
                      flex: 10,
                      fit: FlexFit.tight,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: services.length,
                          itemBuilder: (ctx, i) => Column(
                                children: <Widget>[
                                  CustomerListItem(
                                    scaffoldKey: _scaffoldKey,
                                    serviceId: services[i].id,
                                    fullName: services[i].customer.fullName,
                                    tour: services[i].tour,
                                    nombrePalettes:
                                        services[i].customer.palettes.length,
                                    nombreSac: services[i]
                                        .customer
                                        .palettes
                                        .fold(0, (totalSac, palette) {
                                      return totalSac += palette.nombreSac;
                                    }),
                                    poids: services[i].customer.palettes.fold(0,
                                        (poids, palette) {
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
                  .fetchAndSetService('principale');
            } catch (error) {
              showDialog<void>(
                  context: context,
                  builder: (ctx) {
                    return AlertDialog(
                      title: Text('Somthing went wrong'),
                      content: Text(error),
                      actions: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Okey'))
                      ],
                    );
                  });
            }
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AddCustomerScreen.routeName);
          },
          child: Icon(Icons.add)),
    );
  }
}
