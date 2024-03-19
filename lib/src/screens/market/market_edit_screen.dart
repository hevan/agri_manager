import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/market/MarkMarket.dart';
import 'package:agri_manager/src/model/product/Category.dart';
import 'package:agri_manager/src/model/sys/Address.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/product/address_edit_screen.dart';
import 'package:agri_manager/src/utils/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MarketEditScreen extends StatefulWidget {
  final MarkMarket? markMarket;
  const MarketEditScreen({
    Key? key,
    this.markMarket})
      : super(key: key);

  @override
  State<MarketEditScreen> createState() => _MarketEditScreenState();
}

 class _MarketEditScreenState extends State<MarketEditScreen> {
  final _textName = TextEditingController();
  final _textMarketType = TextEditingController();
  final _textAddress = TextEditingController();
  int _validateCode = 0;
  
  MarkMarket _market = MarkMarket();

  Address? address;

  Corp? curCorp;

  @override
  void dispose() {
    _textName.dispose();
    _textMarketType.dispose();
    _textAddress.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();


    if(widget.markMarket != null){
      setState(() {
        _market = widget.markMarket!;
        _textName.text = _market.name!;
        _textMarketType.text = _market.marketType!;
        if(null != _market.address){
          _textAddress.text = '${_market.address?.province}${_market.address?.city}${_market.address?.region}${_market.address?.lineDetail}';
        }
      });
    }
  }


  Future save() async {
    try {

       _market.name = _textName.text;
       _market.marketType = _textMarketType.text;


      if(null == _market!.id) {
        var retData = await DioUtils().request(
            HttpApi.market_add, "POST", data: json.encode(_market),isJson: true);
      }else{
        var retData = await DioUtils().request('${HttpApi.market_update}${_market!.id}', "PUT",
            data: json.encode(_market), isJson: true);
      }

      Navigator.of(context).pop();
    } on DioError catch (error) {
      CustomAppException customAppException = CustomAppException.create(error);
      debugPrint(customAppException.getMessage());
      Fluttertoast.showToast(msg: customAppException.getMessage(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('市场信息编辑'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(
            maxWidth: 500,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _textName,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '名称',
                  hintText: '输入名称',
                  errorText: _validateCode == 1 ? '名称为空' : null,
                ),
              ),
              Container(height: kSpacing,),
              TextField(
                controller: _textMarketType,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '市场分类',
                  hintText: '输入市场分类',
                  errorText: _validateCode == 1 ? '输入市场分类' : null,
                ),
              ),
              Container(height: kSpacing,),
              TextField(
                controller: _textAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: '地址',
                  hintText: '输入地址',
                  errorText: _validateCode == 1 ? '输入地址' : null,
                  suffixIcon: IconButton(
                    onPressed: () async {
                      String retAddress = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddressEditScreen(),
                              fullscreenDialog: true)
                      );
                      if(retAddress != null) {
                        setState(() {
                          _market.address = Address.fromJson(json.decode(retAddress));
                          _textAddress.text = '${_market.address?.province}${_market.address?.city}${_market.address?.region}${_market.address?.lineDetail}';
                        });

                      }
                    },
                    icon: const Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ),
              Container(height: kSpacing,),
              ElevatedButton(
                style: elevateButtonStyle,
                onPressed: () {
                  save();
                },
                child: const Text('保存'),
              )
            ],
          ),
        ),
      ),
    );
  }

}
