// branch
class RequestErrorException implements Exception
{
  String cause;
  RequestErrorException(this.cause);
}