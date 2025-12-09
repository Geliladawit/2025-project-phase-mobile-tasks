import 'package:dartz/dartz.dart';
import '../error/failures.dart';

// Type = What the use case returns (e.g., Product)
// Params = What the use case needs (e.g., String id)
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}