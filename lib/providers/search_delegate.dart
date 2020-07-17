import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/service.dart';
import '../providers/services.dart';
import '../screens/customer_details_screen.dart';
import '../screens/deleted_customer_details_screen.dart';

class CustomSearchDelegate extends SearchDelegate {
  String source;
  CustomSearchDelegate({@required this.source});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Service> services = [];
    if (source == "principale") {
      services = Provider.of<Services>(context, listen: false)
          .principaleServices
          .where((service) {
        if (service.customer.fullName.contains(query) ||
            service.tour.toString() == query) {
          return true;
        }
        return false;
      }).toList();
    } else if (source == "deleted") {
      services = Provider.of<Services>(context, listen: false)
          .deletedServices
          .where((service) {
        if (service.customer.fullName.contains(query) ||
            service.tour.toString() == query) {
          return true;
        }
        return false;
      }).toList();
    } else {
      services = Provider.of<Services>(context, listen: false)
          .awaitingServices
          .where((service) {
        if (service.customer.fullName.contains(query) ||
            service.tour.toString() == query) {
          return true;
        }
        return false;
      }).toList();
    }
    final deviceSize = MediaQuery.of(context).size;
    if (services.length == 0) {
      return Center(
        child: Text(
          "No Data",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      );
    }
    return ListView.builder(
      itemBuilder: (ctx, index) {
        return Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          width: deviceSize.width,
          height: 150,
          child: Stack(
            alignment: Alignment.centerRight,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(right: 20),
                width: deviceSize.width * 0.8,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        width: 50,
                        height: 50,
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FittedBox(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                          source == "principale"
                                              ? CustomerDetailsScreen.routeName
                                              : DeletedCustomerDetailsScreen
                                                  .routeName,
                                          arguments: services[index].id);
                                    },
                                    child: Text(
                                      '${services[index].customer.fullName}',
                                      style: TextStyle(
                                          color: Color(0xff0f3443),
                                          fontSize: 26,
                                          fontFamily: 'Bree'),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: <Widget>[
                                    source == "principale"
                                        ? Text("")
                                        : Icon(
                                            Icons.delete_sweep,
                                            color: Color(0xff0f3443),
                                          ),
                                    Text(
                                      source == "principale"
                                          ? DateFormat('dd MMM, yyyy')
                                              .format(services[index].createdAt)
                                          : DateFormat('dd MMM, yyyy').format(
                                              services[index].deletedAt),
                                      style: TextStyle(
                                        color: Color(0xff0f3443),
                                        fontSize: 16,
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: services[index].type == "principale"
                                        ? Colors.green
                                        : Colors.yellowAccent[700],
                                    boxShadow: [
                                      BoxShadow(
                                        color: services[index].type ==
                                                "principale"
                                            ? Colors.lightGreen.withOpacity(0.3)
                                            : Colors.yellowAccent
                                                .withOpacity(0.3),
                                        spreadRadius: 1,
                                        blurRadius: 3,
                                        offset: Offset(
                                            0, 0), // changes position of shadow
                                      )
                                    ],
                                  ),
                                  height: 2,
                                  width: 50,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      services[index].customer.palettes.fold(0,
                                          (poids, palette) {
                                        return poids += palette.poids;
                                      }).toStringAsFixed(1),
                                      style: TextStyle(
                                        fontFamily: 'Bree',
                                        fontSize: 20,
                                        color: Color.fromRGBO(15, 52, 67, 0.8),
                                      ),
                                    ),
                                    Stack(
                                      alignment: Alignment.bottomCenter,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/images/measure.png',
                                          height: 20,
                                        ),
                                        Text(
                                          'KG',
                                          style: TextStyle(
                                              fontFamily: 'Bree',
                                              fontSize: 10,
                                              color: Colors.grey[200]),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      '${services[index].customer.palettes.length}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Bree',
                                        color: Color.fromRGBO(15, 52, 67, 0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(
                                      'assets/images/pallet.png',
                                      height: 25,
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      services[index].customer.palettes.fold(0,
                                          (totalSac, palette) {
                                        return totalSac += palette.nombreSac;
                                      }).toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Bree',
                                        color: Color.fromRGBO(15, 52, 67, 0.8),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(
                                      'assets/images/sacks.png',
                                      height: 18,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.topCenter,
                            child: IconButton(
                              icon: Icon(
                                Icons.phone_forwarded,
                                color: Theme.of(context).accentColor,
                              ),
                              onPressed: () async {
                                await launch(
                                    "tel:${services[index].customer.phoneNumber}");
                              },
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: deviceSize.width * 0.75,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(
                        source == "principale"
                            ? CustomerDetailsScreen.routeName
                            : DeletedCustomerDetailsScreen.routeName,
                        arguments: services[index].id);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: source == "principale"
                          ? Color(0xff0f3443)
                          : Colors.red[300],
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: Offset(0, 2), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: FittedBox(
                        child: Text(
                          '${services[index].tour}',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: services.length,
    );
  }
}
