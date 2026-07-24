import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/ahorro.dart';

abstract class AhorroRepository {
  Future<Either<Failure, List<Ahorro>>> getAhorros();
  Future<Either<Failure, Ahorro>> getAhorro(int id);
  Future<Either<Failure, Ahorro>> createAhorro({
    required String name,
    String description = '',
    required double targetAmount,
    String currency = 'COP',
    String? deadline,
    bool isShared = false,
  });
  Future<Either<Failure, Ahorro>> updateAhorro(int id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteAhorro(int id);
  Future<Either<Failure, double>> getTotalAhorros();
  Future<Either<Failure, Map<String, dynamic>>> deposit(int id, double amount, String description);
  Future<Either<Failure, Map<String, dynamic>>> withdraw(int id, double amount, String description);
  Future<Either<Failure, List<dynamic>>> getMovements(int id);
  Future<Either<Failure, Map<String, dynamic>>> addParticipant(int id, int userId);
}
