import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences{
  static SharedPreferences _preferences;

  static const _keyUsername = 'username';
  static const _keyFirstName = 'firstName';
  static const _keyLastName = 'lastName';
  static const _keyAddress = 'address';
  static const _keyProfilePicture = 'profilePicture';
  static const _keyToken = 'token';
  static const _keyCusId = 'id';

  static Future init() async{
    _preferences = await SharedPreferences.getInstance();
  }

  ///Set data
  static Future setUserName(String username) async{
    await _preferences.setString(_keyUsername, username);
  }

  static Future setFirstName(String firstName) async{
    await _preferences.setString(_keyFirstName, firstName);
  }

  static Future setLastName(String lastName) async{
    await _preferences.setString(_keyLastName, lastName);
  }

  static Future setAddress(String address) async{
    await _preferences.setString(_keyAddress, address);
  }

  static Future setProfilePicture(String url) async{
    await _preferences.setString(_keyProfilePicture, url);
  }

  static Future setToken(String token) async{
    await _preferences.setString(_keyToken, token);
  }

  static Future setId(int id) async{
    await _preferences.setInt(_keyCusId, id);
  }

  ///Get data
  static String getUserName() => _preferences.getString(_keyUsername);

  static String getFirstName() => _preferences.getString(_keyFirstName);

  static String getLastName() => _preferences.getString(_keyLastName);

  static String getAddress() => _preferences.getString(_keyAddress);

  static String getProfilePicture() => _preferences.getString(_keyProfilePicture);

  static String getToken() => _preferences.getString(_keyToken);

  static int getId() => _preferences.getInt(_keyCusId);


  ///Remove data
  static removeUserName() => _preferences.remove(_keyUsername);

  static removeFirstName() => _preferences.remove(_keyFirstName);

  static removeLastName() => _preferences.remove(_keyLastName);

  static removeAddress() => _preferences.remove(_keyAddress);

  static removeProfilePicture() => _preferences.remove(_keyProfilePicture);

  static removeToken() => _preferences.remove(_keyToken);

  static removeId() => _preferences.remove(_keyCusId);

}