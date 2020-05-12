import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/textfield_provider.dart';
import 'package:olivoalcazar/screens/add_customer_screen.dart';
import 'package:olivoalcazar/widgets/main_drawer.dart';
import '../widgets/customer_list_item.dart';
import '../widgets/search_customer_list.dart';
import 'package:provider/provider.dart';
import '../providers/services.dart';

class CustomersListScreen extends StatelessWidget {
  static const routeName = '/customers-list';


  @override
  Widget build(BuildContext context) {
    final services = Provider.of<Services>(context).principaleServices.reversed.toList();
    Provider.of<TextfieldProvider>(context);
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
      body: Column(
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
                          serviceId: services[i].id,
                          fullName: services[i].customer.fullName,
                          tour: services[i].tour,
                          nombrePalettes: services[i].customer.palettes.length,
                          nombreSac: services[i].customer.palettes.fold(0,
                              (totalSac, palette) {
                            return totalSac += palette.nombreSac;
                          }),
                          poids: services[i].customer.palettes.fold(0,
                              (poids, palette) {
                            return poids += palette.poids;
                          }),
                          createdAt: services[i].createdAt,
                          deletedAt:services[i].deletedAt,
                        )
                      ],
                    )),
          )
        ],
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: () {
            Navigator.of(context).pushNamed(AddCustomerScreen.routeName);
          }, child: Icon(Icons.add)),
    );
  }
}


