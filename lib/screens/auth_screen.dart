import 'package:flutter/material.dart';
import 'package:olivoalcazar/models/http_exception.dart';
import 'package:olivoalcazar/providers/auth.dart';
import 'package:provider/provider.dart';

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
                  Text(
                    'olivo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontFamily: 'Monoton',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[AuthCard(deviceSize: deviceSize)],
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
    }
    isInit = false;
    super.didChangeDependencies();
  }

  var _isLoading = false;
  void _showDialogError(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              backgroundColor: Colors.black87,
              title: Text('An error Occured!'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Okey'))
              ],
            ));
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
          _authData['username'], _authData['password'], _authData['urlServer']);
    } on HttpException catch (error) {
      var errorMessage = 'Invalid Email or Password';
      _showDialogError(error.toString());
    } catch (error) {
      var errorMessage = 'Login Faild, please try again';
      _showDialogError(error);
    }
    setState(() {
      _isLoading = false;
    });
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
                  hintText: 'Server URL',
                  fillColor: Colors.greenAccent[200],
                  filled: true,
                  prefixIcon: Icon(Icons.cloud_queue),
                ),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Invalid server url!';
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
                    'Username',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ],
              ),
              TextFormField(
                //decoration: InputDecoration(hintText: ' Username'),
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Invalid Username!';
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
                    'Password',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                ],
              ),
              TextFormField(
                //decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value.isEmpty || value.length < 5) {
                    return 'Password is too short!';
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
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: _submit,
                        child: Text('Login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 24)),
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
