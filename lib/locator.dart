import 'package:get_it/get_it.dart';
import 'package:parking/services/HttpLotService.dart';
import 'package:parking/services/HttpRegister.dart';
import 'package:parking/services/HttpLogin.dart';
import 'package:parking/services/HttpSpotService.dart';
import 'package:parking/services/HttpZoneService.dart';
final GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerFactory<LoginHttpService>(
          () => LoginHttpService()
  );
  locator.registerFactory<RegisterHttpService>(
          () => RegisterHttpService()
  );
  locator.registerFactory<HttpLotService>(
          () => HttpLotService()
  );
  locator.registerFactory<HttpZoneService>(
          () => HttpZoneService()
  );
  locator.registerFactory<HttpSpotService>(
          () => HttpSpotService()
  );
}