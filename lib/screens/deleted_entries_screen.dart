import 'package:flutter/material.dart';
import 'package:olivoalcazar/widgets/deleted_list_item.dart';
import 'package:olivoalcazar/widgets/main_drawer.dart';
import '../widgets/search_customer_list.dart';
import 'package:provider/provider.dart';
import '../providers/services.dart';

class DeletedEntriesScreen extends StatefulWidget {
  static const routeName = '/deleted-list';

  @override
  _DeletedEntriesScreenState createState() => _DeletedEntriesScreenState();
}

class _DeletedEntriesScreenState extends State<DeletedEntriesScreen> {
  Future<void> fetchAndSetData() async {
    try {
      await Provider.of<Services>(context, listen: false)
          .fetchAndSetService('deleted');
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
  }
  // @override
  // void initState() {
  //   _isLoading = true;
  //   Future.delayed(Duration.zero).then((_) async {
  //     try {
  //       await Provider.of<Services>(context, listen: false)
  //           .fetchAndSetService('deleted');

  //       setState(() {
  //         _isLoading = false;
  //       });
  //     } catch (error) {
  //       showDialog<void>(
  //           context: context,
  //           builder: (ctx) {
  //             return AlertDialog(
  //               title: Text('Somthing went wrong'),
  //               content: Text(error),
  //               actions: <Widget>[
  //                 FlatButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop();
  //                     },
  //                     child: Text('Okey'))
  //               ],
  //             );
  //           });
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final services = Provider.of<Services>(context).deletedServices;
    return Scaffold(
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
        onRefresh: fetchAndSetData,
        child: Column(
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
                          DeletedListItem(
                            serviceId: services[i].id,
                            fullName: services[i].customer.fullName,
                            tour: services[i].tour,
                            nombrePalettes:
                                services[i].customer.palettes.length,
                            nombreSac: services[i].customer.palettes.fold(0,
                                (totalSac, palette) {
                              return totalSac += palette.nombreSac;
                            }),
                            poids: services[i].customer.palettes.fold(0,
                                (poids, palette) {
                              return poids += palette.poids;
                            }),
                            createdAt: services[i].createdAt,
                            deletedAt: services[i].deletedAt,
                          ),
                          Divider()
                        ],
                      )),
            )
          ],
        ),
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {}, child: Icon(Icons.add)),
    );
  }
}
