import 'dart:convert';
import 'package:flutter/Material.dart';

import 'package:http/http.dart' as http;

import '../providers/customer.dart';
import '../providers/palette.dart';
import '../providers/service.dart';

class Services with ChangeNotifier {
  List<Service> _services = [];
  List<Service> _deletedServices = [];
  List<Service> _awaitingServices = [];
  final String urlServer;
  final String token;
  final String userId;
  Services(this.urlServer, this.token, this.userId, this._services,
      this._awaitingServices, this._deletedServices);

  List<Service> get principaleServices {
    return _services;
  }

  List<Service> get deletedServices {
    return _deletedServices;
  }

  List<Service> get awaitingServices {
    return _awaitingServices;
  }

  Future<void> restorService(serviceId) async {
    final url = "$urlServer/api/clients-restore/$serviceId";

    final response = await http.patch(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw 'Request Timeout, please try again';
      },
    );
    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw 'Request Failed, please try again (client error ${response.statusCode})';
    } else if (response.statusCode >= 500) {
      throw 'Request Failed, please try again (server error ${response.statusCode})';
    }
    if (response.body == "\"success\"") {
      Service current = _deletedServices
          .firstWhere((service) => service.id == serviceId.toString());
      current.deletedAt = null;
      print(_deletedServices);
      _services.insert(0, current);
      _deletedServices
          .removeWhere((element) => element.id == serviceId.toString());
      notifyListeners();
    }
  }

  Future<void> fetchAndSetService(String serviceType) async {
    String url = '$urlServer/api/clients';
    if (serviceType == 'deleted') {
      url = "$url-deleted";
    }

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(
      Duration(seconds: 8),
      onTimeout: () {
        throw 'Request Timeout';
      },
    );
    print(response.statusCode);
    if (response.statusCode >= 400) {
      throw 'Error Connexion';
    }

    List<Service> servicesList = [];
    final fetchedServices = json.decode(response.body) as List<dynamic>;

    if (fetchedServices == null) {
      return;
    }

    for (Map item in fetchedServices) {
      servicesList.add(
        Service(
          id: item['id'].toString(),
          tour: item['tour'],
          type: item['type'],
          createdAt: DateTime.parse(item['created_at']),
          deletedAt: item['deleted_at'] == null
              ? null
              : DateTime.parse(item['deleted_at']),
          customer: Customer(
              id: item['id'].toString(),
              fullName: item['name'].toString(),
              phoneNumber: item['phone'].toString(),
              palettes: (item['produits'] as List<dynamic>)
                  .map(
                    (e) => Palette(
                        //id: e['id'].toString(),
                        nombreSac: e['nombre_sac'],
                        poids: double.parse(e['tonnage'].toString())),
                  )
                  .toList()),
        ),
      );
    }

    if (serviceType == 'principale') {
      _services = servicesList.reversed.toList();
    } else {
      _deletedServices = servicesList;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetAwaitingService() async {
    String url = '$urlServer/api/clients-awaiting';

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(
      Duration(seconds: 8),
      onTimeout: () {
        throw 'Request Timeout';
      },
    );
    print(response.statusCode);
    if (response.statusCode >= 400) {
      throw 'Error Connexion';
    }

    List<Service> awaitingServicesList = [];
    final fetchedAwintingServices = json.decode(response.body) as List<dynamic>;

    if (fetchedAwintingServices == null) {
      return;
    }

    for (Map item in fetchedAwintingServices) {
      awaitingServicesList.add(
        Service(
          id: item['id'].toString(),
          tour: item['tour'],
          type: item['type'],
          createdAt: DateTime.parse(item['created_at']),
          deletedAt: null,
          customer: Customer(
              id: item['id'].toString(),
              fullName: item['name'].toString(),
              phoneNumber: item['phone'].toString(),
              palettes: (item['produits'] as List<dynamic>)
                  .map(
                    (e) => Palette(
                        //id: e['id'].toString(),
                        nombreSac: e['nombre_sac'],
                        poids: double.parse(e['tonnage'].toString())),
                  )
                  .toList()),
        ),
      );
    }

    _awaitingServices = awaitingServicesList.reversed.toList();

    notifyListeners();
  }

  Future<void> deleteCustomer(serviceId, {bool isPrincipale = true}) async {
    final url = "$urlServer/api/clients/$serviceId";

    final response = await http.delete(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    }).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw 'Request Timeout, please try again';
      },
    );
    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw 'Request Failed, please try again (client error ${response.statusCode})';
    } else if (response.statusCode >= 500) {
      throw 'Request Failed, please try again (server error ${response.statusCode})';
    }
    var timedeleted = json.decode(response.body)['deleted_at'];
    print(timedeleted);
    if (isPrincipale) {
      Service current =
          _services.firstWhere((service) => service.id == serviceId);
      current.deletedAt = DateTime.parse(timedeleted);
      _deletedServices.insert(0, current);
      _services.removeWhere((element) => element.id == serviceId);
    } else {
      Service current =
          _awaitingServices.firstWhere((service) => service.id == serviceId);
      current.deletedAt = DateTime.parse(timedeleted);
      _deletedServices.insert(0, current);
      _awaitingServices.removeWhere((element) => element.id == serviceId);
    }
    notifyListeners();
    //Future.delayed(Duration(seconds: 1), () => notifyListeners());
  }

  void notifyLisner() {
    notifyLisner();
  }

  Future<dynamic> addService(
      {@required Customer newCustomer,
      @required int tour,
      String type = "principale"}) async {
    final url = '$urlServer/api/clients';
    print(url);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'userId': userId,
          'name': newCustomer.fullName,
          'phone': newCustomer.phoneNumber,
          'tour': tour,
          "type": type,
          'produits': newCustomer.palettes.map((e) {
            return {
              'nombre_sac': e.nombreSac,
              'tonnage': e.poids,
            };
          }).toList(),
        }),
      );

      if (response.statusCode >= 400) {
        throw 'Error connexion!';
      }

      final newServiceId = json.decode(response.body)['id'];
      final newService = Service(
        id: newServiceId.toString(),
        createdAt: DateTime.parse(json.decode(response.body)['created_at']),
        tour: tour,
        customer: Customer(
          id: newServiceId.toString(),
          fullName: newCustomer.fullName,
          phoneNumber: newCustomer.phoneNumber,
          palettes: newCustomer.palettes,
        ),
      );
      if (type == "principale") {
        _services.insert(0, newService);
      } else {
        _awaitingServices.insert(0, newService);
      }

      // _items.insert(0, newProduct);  to add product in the top of the list
      notifyListeners();
      return newServiceId;
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateService(String serviceId, Service newService) async {
    final url = '$urlServer/api/clients/$serviceId';

    final response = await http
        .put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'name': newService.customer.fullName,
        'phone': newService.customer.phoneNumber,
        'tour': newService.tour,
        //'created_at': timesTemp.toIso8601String(),
        'produits': newService.customer.palettes.map((e) {
          return {
            'nombre_sac': e.nombreSac,
            'tonnage': e.poids,
          };
        }).toList(),
      }),
    )
        .timeout(
      Duration(seconds: 8),
      onTimeout: () {
        throw 'Request Timeout, please check the server and try again';
      },
    );

    print(json.decode(response.body));

    if (response.statusCode >= 400 && response.statusCode < 500) {
      throw 'Request Failed, please try again (client error${response.statusCode})';
    } else if (response.statusCode >= 500) {
      throw 'Request Failed, please try again (server error${response.statusCode})';
    }
    print(json.decode(response.body));

    int currentServiceIndex =
        _services.indexWhere((element) => element.id == serviceId);
    _services[currentServiceIndex] = newService;
    notifyListeners();
  }
}
