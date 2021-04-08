import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
class Customer {
  final String photo;
  final String firstname;
  final String lastname;
  final String email;
  final String address;
  final String gender;
  final String mobile;
  final String dob;
  final String pin;
  Customer({this.photo,this.firstname,this.lastname,this.email,this.address,this.gender,this.mobile,this.dob,this.pin});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      photo:json['customerid']['photo'] as String,
      firstname: json['customerid']['firstName'] as String,
      lastname: json['customerid']['lastName'] as String,
      email: json['customerid']['email'] as String,
      address: json['customerid']['address'] as String,
      gender: json['customerid']['gender'] as String,
      mobile: json['phone'] as String,
      dob: json['customerid']['dob'] as String,
      pin:json['customerid']['pincode'] as String,


    );
  }
}





