import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_with_firebase/models/coffee.dart';
import 'package:flutter_with_firebase/models/user.dart';

class DatabaseServise {
  final String uid;
  DatabaseServise({this.uid});

  final CollectionReference mdsCollection =
      Firestore.instance.collection('mds');

  //this function will be called everytime when a new user register and update data by the user
  Future updateUserData(String sugars, String name, int strength) async {
    return await mdsCollection
        .document(uid)
        .setData({'sugars': sugars, 'name': name, 'strength': strength});
  }

  //cofee list from snaphot

  List<Coffee> _coffeeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Coffee(
        name: doc.data['name'] ?? '',
        strength: doc.data['strength'] ?? 0,
        sugars: doc.data['sugars'] ?? '',
      );
    }).toList();
  }

  //get coffee stream
  Stream<List<Coffee>> get coffees {
    return mdsCollection.snapshots().map(_coffeeListFromSnapshot);
  }

  //take document snapshot and turn into user data object based on user model
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  //get user data
  Stream<UserData> get userdata {
    return mdsCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
