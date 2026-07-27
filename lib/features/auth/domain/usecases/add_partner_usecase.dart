import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class AddPartnerParams extends Equatable {
  final String friendCode;

  const AddPartnerParams({required this.friendCode});

  @override
  List<Object> get props => [friendCode];
}

class AddPartnerUseCase implements UseCase<Map<String, dynamic>, AddPartnerParams> {
  final AuthRepository repository;

  AddPartnerUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(AddPartnerParams params) async {
    return await repository.addPartner(params.friendCode);
  }
}
