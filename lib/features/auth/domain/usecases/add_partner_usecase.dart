import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class AddPartnerUseCase implements UseCase<Map<String, dynamic>, String> {
  final AuthRepository repository;

  AddPartnerUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String friendCode) async {
    return await repository.addPartner(friendCode);
  }
}
