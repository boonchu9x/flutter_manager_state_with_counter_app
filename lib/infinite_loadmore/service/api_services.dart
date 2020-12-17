import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_manage_state_basic/infinite_loadmore/model/comment_data.dart';
import 'package:http/http.dart' as http;

//lấy dữ liệu trên server từ fake urlhttps://jsonplaceholder.typicode.com/comments
//sử dụng async bất đồng bộ
Future<List<Comment>> getDataFromApi(int start, int limit) async {
  //final url = "https://jsonplaceholder.typicode.com/comments";
  //loadmore with start and limit page
  final url =
      "https://jsonplaceholder.typicode.com/comments?_start=$start&_limit=$limit";
  final http.Client httpClient = http.Client();
  try {
    final response = await httpClient.get(url);
    if (response.statusCode == 200) {
      //convert string to list
      var rawList = json.decode(response.body) as List;
      //map item list to object
      List<Comment> listComment =
          rawList.map((element) => Comment.fromJson(element)).toList();
      print(listComment[0]);
      return listComment;
    } else {
      return List<Comment>(); //return empty list
    }
  } catch (exception) {
    return List<Comment>(); //return empty list
  }
}
