import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sp_util/sp_util.dart';

import 'package:znny_manager/src/utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}):super(key:key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    String? token = SpUtil.getString(Constant.accessToken, defValue: "");

    //log(token!);
    /*
    Timer(
        const Duration(seconds: 4),
        () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ["", null].contains(token) ? const Login() : const MainScreen()),
            ));

     */
    Timer(
        const Duration(seconds: 4),
            () {
              ["", null].contains(token) ? Navigator.of(context).pushNamed('/login'): Navigator.of(context).pushReplacementNamed('/home');
            });
  }
  
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 0.0,
            left: 0.0,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.8),
                    Colors.black.withOpacity(1.0),
                  ],
                ),
              ),
              child: const Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '智慧农业',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
