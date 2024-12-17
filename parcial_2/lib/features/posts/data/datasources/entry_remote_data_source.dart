import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:parcial_2/core/error/exceptions.dart';
import 'package:parcial_2/features/posts/data/models/entry_model.dart';

abstract interface class EntryRemoteDataSource {
  Future<EntryModel> uploadEntry(EntryModel entry);
  Future<String> uploadEntryImage(File image, EntryModel entry);
  Future<List<EntryModel>> getAllEntries();
  Future<EntryModel> getEntry(String entryId);
  Future<void> deleteEntry(String entryId);
  Future<EntryModel> updateEntry(String entryId, EntryModel entry);
  Future<String> updateEntryImage(File image, EntryModel entry);
}

class EntryRemoteDataSourceImpl implements EntryRemoteDataSource {
  final FirebaseFirestore firebaseFirestore;
  EntryRemoteDataSourceImpl(this.firebaseFirestore);

  @override
  Future<EntryModel> uploadEntry(EntryModel entry) async {
    try {
      final entryCollection = firebaseFirestore.collection('entries');
      final entryDocument = entryCollection.doc(entry.id);
      await entryDocument.set(entry.toMap());
      return Future.value(entry);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<String> uploadEntryImage(File image, EntryModel entry) async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref();

      final uniqueImageId = DateTime.now().millisecondsSinceEpoch.toString();
      final entryImageRef = storageRef.child('entries/${entry.id}_$uniqueImageId.jpg');

      await entryImageRef.putFile(image);

      return await entryImageRef.getDownloadURL();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<EntryModel>> getAllEntries() async {
    try {
      final querySnapshot = await firebaseFirestore.collection('entries').get();
      final profileSnapshot = await firebaseFirestore.collection('profiles').get();
      final profiles = {for (var doc in profileSnapshot.docs) doc.id: doc.data()['userName']};

      final entries = querySnapshot.docs.map((doc) {
        final data = doc.data();
        final posterName = profiles[data['posterId']];
        return EntryModel.fromMap(data, posterName);
      }).toList();

      return entries;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<EntryModel> getEntry(String entryId) async {
    try {
      final entryCollection = firebaseFirestore.collection('entries');
      final entryDocument = entryCollection.doc(entryId);
      return entryDocument.get().then((doc) {
        final data = doc.data();
        return EntryModel.fromMap(data!, '');
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteEntry(String entryId) async {
    try {
      final entryCollection = firebaseFirestore.collection('entries');
      final entryDocument = entryCollection.doc(entryId);

      await entryDocument.delete();

      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref().child('entries/$entryId');

      await storageRef.delete();
      return;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EntryModel> updateEntry(String entryId, EntryModel entry) async {
    try {
      final entryCollection = firebaseFirestore.collection('entries');
      final entryDocument = entryCollection.doc(entryId);
      await entryDocument.update(entry.toMap());
      return entry;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> updateEntryImage(File image, EntryModel entry) async {
    try {
      final storage = FirebaseStorage.instance;
      final storageRef = storage.ref();
      final entryImageRef = storageRef.child('entries/${entry.id}');
      await entryImageRef.putFile(image);
      return await entryImageRef.getDownloadURL();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}