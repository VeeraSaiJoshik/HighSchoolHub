class SchoolLocation{
  String stateLongName;
  String stateShortName;
  String countryLongName;
  String countryShortName;
  String formattedAddress;
  double lat;
  double lon;
  Map jsonVersion;
  SchoolLocation({this.stateLongName = "", this.stateShortName = "", this.countryLongName = "", this.countryShortName = "", this.formattedAddress = "", this.lat = 0, this.lon = 0, this.jsonVersion = const {}});
  void fromJson(Map jsonData, ){
    jsonVersion = jsonData;
    stateLongName = jsonData["address_components"][0]["long_name"];
    stateShortName = jsonData["address_components"][0]["short_name"];
    countryLongName = jsonData["address_components"][1]["long_name"];
    countryShortName = jsonData["address_components"][1]["short_name"];
    formattedAddress = jsonData["formatted_address"];
    lat = jsonData["geometry"]["location"]["lat"];
    lat = jsonData["geometry"]["location"]["lng"];
  }
  Map toJson(){
    return jsonVersion;
  }
}