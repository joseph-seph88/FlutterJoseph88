import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> getCachedUser();
  Future<void> cacheUser(UserModel userToCache);
  Future<void> clearCachedUser();
}

const CACHED_USER = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> getCachedUser() async{
    final jsonString = sharedPreferences.getString(CACHED_USER);
    if (jsonString != null) {

      // return Future.value(UserModel.fromJson(json.decode(jsonString)));
    } else {
      throw Exception();
    }
  }

  @override
  Future<void> cacheUser(UserModel userToCache) async{
    // return sharedPreferences.setString(
    //   CACHED_USER,
      // json.encode(userToCache.toJson()),
    // );
  }

  @override
  Future<void> clearCachedUser() {
    return sharedPreferences.remove(CACHED_USER);
  }
}