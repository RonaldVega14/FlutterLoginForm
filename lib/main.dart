import 'package:flutter/material.dart';
import 'package:login_form/models/user_list.dart';
import 'package:login_form/pages/home_page.dart';
import 'utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Login' ),
      //Aqui se agregan las rutas para otras paginas dentro de la aplicacion.
      routes: {
      	HomePage.routeName: (BuildContext context) => new HomePage()
},
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}):super(key: key);

  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
  }

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();
  bool _isLoading = false, _userFound =false;

  String _email;
  String _password;

  @override
//Esto es para mantener un listener siempre activo.
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

//---------------------Loading stuff--------------------------------
  _showLoading() {
		setState(() {
		  _isLoading = true;
		});
    CircularProgressIndicator();
	}

	_hideLoading() {
		setState(() {
		  _isLoading = false;
		});
}


//Metodo para hacer login.
  void _login(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      _showLoading();
      performLogin();
    }
  }
//Esto sirve solo para mostrar una pequeña barra en la parte baja de la panttalla para mostrar la informacion del email y password
  void performLogin() async{
    var responseJson = await NetworkUtils.authenticateUser(_email, _password);
    //print(responseJson);
    UserList userslist =UserList.fromJson(responseJson);

    if(responseJson == null) {
				NetworkUtils.showSnackBar(scaffoldKey, 'Something went wrong!');

			} else if(responseJson == 'NetworkError') {

				NetworkUtils.showSnackBar(scaffoldKey, null);

			} else {

        for(int i = 0; i< userslist.users.length; i++){
          if(userslist.users[i].email == _email && userslist.users[i].password ==_password){
            NetworkUtils.showSnackBar(scaffoldKey, "Email: $_email, password: $_password");
            _userFound = true;
            //Cambiando de pantalla de login a HomePage
            //Se utiliza el Navidator de esta manera para que la aplicacion no permita regresar a la login page con la tecla de back.
            Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed(HomePage.routeName);
            /*Navigator.push(scaffoldKey.currentContext,
            new MaterialPageRoute(builder: (context) => HomePage()));
            Navigator.pushNamed(context, HomePage.routeName);*/
            break;
            }
          }
          if(!_userFound){
            NetworkUtils.showSnackBar(scaffoldKey, "Invalid email/password");
          }
          
        }
        _userFound = false;
        _hideLoading();
  }
//------------------------------------------------------------------------------------------------
  TextStyle style =TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black);

  @override
  Widget build(BuildContext context){
//Creando los campos para ingresar contraseña y Email
    final emailField = TextFormField(
      validator: (val) => !val.contains('@') ? 'Invalid Email' :null,
      onSaved: (val) => _email = val,
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black),
      decoration: InputDecoration(
        labelText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0)
        )
      ),
    );
//------------------------------------------------------------------------------------------------
    final passwordField =TextFormField(
//ObscureText sirve para ocultar lo que el usuario va a escribir.
      validator: (val) => !(val.length > 5) ? 'Invalid Password' :null,
      onSaved: (val) => _password = val,
      obscureText: true,
      style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black),
      decoration: InputDecoration(
//label text es necesario para cumplir con material design guidelines
        labelText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0 , 15.0 , 20.0, 15.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0)
        )
      ),
    );
//------------------------------------------------------------------------------------------------
//Creando el boton para Login
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.cyan,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: _login,
        child: Text("Login",
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
//------------------------------------------------------------------------------------------------
      final singUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.green,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: (){},
        child: Text("Sing Up",
          textAlign: TextAlign.center,
          style: style.copyWith(
            color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );

//-------------------------------------------------------------------------------------------------
//Creando la interfaz grafica
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomPadding: true,
      body: Center(
        child: new Form(
          key:formKey,
          child: Container(
            color: Colors.white,
            child: Padding(
            padding: const EdgeInsets.all(36.0),
            child:SingleChildScrollView(
              reverse: true,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//Este SizedBox sirve para crear un espacio definido donde poner la imagen o Logo.
                SizedBox(
                  height: 150.0,
                  child: Image.asset("assets/logo.png",
                  fit:BoxFit.contain,
                  ),
                ),
//Estos SizedBox sirven para crear espacios en blanco entre un campo y otro.
                SizedBox(height: 45.0),
//EmailField esta creado arriba al igual que los demas campos.(passwordField y loginButton)
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(height: 35.0),
                loginButton,
                SizedBox(height: 25.0),
                singUpButton,
                SizedBox(height: 15.0),
              ],
            ),
            )
          ),
        ),
        ),
      ),
    );
    
  }
  
}

