class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Error del servidor'});
}

class CacheException implements Exception {
  final String message;
  const CacheException({this.message = 'Error de cache'});
}

class AppAuthException implements Exception {
  final String message;
  const AppAuthException({this.message = 'Error de autenticacion'});
}
