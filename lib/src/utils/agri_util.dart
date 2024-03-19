
import 'package:flutter/material.dart';
import 'package:agri_manager/src/model/business/CheckTrace.dart';
import 'package:agri_manager/src/model/sys/LoginInfoToken.dart';
import 'package:intl/intl.dart';
import 'package:agri_manager/src/screens/business/purchase_order_view_screen.dart';
import 'package:agri_manager/src/screens/business/sale_order_view_screen.dart';
import 'package:agri_manager/src/screens/project/finance_expense_view_screen.dart';

class AgriUtil{
  static String hideMobile(String? mobile){
    if(mobile == null){
      return '';
    }else {
      String showMobile = '${mobile.substring(0, 3)}*****${mobile.substring(
          mobile.length - 3)}';

      return showMobile;
    }
  }
  
  static checkToken(LoginInfoToken loginInfoToken, BuildContext context){
    if(null != loginInfoToken.expiration) {
      int currentTime = DateTime
          .now()
          .millisecondsSinceEpoch;
      if (currentTime > loginInfoToken.expiration!) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            "/login", ModalRoute.withName('/'));
      }
    }
  }

  static String dateTimeFormat(DateTime dateTime){
    return  DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  static String showTaskStatus(int? status){
    var retString = '待开始';
    switch(status) {
      case -1:
      // statements
        retString = '已取消';
        break;
      case 1:
      // statements
        retString = '进行中';
        break;
      case 2:
      // statements
        retString = '已完成';
        break;
      default:
        retString = '待开始';
    }
    return retString;
  }

  static String showCheckStatus(int? status){
    var retString = '待审核';
    switch(status) {
      case -1:
      // statements
        retString = '不通过';
        break;
      case 0:
      // statements
        retString = '未提交';
        break;
      case 1:
      // statements
        retString = '待审核';
        break;
      case 2:
      // statements
        retString = '已审核';
        break;
    }
    return retString;
  }

  static String showCheckTraceStatus(int? status){
    var retString = '待审核';
    switch(status) {
      case -1:
      // statements
        retString = '不通过';
        break;
      case 0:
      // statements
        retString = '待审核';
        break;
      case 1:
      // statements
        retString = '已审核';
        break;
    }
    return retString;
  }

  static String showOrderStatus(int? status){
    var retString = '待处理';
    switch(status) {
      case -1:
      // statements
        retString = '已取消';
        break;
      case 1:
      // statements
        retString = '处理中';
        break;
      case 2:
      // statements
        retString = '已处理';
        break;
      default:
        retString = '待处理';
    }
    return retString;
  }


  static String showOrderType(String entityName){
    var retString = '';
    switch(entityName) {
      case 'financeExpense':
      // statements
        retString = '费用单据';
        break;
      case 'saleOrder':
      // statements
        retString = '销售订单';
        break;
      case 'purchaseOrder':
      // statements
        retString = '采购订单';
        break;
    }
    return retString;
  }

  static void toCheckView(BuildContext context, { required int entityId,  required String entityName,CheckTrace? checkTrace}){
    switch(entityName) {
      case 'financeExpense':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FinanceExpenseViewScreen(
                      id: entityId, checkTrace: checkTrace,)),
        );
        break;
      case 'saleOrder':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SaleOrderViewScreen(
                    id: entityId, checkTrace: checkTrace,)),
        );
        break;
      case 'purchaseOrder':
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PurchaseOrderViewScreen(
                    id: entityId, checkTrace: checkTrace,)),
        );
        break;
    }
  }
}