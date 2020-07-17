import 'package:flutter/material.dart';

class DynamicTextField extends StatelessWidget {
  final TextEditingController sacController = TextEditingController();
  final TextEditingController poidsController = TextEditingController();

  Widget textfieldWidget(
      {TextEditingController controller,
      BuildContext context,
      Function onsaveHndler}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
      ),
      style: TextStyle(fontSize: 30),
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      onFieldSubmitted: (value) {
        FocusScope.of(context).nextFocus();
      },
      validator: (value) {
        if (value.isEmpty) {
          return 'Please fill this field';
        }
        return null;
      },
      onSaved: onsaveHndler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: textfieldWidget(
              context: context, controller: sacController, onsaveHndler: null),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 4,
          child: textfieldWidget(
              context: context,
              controller: poidsController,
              onsaveHndler: null),
        ),
        SizedBox(
          height: 100,
        )
      ],
    );
  }
}
