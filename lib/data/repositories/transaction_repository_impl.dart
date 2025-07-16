import '../../common/errors/errors_classes.dart';
import '../../common/patterns/result.dart';
import '../../domain/entity/transaction_entity.dart';
import '../services/transaction_storage_contract.dart';
import 'transaction_repository_contract.dart';

class TransactionRepositoryImpl implements TransactionRepositoryContract {
  final TransactionStorageContract _dataSource;

  TransactionRepositoryImpl({required TransactionStorageContract dataSource})
    : _dataSource = dataSource;

  @override
  Future<Result<void, Failure>> deleteTransacion(String id) {
    return _dataSource.removeTransacion(id);
  }

  @override
  Future<Result<List<TransactionEntity>, Failure>> getAllTransacions() {
    return _dataSource.fetchAllTransacions();
  }

  @override
  Future<Result<TransactionEntity, Failure>> getTransacion(String id) {
    // TODO: implement getTransacion
    throw UnimplementedError();
  }

  @override
  Future<Result<List<TransactionEntity>, Failure>> getTransacionsByTipe(
    TransactionType type,
  ) {
    // TODO: implement getTransacionsByTipe
    throw UnimplementedError();
  }

  @override
  Future<Result<void, Failure>> saveTransacion(TransactionEntity transaction) {
    return _dataSource.storeTransacion(transaction);
  }

  @override
  Future<Result<List<TransactionEntity>, Failure>> getTransacionsByDate(
    DateTime startDate,
    DateTime endDate,
  ) {
    return _dataSource.fetchTransacionsByDate(startDate, endDate);
  }

  @override
  Future<Result<void, Failure>> editTransaction(
    TransactionEntity transaction,
  ) async {
     print('[DEBUG] Repository: chamando editTransaction...');
    try {
      await _dataSource.editTransaction(transaction);
      return Success<void, Failure>(null);
    } catch (e) {
      return Error<void, Failure>(
  DefaultError(e.toString()),
);

    }
  }
}
