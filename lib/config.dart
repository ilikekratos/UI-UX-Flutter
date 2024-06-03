class myAPI {
  static final myAPI _instance = myAPI._internal();

  factory myAPI() {
    return _instance;
  }

  myAPI._internal();
  String registerUrl = 'http://192.168.100.61:8080/user/register';
  String loginUrl = 'http://192.168.100.61:8080/user/login';
  String getLotUrl = 'http://192.168.100.61:8080/lot/getAll';
  String addLotUrl = 'http://192.168.100.61:8080/lot/add';
  String getZonesUrl= 'http://192.168.100.61:8080/zone/getAllByLot';
  String getSpotsUrl= 'http://192.168.100.61:8080/spot/getAllByZone';
  String addZoneUrl= 'http://192.168.100.61:8080/zone/add';
  String editLotNameUrl='http://192.168.100.61:8080/lot/edit';
  String editZoneNameUrl='http://192.168.100.61:8080/zone/edit';
  String deleteZoneUrl='http://192.168.100.61:8080/zone/delete';
  String addSpotUrl='http://192.168.100.61:8080/spot/add';
  String deleteSpotUrl='http://192.168.100.61:8080/spot/delete';
  String clearSpotUrl='http://192.168.100.61:8080/spot/clear';
  String updateSpotUrl='http://192.168.100.61:8080/spot/update';
  String checkUserUrl='http://192.168.100.61:8080/spot/check';
}