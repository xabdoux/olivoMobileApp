import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';
import '../providers/auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key key}) : super(key: key);
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(5, 21, 43, 1),
      body: SingleChildScrollView(
        child: Container(
          height: deviceSize.height,
          width: deviceSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/olivo_white.png',
                    height: 80,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AuthCard(deviceSize: deviceSize),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key key,
    @required this.deviceSize,
  }) : super(key: key);

  final Size deviceSize;

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _urlServerController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Map<String, String> _authData = {
    'urlServer': '',
    'username': '',
    'password': '',
  };
  String urlServer;
  var isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      Provider.of<Auth>(context, listen: false)
          .getUrlServer()
          .then((value) => _urlServerController.text = value);
      Provider.of<Auth>(context, listen: false)
          .getUsername()
          .then((value) => _usernameController.text = value);
    }
    isInit = false;
    super.didChangeDependencies();
  }

  var _isLoading = false;
  Future<void> _showDialogError(String message, String type) async {
    IconData icon = Icons.fingerprint;
    String titleError = "Erreur d'informations d'identification";

    if (type == 'server') {
      icon = Icons.cloud_off;
      titleError = 'Erreur du serveur';
    } else if (type == 'other') {
      icon = Icons.warning;
      titleError = 'Oops! il y a eu un problème!';
    }

    await showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.red[300],
        child: Container(
          height: widget.deviceSize.height * 0.45,
          width: widget.deviceSize.width * 0.8,
          child: Column(
            children: <Widget>[
              Flexible(
                child: Container(
                  color: Colors.red[300],
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          icon,
                          size: 70,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          titleError,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          message,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 20),
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 120,
                          height: 40,
                          child: FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'RÉESSAYEZ',
                              style: TextStyle(fontSize: 20),
                            ),
                            color: Colors.red[300],
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
    setState(() {
      _isLoading = false;
    });
    return;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Auth>(context, listen: false).authenticate(
          _authData['username'],
          _authData['password'],
          _authData['urlServer'],
          context);
    } on HttpException catch (_) {
      var errorMessage = 'Email ou mot de passe invalide';
      await _showDialogError(errorMessage, 'credentials');
    } on SocketException catch (_) {
      var errorMessage =
          'Impossible de se connecter au serveur, veuillez vérifier le serveur et réessayer';
      await _showDialogError(errorMessage, 'server');
    } catch (error) {
      // var errorMessage =
      //     "Échec de la connexion, vérifiez l'URL du serveur et réessayez";
      await _showDialogError(error.toString(), 'other');
    }
    setState(() {
      _isLoading = false;
    });
    //Navigator.of(context).pushReplacementNamed(CustomersListScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      height: widget.deviceSize.height * 0.60,
      width: widget.deviceSize.width * 0.90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _urlServerController,
                decoration: InputDecoration(
                  hintText: 'Serveur URL',
                  fillColor: Colors.greenAccent[200],
                  filled: true,
                  prefixIcon: Icon(Icons.cloud_queue),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'URL de serveur non valide!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['urlServer'] = value;
                },
              ),
              Divider(),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.account_circle, color: Colors.green[300]),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Nom d'utilisateur",
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
              TextFormField(
                //decoration: InputDecoration(hintText: ' Username'),
                controller: _usernameController,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Nom d'utilisateur invalide!";
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['username'] = value;
                },
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.lock, color: Colors.green[300]),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Mot de passe',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),
              TextFormField(
                obscureText: true,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Le mot de passe est trop court!';
                  }
                  return null;
                },
                onSaved: (value) {
                  _authData['password'] = value;
                },
              ),
              SizedBox(
                height: 30,
              ),
              _isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      height: 50,
                      width: widget.deviceSize.width * 0.4,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: _submit,
                        child: FittedBox(
                          child: Text('SE CONNECTER',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24)),
                        ),
                        color: Colors.green[300],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
