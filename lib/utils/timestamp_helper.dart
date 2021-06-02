import 'package:cloud_firestore/cloud_firestore.dart';

DateTime timestampHelper({required Timestamp timestamp}) {
  return timestamp.toDate();
}
