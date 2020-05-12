import 'package:flutter/material.dart';

class SearchCustomerList extends StatelessWidget {
  const SearchCustomerList({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: TextField(
        autofocus: false,
        decoration: const InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.green, width: 2),
          ),
          filled: true,
          hintText: 'Search some one ..',
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
