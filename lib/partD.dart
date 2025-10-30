import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class PartDScreen extends StatefulWidget {
  @override
  State<PartDScreen> createState() => _PartDScreenState();
}

class _PartDScreenState extends State<PartDScreen> {
  late Database db;
  List<Map<String, dynamic>> notes =
