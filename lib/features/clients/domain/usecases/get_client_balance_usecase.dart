import 'package:injectable/injectable.dart';

@injectable
class GetClientBalanceUseCase {
  const GetClientBalanceUseCase();

  double call({required double totalAmount, required double totalPaid}) {
    return totalAmount - totalPaid;
  }
}
