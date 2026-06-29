import 'package:dartz/dartz.dart';
import '../error/failures.dart';

/// Base use case interface
/// All use cases should implement this interface
abstract class UseCase<T, Params> {
  /// Execute the use case
  Future<Either<Failure, T>> call(Params params);
}

/// Use case with no parameters
abstract class NoParamsUseCase<T> {
  /// Execute the use case
  Future<Either<Failure, T>> call();
}

/// No parameters class
class NoParams {
  const NoParams();
}
