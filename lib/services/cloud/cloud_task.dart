import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:incrementapp/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudTask {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudTask({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  CloudTask.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
