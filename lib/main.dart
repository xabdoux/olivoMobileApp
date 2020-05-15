import 'package:flutter/material.dart';
import './providers/blue_thermal_provider.dart';
import './providers/services.dart';
import './providers/textfield_provider.dart';
import './screens/add_customer_screen.dart';
import './screens/blue_thermal_screen.dart';
import './screens/customer_details_screen.dart';
import './screens/deleted_customer_details_screen.dart';
import './screens/deleted_entries_screen.dart';
import './screens/edit_customer_screen.dart';
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
          create: (ctx) => Services(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => TextfieldProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BlueThermalProvider(),
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
          DeletedCustomerDetailsScreen.routeName: (ctx) =>
              DeletedCustomerDetailsScreen(),
          AddCustomerScreen.routeName: (ctx) => AddCustomerScreen(),
          EditCustomerScreen.routeName: (ctx) => EditCustomerScreen(),
          BlueThermalScreen.routeName: (ctx) => BlueThermalScreen()
        },
      ),
    );
  }
}
