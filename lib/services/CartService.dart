import 'package:dio/dio.dart';
import 'package:mcommerce/components/Snackbar.dart';
import 'package:mcommerce/main.dart';
import 'package:mcommerce/services/ApiService.dart';
import 'package:mcommerce/state/GlobalState.dart';
import 'package:provider/provider.dart';

Future<void> addToCart(int id, int quantity) async {
  final state =
      Provider.of<Globalstate>(navigatorKey.currentContext!, listen: false);
  await Apiservice.postRequest(
    "/cart",
    {
      'productId': id,
      'quantity': quantity,
    },
    Options(headers: {
      Headers.contentTypeHeader: "application/json",
    }),
    (response) {
      state.increaseCount();
      showSnackBar("Item Added to Cart", navigatorKey.currentContext!);
    },
  );
}
