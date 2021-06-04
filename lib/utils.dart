import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils {
  static StreamTransformer transformer<T>(T Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
          final snaps = data.docs.map((doc) => doc.data()).toList();
          final users = snaps.map((json) => fromJson(json)).toList();
          sink.add(users);
        },
      );

  static DateTime toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static formatDateTime(DateTime dateTime) {
    if (dateTime.day == DateTime.now().day) {
      return DateFormat('H: mm a').format(dateTime);
    } else if (dateTime.isBefore(DateTime.now().subtract(Duration(hours: 168)))) {
      return DateFormat('EEE, d, MMM, yyy, H:mm a').format(dateTime);
    } else if (dateTime.isBefore(DateTime.now().subtract(Duration(hours: 12)))) {
      return DateFormat('EEE, H:mm a').format(dateTime);
    } else {
      return DateFormat('H: mm a').format(dateTime);
    }
  }

  static String generateImageUid() {
    var randomGenerator = Random.secure();
    var noteId = List.generate(12, (_) => randomGenerator.nextInt(1000000000));
    return noteId.first.toString();
  }
}
