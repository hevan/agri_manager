
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sp_util/sp_util.dart';
import 'package:agri_manager/src/model/base/Park.dart';
import 'package:agri_manager/src/model/manage/Corp.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:agri_manager/src/net/dio_utils.dart';
import 'package:agri_manager/src/net/exception/custom_http_exception.dart';
import 'package:agri_manager/src/net/http_api.dart';
import 'package:agri_manager/src/screens/base/park_edit_screen.dart';
import 'package:agri_manager/src/screens/base/park_info_card.dart';
import 'package:agri_manager/src/screens/base/park_view_screen.dart';
import 'package:agri_manager/src/shared_components/responsive_builder.dart';
import 'package:agri_manager/src/utils/constants.dart';

class ParkScreen extends StatefulWidget {
  const ParkScreen({Key? key}) : super(key: key);

  @override
  State<ParkScreen> createState() => _ParkScreenState();
}

class _ParkScreenState extends State<ParkScreen> {
  bool _sortAscending = true;
  int? _sortColumnIndex;
  bool _initialized = false;

  List<Park> listData = [];

  Park selectPark = Park();


  @override
  void didChangeDependencies() {
    loadData();
    super.didChangeDependencies();
  }

  Corp?   currentCorp;
  LoginInfoToken? userInfo;

  @override
  void initState(){
    super.initState();
    setState(() {
      currentCorp = Corp.fromJson(SpUtil.getObject(Constant.currentCorp));
      userInfo = LoginInfoToken.fromJson(SpUtil.getObject(Constant.accessToken));
    });
  }

  Future loadData() async {
    var params = {'corpId': currentCorp?.id};

    try {
      var retData = await DioUtils()
          .request(HttpApi.park_findAll, "GET", queryParameters: params);
      if (retData != null) {
        setState(() {
          listData = (retData as List).map((e) => Park.fromJson(e)).toList();

          if(listData.length > 0){
            selectPark = listData[0];
          }
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
          title: const Text('基地管理'),
        ),
        body:  ResponsiveBuilder(
          mobileBuilder: (context, constraints) {
            return _buildQuery(constraints);
          },
          tabletBuilder: (BuildContext context, BoxConstraints constraints) {
            return Row(children: [
              Flexible(flex: 4, child: _buildQuery(constraints)),
              SizedBox(
                width: 15,
                height: constraints.maxHeight,
              ),
              Flexible(
                  flex: 4,
                  child: ParkViewScreen(
                    data: selectPark,
                  )),
            ]);
          },
          desktopBuilder: (BuildContext context, BoxConstraints constraints) {
            return Row(children: [
              Flexible(flex: 4, child: _buildQuery(constraints)),
              SizedBox(
                width: 15,
                height: constraints.maxHeight,
              ),
              Flexible(
                  flex: 6,
                  child: ParkViewScreen(
                    data: selectPark,
                  )),
            ]);
          },
        ));
  }

  Widget _buildQuery(BoxConstraints viewportConstraints) {
    return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: viewportConstraints.maxHeight,
        ),
        child: IntrinsicHeight(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    // A fixed-height child.
                    height: 80.0,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(left: kSpacing, right: kSpacing),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: secondButtonStyle,
                          onPressed: () {
                            loadData();
                          },
                          child: const Text('查询'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: primaryButtonStyle,
                          onPressed: toAdd,
                          child: const Text('增加'),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: listData.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            if (ResponsiveBuilder.isMobile(context)) {
                              return ParkInfoCard(
                                  data: listData[index],
                                  onSelected: () =>
                                      toSelectView(listData[index]));
                            } else {
                              return ParkInfoCard(
                                  data: listData[index],
                                  onSelected: () => toSelect(listData[index]));
                            }
                          })),
                ])));
  }

  toAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParkEditScreen()),
    );
  }

  toSelectView(Park park) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ParkViewScreen(data: park)),
    );
  }

  toSelect(Park park) {
    setState(() {
      selectPark = park;
    });
  }
}
