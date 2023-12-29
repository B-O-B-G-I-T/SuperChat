import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:superchat/pages/home_page/data/user_model.dart';

class Utils {
  static String? getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  static Future<UserModel?> getUser(String currentUserId) async {
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshot = await collection.where('id', isEqualTo: currentUserId).get();

    if (querySnapshot.docs.isNotEmpty) {
      var doc = querySnapshot.docs.first;
      return UserModel.fromFirestore(doc.data());
    } else {
      return null;
    }
  }

static Future<List<UserModel>> getUsers(String currentUserId) async {
  var collection = FirebaseFirestore.instance.collection('users');
  var querySnapshot = await collection.where('id', isNotEqualTo: currentUserId).get();

  var unsortedList = querySnapshot.docs.map((doc) => UserModel.fromFirestore(doc.data())).toList();


  var sortedList = unsortedList..sort((a, b) => a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()));

  return sortedList;
}


}
