import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

//class used for dealing with data that we want to keep saved on the phone
class InternalDatabase {
  //write data to a file on the device
  static Future<void> putData(
      String location, Map<String, dynamic> data) async {
    //get a text file with the location passed in
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File('${appDocDir.path}/$location.txt');

    //if the file doesn't exist already, create it
    bool exists = await file.exists();
    if (!exists) await file.create();

    //turn the data into a json string
    String jsonData = jsonEncode(data);

    //write the data to the file
    await file.writeAsString(jsonData);
  }

  //get data from a file on the device
  static Future<Map<String, dynamic>> getData(String location) async {
    //get a text file with the location passed in
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File('${appDocDir.path}/$location.txt');

    //don't return anything if the file doesn't exist
    bool exists = await file.exists();
    if (!exists) return null;

    //read the contents of the file
    String jsonData = await file.readAsString();

    //return the contents of the file as a map
    Map<String, dynamic> jsonObj = jsonDecode(jsonData);
    return jsonObj;
  }

  //change data within a file
  static Future<void> changeData(
      String fileLocation, String dataLocation, dynamic data) async {
    //get a text file with the location passed in
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File('${appDocDir.path}/$fileLocation.txt');

    //don't return anything if the file doesn't exist
    bool exists = await file.exists();
    if (!exists) return null;

    //read the contents of the file
    String jsonData = await file.readAsString();

    //turn the json string into a map
    Map<String, dynamic> jsonObj = jsonDecode(jsonData);

    //change the desired information
    jsonObj[dataLocation] = data;

    //turn the data back into a json string
    String newJsonData = jsonEncode(jsonObj);

    //write the data to the file
    await file.writeAsString(newJsonData);
  }

  //clears data from a given location
  static Future<void> clearData(String location) async {
    //get a text file with the location passed in
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File file = File('${appDocDir.path}/$location.txt');

    //don't delete the file if it doesn't exist
    bool exists = await file.exists();
    if (!exists) return;

    //delete the file
    await file.delete();
  }
}
