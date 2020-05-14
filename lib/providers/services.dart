import 'package:flutter/Material.dart';

import '../providers/customer.dart';
import '../providers/palette.dart';
import '../providers/service.dart';

class Services with ChangeNotifier {
  List<Service> _services = [
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: null,
      rendement: 20,
      id: 's1',
      isPrincipale: true,
      tour: 1,
      customer: Customer(
          id: 'c1',
          fullName: 'Abdellah jaadi',
          phoneNumber: '06 79 01 99 02',
          palettes: [
            Palette(id: 'p1', nombreSac: 13, poids: 345),
            Palette(id: 'p2', nombreSac: 17, poids: 585),
            Palette(id: 'p3', nombreSac: 11, poids: 655),
            Palette(id: 'p4', nombreSac: 6, poids: 544),
            Palette(id: 'p5', nombreSac: 19, poids: 234),
            Palette(id: 'p6', nombreSac: 12, poids: 667),
          ]),
    ),
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: null,
      rendement: 20,
      id: 's2',
      isPrincipale: true,
      tour: 2,
      customer: Customer(
          id: 'c2',
          fullName: 'Kamal Azzdin',
          phoneNumber: '06 79 01 99 02',
          palettes: [
            Palette(id: 'p7', nombreSac: 13, poids: 345),
            Palette(id: 'p8', nombreSac: 17, poids: 585),
            Palette(id: 'p9', nombreSac: 11, poids: 655),
            Palette(id: 'p10', nombreSac: 6, poids: 544),
            Palette(id: 'p11', nombreSac: 19, poids: 234),
            Palette(id: 'p12', nombreSac: 12, poids: 667),
          ]),
    ),
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: null,
      rendement: 20,
      id: 's3',
      isPrincipale: true,
      tour: 3,
      customer: Customer(
        id: 'c3',
        fullName: 'Ahmed GHarabti',
        phoneNumber: '06 79 01 99 02',
        palettes: [
          Palette(id: 'p13', nombreSac: 13, poids: 345),
          Palette(id: 'p14', nombreSac: 17, poids: 585),
          Palette(id: 'p15', nombreSac: 11, poids: 655),
          Palette(id: 'p16', nombreSac: 6, poids: 544),
          Palette(id: 'p17', nombreSac: 19, poids: 234),
          Palette(id: 'p18', nombreSac: 12, poids: 667),
        ],
      ),
    ),
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: null,
      rendement: 20,
      id: 's4',
      isPrincipale: true,
      tour: 4,
      customer: Customer(
          id: 'c4',
          fullName: 'Trik Touis',
          phoneNumber: '06 79 01 99 02',
          palettes: [
            Palette(id: 'p19', nombreSac: 13, poids: 345),
            Palette(id: 'p20', nombreSac: 17, poids: 585),
            Palette(id: 'p21', nombreSac: 11, poids: 655),
            Palette(id: 'p22', nombreSac: 6, poids: 544),
            Palette(id: 'p23', nombreSac: 19, poids: 234),
            Palette(id: 'p24', nombreSac: 12, poids: 667),
          ]),
    ),
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: DateTime(2020, 9, 7, 16, 30),
      rendement: 20,
      id: 's5',
      isPrincipale: true,
      tour: 5,
      customer: Customer(
          id: 'c5',
          fullName: 'Yassin Jamal',
          phoneNumber: '06 79 01 99 02',
          palettes: [
            Palette(id: 'p25', nombreSac: 13, poids: 345),
            Palette(id: 'p26', nombreSac: 17, poids: 585),
            Palette(id: 'p27', nombreSac: 11, poids: 655),
            Palette(id: 'p28', nombreSac: 6, poids: 544),
            Palette(id: 'p29', nombreSac: 19, poids: 234),
            Palette(id: 'p30', nombreSac: 12, poids: 667),
          ]),
    ),
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: DateTime(2020, 9, 7, 16, 30),
      rendement: 20,
      id: 's6',
      isPrincipale: true,
      tour: 6,
      customer: Customer(
          id: 'c6',
          fullName: 'Ayoub jemmal',
          phoneNumber: '06 79 01 99 02',
          palettes: [
            Palette(id: 'p31', nombreSac: 13, poids: 345),
            Palette(id: 'p32', nombreSac: 17, poids: 585),
            Palette(id: 'p33', nombreSac: 11, poids: 655),
            Palette(id: 'p34', nombreSac: 6, poids: 544),
            Palette(id: 'p35', nombreSac: 19, poids: 234),
            Palette(id: 'p36', nombreSac: 12, poids: 667),
          ]),
    ),
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: null,
      rendement: 20,
      id: 's7',
      isPrincipale: true,
      tour: 1,
      customer: Customer(
          id: 'c7',
          fullName: 'Taoufik Aziouez',
          phoneNumber: '06 79 01 99 02',
          palettes: [
            Palette(id: 'p41', nombreSac: 13, poids: 345),
            Palette(id: 'p42', nombreSac: 17, poids: 585),
            Palette(id: 'p43', nombreSac: 11, poids: 655),
            Palette(id: 'p44', nombreSac: 6, poids: 544),
            Palette(id: 'p45', nombreSac: 19, poids: 234),
            Palette(id: 'p46', nombreSac: 12, poids: 667),
          ]),
    ),
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: null,
      rendement: 20,
      id: 's8',
      isPrincipale: true,
      tour: 2,
      customer: Customer(
          id: 'c8',
          fullName: 'Jammal ahmad',
          phoneNumber: '06 79 01 99 02',
          palettes: [
            Palette(id: 'p51', nombreSac: 13, poids: 345),
            Palette(id: 'p52', nombreSac: 17, poids: 585),
            Palette(id: 'p53', nombreSac: 11, poids: 655),
            Palette(id: 'p54', nombreSac: 6, poids: 544),
            Palette(id: 'p55', nombreSac: 19, poids: 234),
            Palette(id: 'p56', nombreSac: 12, poids: 667),
          ]),
    ),
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: null,
      rendement: 20,
      id: 's9',
      isPrincipale: true,
      tour: 3,
      customer: Customer(
          id: 'c9',
          fullName: 'Amine Sabli',
          phoneNumber: '06 79 01 99 02',
          palettes: [
            Palette(id: 'p61', nombreSac: 13, poids: 345),
            Palette(id: 'p62', nombreSac: 17, poids: 585),
            Palette(id: 'p63', nombreSac: 11, poids: 655),
            Palette(id: 'p64', nombreSac: 6, poids: 544),
            Palette(id: 'p65', nombreSac: 19, poids: 234),
            Palette(id: 'p66', nombreSac: 12, poids: 667),
          ]),
    ),
    Service(
      createdAt: DateTime(2020, 9, 7, 14, 30),
      deletedAt: null,
      rendement: 20,
      id: 's10',
      isPrincipale: true,
      tour: 4,
      customer: Customer(
          id: 'c10',
          fullName: 'Abdellah jaadi',
          phoneNumber: '06 79 01 99 02',
          palettes: [
            Palette(id: 'p71', nombreSac: 13, poids: 345),
            Palette(id: 'p72', nombreSac: 17, poids: 585),
            Palette(id: 'p73', nombreSac: 11, poids: 655),
            Palette(id: 'p74', nombreSac: 6, poids: 544),
            Palette(id: 'p75', nombreSac: 19, poids: 234),
            Palette(id: 'p76', nombreSac: 12, poids: 667),
          ]),
    ),
  ];

  List<Service> get all {
    return _services;
  }

  List<Service> get principaleServices {
    return _services
        .where((service) =>
            service.isPrincipale == true && service.deletedAt == null)
        .toList();
  }

  List<Service> get deletedServices {
    return _services.where((service) => service.deletedAt != null).toList();
  }

  void restorService(serviceId) {
    Service current =
        _services.firstWhere((service) => service.id == serviceId);
    current.deletedAt = null;
    notifyListeners();
  }

  void deleteCustomer(serviceId) {
    Service current =
        _services.firstWhere((service) => service.id == serviceId);
    current.deletedAt = DateTime.now();
    notifyListeners();
  }

  void addService(
      {@required String serviceId,
      @required Customer newCustomer,
      @required int tour,
      @required bool isPrincipale}) {
    _services.add(
      Service(
        id: serviceId,
        customer: newCustomer,
        tour: tour,
        isPrincipale: isPrincipale,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void updateService(String serviceId, Service newService) {
    int currentServiceIndex =
        _services.indexWhere((element) => element.id == serviceId);
    _services[currentServiceIndex] = newService;
    notifyListeners();
  }
}
