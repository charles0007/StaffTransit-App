import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:staff_transit2/constant_values.dart';

import '../models/login_model.dart';
import 'encryption_controller.dart';

class ApiController extends GetxController {
  var isLoading = false.obs;
  var apiResponse = ''.obs;
  var validateEmailAPIResponse = ''.obs;
  var validateEmailAPIError = ''.obs;
  var validateEmailAPIStatus = ''.obs;


  Future<void> fetchData() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse('http://192.168.0.36:89/verification/api'));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        apiResponse.value = jsonResponse['title'];
      } else {
        apiResponse.value = 'Request failed with status: ${response.statusCode}.';
        print("response");
      }
    } finally {
      print("responsed: "+apiResponse.value);
      isLoading(false);
    }
  }



  Future<void> validateEmail(String email) async {
    print(sendTokenURL);

    final url = Uri.parse(sendTokenURL);
    final headers = {'Content-Type': 'text/plain'};
    final body = json.encode({'email': email});
final encodedBody=encryptMessage(body);
print(encodedBody);
    try {
      isLoading(true);
      final response = await http.post(url, headers: headers, body: encodedBody);

      if (response.statusCode == 200) {
        print(response.body);
        String decryptedResponse=await decryptMessage(response.body);
        final responseData = json.decode(decryptedResponse);

        print(responseData['status']);
        validateEmailAPIStatus.value= responseData['status'].toString();//ValidateEmailModelResp.fromJson(responseData).toString();
        validateEmailAPIError.value="";
      } else {
        print('Request failed with status: ${response.body}.');
        final errorResponse = json.decode(response.body);
        validateEmailAPIStatus.value=errorResponse['status'].toString();
        validateEmailAPIError.value= errorResponse['error'];// ValidateEmailModelResp.fromJson(errorResponse).toString();

      }
    } catch (error) {
      print("http error: "+error.toString());
      validateEmailAPIError.value= error.toString();// ValidateEmailModelResp(email: null,status: false,error: error.toString()).toString();
      validateEmailAPIStatus.value="false";
    }finally{
      isLoading(false);
    }
  }


}
