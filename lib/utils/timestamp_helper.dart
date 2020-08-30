import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

DateTime timestampHelper({@required Timestamp timestamp}) {
  return timestamp.toDate();
}
