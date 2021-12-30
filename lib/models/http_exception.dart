class HttpException implements Exception {
  final String exception;
  HttpException(this.exception);
  @override
  String toString() {
    return exception;
//return super.toString();//Instence of HttpException
  }
}
