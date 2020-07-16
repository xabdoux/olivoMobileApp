import 'package:flutter/material.dart';
import 'package:olivoalcazar/screens/awaiting_customers_list_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/blue_thermal_screen.dart';
import '../screens/customers_list_screen.dart';
import '../screens/deleted_entries_screen.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String screenRoute = ModalRoute.of(context).settings.name;
    final String fullName = Provider.of<Auth>(context, listen: false).fullName;
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 180,
            child: Stack(
              children: <Widget>[
                Container(
                  alignment: Alignment.bottomRight,
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    gradient: LinearGradient(
                      colors: [
                        Colors.green[400], Color(0xff0f3443)
                        //Colors.yellow
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    padding: EdgeInsets.only(left: 5, right: 5),
                    width: 170,
                    child: FittedBox(
                      child: Text(
                        "$fullName",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontFamily: 'bree'),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 60,
                  child: Container(
                    height: 110,
                    width: 110,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(
                        style: BorderStyle.solid,
                        color: Colors.grey[300],
                      ),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      //margin: EdgeInsets.only(top: 25),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage('assets/images/user.png'),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 35,
                  child: Container(
                    width: 150,
                    child: FittedBox(
                      child: Text(
                        'Responsable clientele',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black87,
                            fontFamily: 'bree'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            CustomersListScreen.routeName);
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.supervised_user_circle,
                                  size: 35,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Clients principaux',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          screenRoute == CustomersListScreen.routeName
                              ? Container(
                                  width: 6,
                                  height: 60,
                                  color: Colors.green[400],
                                )
                              : Container(
                                  width: 6,
                                  height: 60,
                                ),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            AwaitingCustomerListScreen.routeName);
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.access_time,
                                  size: 35,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Clients en attente',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          screenRoute == AwaitingCustomerListScreen.routeName
                              ? Container(
                                  width: 6,
                                  height: 60,
                                  color: Colors.green[400],
                                )
                              : Container(
                                  width: 6,
                                  height: 60,
                                ),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed(
                            DeletedEntriesScreen.routeName);
                      },
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  width: 20,
                                ),
                                Icon(
                                  Icons.delete,
                                  size: 35,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Clients supprimés',
                                  style: TextStyle(
                                    color: Colors.black.withOpacity(0.7),
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          screenRoute == DeletedEntriesScreen.routeName
                              ? Container(
                                  width: 6,
                                  height: 60,
                                  color: Colors.green[400],
                                )
                              : Container(
                                  width: 6,
                                  height: 60,
                                ),
                        ],
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
                        Provider.of<Auth>(context, listen: false)
                            .logout(context);
                        //Navigator.of(context).pop();
                        Navigator.of(context)
                            .pushReplacementNamed(AuthScreen.routeName);
                      },
                      title: Text('Logout'),
                      leading: Icon(
                        Icons.exit_to_app,
                        size: 30,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Developed & designed by JAADI Abdellah',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    )
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
