/// Exception to throw on failed API request
class RequestErrorException implements Exception {
  String cause;
  RequestErrorException(this.cause);
}