import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sbkiz/model/api_response_version_flutter.dart';
import 'package:sbkiz/view/alert_dialog.dart';
import 'package:sbkiz/view/app.dart';

class CheckVersion {
  Future<ApiResponseVersionFlutter> _correctVersion(String url) async {
    String version = (await PackageInfo.fromPlatform()).version;
    Uri uri = Uri.http(url, '/api/custom-data?key=VersionFlutterProject');
    var response = await http.get(uri);
    
    if (response.statusCode == 204) return ApiResponseVersionFlutter("", version, true, false);

    return ApiResponseVersionFlutter(response.body, version, false, response.body == version);
  }
  Future<Widget> checkVersion(String url) async {
    ApiResponseVersionFlutter response = await _correctVersion(url);
    if (response.serverError) return MyAlertDialog("Error code : 0", "Merci de bien vouloir donné ce code d'erreur à nos service.");
    if (response.needUpdate) return MyAlertDialog("Need Update", "Merci de bien vouloir mettre à jour l'application, vous devez passé de la version {current} à {need}".replaceFirst('{current}', response.currentVersion).replaceAll('{need}', response.versionNeed));
     return const App();
  }
}