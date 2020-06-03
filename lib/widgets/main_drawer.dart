import 'package:flutter/material.dart';
import 'package:olivoalcazar/providers/auth.dart';
import 'package:olivoalcazar/screens/blue_thermal_screen.dart';
import 'package:olivoalcazar/screens/customers_list_screen.dart';
import 'package:olivoalcazar/screens/deleted_entries_screen.dart';
import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black87,
              gradient: LinearGradient(
                colors: [
                  Colors.black87,
                  Color.fromRGBO(122, 133, 20, 1),
                  //Colors.yellow
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 25),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: AssetImage('assets/images/user.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
                Text(
                  'JAADI ABDELLAH',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            CustomersListScreen.routeName);
                      },
                      leading: Icon(
                        Icons.supervised_user_circle,
                        size: 40,
                        color: Color.fromRGBO(76, 85, 95, 1),
                      ),
                      title: Text(
                        'All Customers',
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            DeletedEntriesScreen.routeName);
                      },
                      leading: Icon(
                        Icons.restore_from_trash,
                        size: 40,
                        color: Color.fromRGBO(255, 148, 148, 1),
                      ),
                      title: Text(
                        'Deleted Entries',
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(BlueThermalScreen.routeName);
                      },
                      title: Text('Printer Setting'),
                      leading: Icon(
                        Icons.settings,
                        size: 30,
                      ),
                      subtitle: Text('Click here to configure printer'),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.of(context).pop();
                        Provider.of<Auth>(context, listen: false).logout();
                      },
                      title: Text('Logout'),
                      leading: Icon(
                        Icons.exit_to_app,
                        size: 30,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
