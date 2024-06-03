import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking/services/HttpLogin.dart';
import 'package:parking/services/HttpLotService.dart';
import 'package:parking/services/HttpRegister.dart';
import 'package:parking/services/HttpSpotService.dart';
import 'package:parking/services/HttpZoneService.dart';
import 'package:parking/viewmodels/AdminViewModel.dart';
import 'package:parking/viewmodels/AdminZoneViewModel.dart';
import 'package:parking/viewmodels/LoginViewModel.dart';
import 'package:parking/viewmodels/AdminLotViewModel.dart';
import 'package:parking/viewmodels/RegisterViewModel.dart';
import 'package:parking/viewmodels/UserLotViewModel.dart';
import 'package:parking/viewmodels/UserViewModel.dart';
import 'package:parking/viewmodels/UserZoneViewModel.dart';
import 'package:parking/views/admin_view.dart';
import 'package:parking/views/admin_zone_view.dart';
import 'package:parking/views/login_view.dart';
import 'package:parking/views/admin_lot_view.dart';
import 'package:parking/views/register_view.dart';
import 'package:parking/views/user_lot_view.dart';
import 'package:parking/views/user_view.dart';
import 'package:parking/views/user_zone_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:parking/views/main_view.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  var status = await Permission.location.request();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (_) => LoginViewModel(
          httpService: locator<LoginHttpService>(),
        ),
      ),
      ChangeNotifierProvider(
        create: (_) => RegisterViewModel(
          httpService: locator<RegisterHttpService>(),
        ),
      )
      ,ChangeNotifierProvider(create: (context)=>AdminViewModel(
          httpService:locator<HttpLotService>())
      )
      ,
      ChangeNotifierProvider(create: (context)=>AdminLotViewModel(httpService:locator<HttpZoneService>())),
      ChangeNotifierProvider(create: (context)=>AdminZoneViewModel(httpService:locator<HttpSpotService>())),
      ChangeNotifierProvider(create: (context)=>UserViewModel(httpService:locator<HttpLotService>())),
      ChangeNotifierProvider(create: (context)=>UserLotViewModel(httpService:locator<HttpZoneService>())),
      ChangeNotifierProvider(create: (context)=>UserZoneViewModel(httpService:locator<HttpSpotService>())),

    ],
    child: const MainPage(),
  ));});
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ParkFast',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.blue,
          selectionColor: Colors.blue,
          selectionHandleColor: Colors.blue,
        ),
      ),
      initialRoute: '/main',
      routes: {
        '/main': (context) => const MyHomePage(),
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/admin':(context)=> const AdminPage(),
        '/adminLot':(context)=> const AdminLotPage(),
        '/adminSpots':(context)=> const AdminZonePage(),
        '/user':(context)=> const UserPage(),
        '/userLot':(context)=> const UserLotPage(),
        '/userSpots':(context)=> const UserZonePage()
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }
}





























class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
    );
  }
}
