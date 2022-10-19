import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:znny_manager/src/screens/responsive.dart';

class CustomerEditScreen extends StatefulWidget {
  const CustomerEditScreen({Key? key}) : super(key: key);

  @override
  _CustomerEditScreenState createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('注册商户'),
        ),
        body: Center(
            child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 500,
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                hintText: 'Enter a description...',
                                labelText: 'Description',
                              ),
                              onChanged: (value) {

                              },
                              maxLines: 5,
                            )
                        ],
                      )),
                ))));
  }
}
