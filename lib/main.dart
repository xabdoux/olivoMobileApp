import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './providers/auth.dart';
import './screens/auth_screen.dart';
import './providers/blue_thermal_provider.dart';
import './providers/services.dart';
import './screens/add_customer_screen.dart';
import './screens/blue_thermal_screen.dart';
import './screens/customer_details_screen.dart';
import './screens/deleted_customer_details_screen.dart';
import './screens/deleted_entries_screen.dart';
import './screens/edit_customer_screen.dart';
import './screens/customers_list_screen.dart';

void main() => runApp(OlivoAlcazar());

class OlivoAlcazar extends StatelessWidget {
  const OlivoAlcazar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Services>(
            update: (context, auth, previousServices) => Services(
                auth.urlServer,
                auth.token,
                auth.userId,
                previousServices == null
                    ? []
                    : previousServices.principaleServices),
            create: (ctx) => Services('', '', '', []),
          ),
          ChangeNotifierProvider(
            create: (ctx) => BlueThermalProvider(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            theme: ThemeData(
                primaryColor: Color.fromRGBO(5, 21, 43, 1),
                accentColor: Colors.green[400],
                textTheme:
                    TextTheme(headline1: TextStyle(fontFamily: 'Monotom'))),
            title: 'Olivo Alcazar',
            home: AuthScreen(),
            routes: {
              CustomersListScreen.routeName: (ctx) => CustomersListScreen(),
              CustomerDetailsScreen.routeName: (ctx) => CustomerDetailsScreen(),
              DeletedEntriesScreen.routeName: (ctx) => DeletedEntriesScreen(),
              DeletedCustomerDetailsScreen.routeName: (ctx) =>
                  DeletedCustomerDetailsScreen(),
              AddCustomerScreen.routeName: (ctx) => AddCustomerScreen(),
              EditCustomerScreen.routeName: (ctx) => EditCustomerScreen(),
              BlueThermalScreen.routeName: (ctx) => BlueThermalScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          ),
        ));
  }
}
