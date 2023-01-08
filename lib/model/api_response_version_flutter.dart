class ApiResponseVersionFlutter {
  String versionNeed, currentVersion;
  bool serverError;
  bool needUpdate;
  ApiResponseVersionFlutter(this.versionNeed, this.currentVersion, this.serverError, this.needUpdate);
}