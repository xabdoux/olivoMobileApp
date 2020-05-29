import 'package:flutter/material.dart';
import '../providers/services.dart';
import '../screens/deleted_customer_details_screen.dart';
import 'package:provider/provider.dart';

class DeletedListItem extends StatelessWidget {
  final String serviceId;
  final String fullName;
  final int tour;
  final int poids;
  final int nombrePalettes;
  final int nombreSac;
  final DateTime createdAt;
  final DateTime deletedAt;

  DeletedListItem({
    @required this.serviceId,
    @required this.fullName,
    @required this.tour,
    @required this.poids,
    @required this.nombrePalettes,
    @required this.nombreSac,
    @required this.createdAt,
    @required this.deletedAt,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(serviceId),
      background: Container(
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          padding: EdgeInsets.only(right: 20),
          alignment: Alignment.centerRight,
          color: Colors.blue[200],
          child: Icon(
            Icons.restore,
            color: Colors.white,
            size: 40,
          )),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {},
      confirmDismiss: (direction) async {
        final confirme = await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure!'),
            content: Text('Do you want to restore the Customer?'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text('No')),
              RaisedButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('Yes'),
                color: Colors.red,
              ),
            ],
          ),
        );
        if (confirme) {
          try {
            await Provider.of<Services>(context, listen: false)
                .restorService(serviceId);
            //TODO: Optimization, use widget builder to create snackbar
            Scaffold.of(context).showSnackBar(
              SnackBar(
                duration: Duration(seconds: 2),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check_circle),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Successfuly restored'),
                  ],
                ),
                backgroundColor: Colors.green[200],
              ),
            );

            return true;
          } catch (error) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                  content: FittedBox(
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.warning,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.orange, fontSize: 12),
                    ),
                  ],
                ),
              )),
            );
            return false;
          }
        } else {
          return false;
        }
      },
      child: Container(
        color: Colors.red[100],
        child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(
                DeletedCustomerDetailsScreen.routeName,
                arguments: serviceId);
          },
          title: Text(fullName),
          subtitle: Text(createdAt.toString()),
          leading: Text(tour.toString()),
          trailing: Text('$poids KG'),
        ),
      ),
    );
  }
}
