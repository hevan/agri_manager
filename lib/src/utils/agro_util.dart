
class AgroUtil{
  static String hideMobile(String? mobile){
    if(mobile == null){
      return '';
    }else {
      String showMobile = '${mobile.substring(0, 3)}*****${mobile.substring(
          mobile.length - 3)}';

      return showMobile;
    }
  }
}