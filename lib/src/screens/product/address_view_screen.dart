import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:agri_manager/src/model/sys/Address.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/shared_components/show_field_text.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'address_edit_screen.dart';

class AddressScreen extends StatefulWidget {
  final num addressId;
  const AddressScreen({Key? key, required this.addressId}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {

  Address? _address;

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  Future loadData() async {

    try {
      var retData = await DioUtils().request(
          '${HttpApi.address_find}${widget.addressId}', "GET");
      if (retData != null) {
        debugPrint(retData);
        setState(() {
          _address = Address.fromJson(retData);
        });
      }
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('地址详情'),
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return Column(children: <Widget>[
            ShowFieldText(title: '联系人', data: '${_address?.linkName}'),
            const SizedBox(
              height: kSpacing,
            ),
            ShowFieldText(title: '联系电话', data: '${_address?.linkMobile}'),
            const SizedBox(
              height: kSpacing,
            ),
            ShowFieldText(title: '区县', data: '${_address?.province}${_address?.city}${_address?.region}'),
            const SizedBox(
              height: kSpacing,
            ),
            ShowFieldText(title: '详细地址', data: '${_address?.lineDetail}'),
            const SizedBox(
              height: kSpacing,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: toAdd, child: const Text('编辑'))
              ],
            ),
            ]);
        }));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddressEditScreen()),
    );
  }
}
