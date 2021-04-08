
import 'package:shared_preferences/shared_preferences.dart';
class Prefmanager {
//static final baseurl="http://192.168.50.92:5000";
  static final baseurl="http://65.0.104.164";
  static setToken (var token)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
  static Future<String>  getToken ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clear()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
  static setRole (String role)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }
  static Future<String>  getRole ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }
  static setStatus (String status)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileStatus', status);
  }
  static Future<String>  getStatus ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileStatus');
  }
  static setLevel (int level)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('level', level);
  }
  static Future<int>  getLevel ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('level');
  }
  static setUserid (String id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('id', id);
  }
  static Future<String>  getUserid ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id');
  }
  static setCity (String city)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('_mySelection', city);

  }
  static Future<String>  getCity ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('_mySelection');
  }
 static Future<void> rem()async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
   prefs.remove('_mySelection');
 }

}