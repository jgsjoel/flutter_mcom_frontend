import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mcommerce/components/Loading.dart';
import 'package:mcommerce/pages/CartPage.dart';
import 'package:mcommerce/pages/CategorySearch.dart';
import 'package:mcommerce/pages/CheckOutPage.dart';
import 'package:mcommerce/pages/LoginPage.dart';
import 'package:mcommerce/pages/MainLayout.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mcommerce/pages/MapPage.dart';
import 'package:mcommerce/pages/ProductPage.dart';
import 'package:mcommerce/state/Authentication.dart';
import 'package:mcommerce/state/CheckoutState.dart';
import 'package:mcommerce/state/FirebaseState.dart';
import 'package:mcommerce/state/GlobalState.dart';
import 'package:mcommerce/state/MapState.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthState()),
      ChangeNotifierProvider(create: (_) => Globalstate()),
      ChangeNotifierProvider(create: (_) => MapState()),
      ChangeNotifierProvider(create: (_) => CheckoutState()),
      ChangeNotifierProvider(create: (_) => FirebaseState()),
    ],
    child: const Myapp(),
  ));
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        textTheme: GoogleFonts.quicksandTextTheme(),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: const Color.fromARGB(255, 132, 131, 131).withOpacity(0.5),
          selectionHandleColor: const Color.fromARGB(255, 132, 131, 131),
        ),
        tabBarTheme: const TabBarTheme(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 14),
        ),
      ),
      home: FutureBuilder(
        future: checkAuthToken(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return Loading();
          }

          if (snapShot.data == true) {
            return Mainlayout();
          } else {
            return LoginPage();
          }
        },
      ),
      routes: {
        "/categorySearch": (context) => Categorysearch(),
        "/cartPage": (context) => CartPage(),
        "/productPage": (context) => Productpage(),
        "/checkoutPage": (context) => CheckoutPage(),
        "/mapPage": (context) => MapPage(),
        "/login": (context) => LoginPage(),
      },
    );
  }

  Future<bool> checkAuthToken() async {
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? token = await secureStorage.read(key: 'refreshToken');

    if (token != null && token.isNotEmpty) {
      bool isExpired = JwtDecoder.isExpired(token);
      if (!isExpired) {
        return true;
      }
    }
    return false;
  }
}
