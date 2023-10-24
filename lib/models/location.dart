class SchoolLocation{
  String stateLongName;
  String stateShortName;
  String countryLongName;
  String countryShortName;
  String formattedAddress;
  String zipCode;
  double lat;
  double lon;
  Map jsonVersion;
  SchoolLocation({this.zipCode = "", this.stateLongName = "", this.stateShortName = "", this.countryLongName = "", this.countryShortName = "", this.formattedAddress = "", this.lat = 0, this.lon = 0, this.jsonVersion = const {}});
  void fromJson(Map jsonData, ){
    jsonVersion = jsonData;
    zipCode = jsonData["address_components"][0]["long_name"];
    for(Map components in jsonData["address_components"]){
      if(components["types"].contains("administrative_area_level_1")){
        stateLongName = components["long_name"];
        stateShortName = components["short_name"];
      }
      if(components["types"].contains("country")){
        countryLongName = components["long_name"];
        countryShortName = components["short_name"];
      }
      if(components["types"].contains("postal_code")){
        zipCode = components["long_name"];
      }
    }
    formattedAddress = jsonData["formatted_address"];
    lat = jsonData["geometry"]["location"]["lat"];
    lat = jsonData["geometry"]["location"]["lng"];
  }
  Map toJson(){
    return jsonVersion;
  }
}