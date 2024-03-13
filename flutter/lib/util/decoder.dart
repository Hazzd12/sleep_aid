

import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'globalVar.dart';

void realTimeDecoder(String data){
  print("decoder: ${data}");

  print(data.length);
  print(data == "stop");
  switch(data){
    case "leaving":
      realTime[0] = "AWAY";
      break;
    case "in":
      realTime[0] = "IN";
    break; 
    case "stop":
      realTime[1] = "STOP";
      break;
    case "nobody":
      realTime[1] ="NOBODY";
      break;
    case "move":
      realTime[1] = "MOVE";
      break;
    case "Awake":
      realTime[2] = "AWAKE";
      break;
    case "Light":
      realTime[2] = "LIGHT";
      break;
    case "sleep":
      realTime[2] = "DEEP";
    default:
      if(data.isNotEmpty&&data.substring(0, 3) == "r_r"){
        realTime[3] = data.substring(4);
        amoutBre += double.parse(data.substring(4));
        count++;
      }
      break;
  }
  return;
}


void reportDecoder(String data){
  print("decoder2: ${data}");
  switch(data){
    case "at: ":
      List<String> parts = data.split('-');
      String part1 = parts[0];
      String part2 = parts[1];

      report[1] = part1;
      report[2] = part2;
      break;
    case "lt: ":
      List<String> parts = data.split('-');
      String part1 = parts[0];
      String part2 = parts[1];

      report[3] = part1;
      report[4] = part2;
      break;
    case "dt: ":
      List<String> parts = data.split('-');
      String part1 = parts[0];
      String part2 = parts[1];

      report[5] = part1;
      report[6] = part2;
      break;
    case "s: ":
      report[7] = data.substring(3);
      break;
    default:
      print("no report");
      break;
  }

}