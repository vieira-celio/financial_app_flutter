import '../entity/transaction_entity.dart';
import '../usecase/use_case_contract.dart';
import '../../data/repositories/transaction_repository_contract.dart';
import '../../common/patterns/result.dart';
import '../../common/errors/errors_classes.dart';

class EditTransactionUseCaseImpl
    implements IUseCaseContract<Result<void, Failure>, TransactionEntity> {
  final TransactionRepositoryContract repository;

  EditTransactionUseCaseImpl({required this.repository});

  @override
  Future<Result<void, Failure>> call(TransactionEntity transaction) {
    return repository.editTransaction(transaction);
  }
}
