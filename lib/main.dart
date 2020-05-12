import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/services.dart';
import 'package:olivoalcazar/providers/textfield_provider.dart';
import 'package:olivoalcazar/screens/add_customer_screen.dart';
import 'package:olivoalcazar/screens/customer_details_screen.dart';
import 'package:olivoalcazar/screens/deleted_customer_details_screen.dart';
import 'package:olivoalcazar/screens/deleted_entries_screen.dart';
import 'package:olivoalcazar/screens/edit_customer_screen.dart';
import 'package:olivoalcazar/widgets/deleted_list_item.dart';
import 'package:provider/provider.dart';
import './screens/customers_list_screen.dart';

void main() => runApp(OlivoAlcazar());

class OlivoAlcazar extends StatelessWidget {
  const OlivoAlcazar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx)=>Services(),
          ),
        ChangeNotifierProvider(
          create: (ctx)=>TextfieldProvider(),
          ),
      ],
          child: MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromRGBO(122, 133, 20, 1),
          accentColor: Color.fromRGBO(76, 85, 95, 1),
        ),
        title: 'Olivo Alcazar',
        home: CustomersListScreen(),
        routes: {
          CustomersListScreen.routeName: (ctx) => CustomersListScreen(),
          CustomerDetailsScreen.routeName: (ctx) => CustomerDetailsScreen(),
          DeletedEntriesScreen.routeName: (ctx) => DeletedEntriesScreen(),
          DeletedCustomerDetailsScreen.routeName: (ctx) => DeletedCustomerDetailsScreen(),
          AddCustomerScreen.routeName: (ctx) => AddCustomerScreen(),
          EditCustomerScreen.routeName: (ctx) => EditCustomerScreen(),
        },
      ),
    );
  }
}
