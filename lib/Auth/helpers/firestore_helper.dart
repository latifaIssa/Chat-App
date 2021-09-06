import 'package:chat_app/Auth/helpers/auth_helper.dart';
import 'package:chat_app/Auth/models/country_model.dart';
import 'package:chat_app/Auth/models/register_requiest.dart';
import 'package:chat_app/Auth/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreHelper {
  FirestoreHelper._();
  static FirestoreHelper firestoreHelper = FirestoreHelper._();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  ////getting from Firestore
  Stream<QuerySnapshot<Map<String, dynamic>>> getFirestoreStream(
      String chatId) {
    return firebaseFirestore
        .collection(chatId)
        .orderBy('dateTime') //to sort messages
        .snapshots();
  }

  Future<List<CountryModel>> getAllCountries() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection('Countries').get();
    List<CountryModel> countries = querySnapshot.docs.map((e) {
      return CountryModel.fromJson(e.data());
    }).toList();
    return countries;
  }

  Future<UserModel> getUserFromFirestore(String userId) async {
    // firebaseFirestore.collection('Users').where('id', isEqualTo: userId).get();
    DocumentSnapshot documentSnapshot =
        await firebaseFirestore.collection('Users').doc(userId).get();
    // CustomDialog.customDialog
    //     .showCustomDialog(documentSnapshot.data.toString());
    print(documentSnapshot.data);
    return UserModel.fromMap(documentSnapshot.data());
  }

  Future<List<UserModel>> getAllUsersFromFirestore() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await firebaseFirestore.collection('Users').get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = querySnapshot.docs;
    List<UserModel> users =
        docs.map((e) => UserModel.fromMap(e.data())).toList();
    print(users.length);
    return users;
  }

/////adding to FireStore
  addUserToFirestore(RegisterRequest registerRequest) async {
    try {
      // DocumentReference documentReference = await firebaseFirestore
      //     .collection('Users')
      //     .add(registerRequest.toMap());
      // print(documentReference.id);
      await firebaseFirestore
          .collection('Users')
          .doc(registerRequest.id)
          // .add(registerRequest.toMap());
          .set(registerRequest.toMap());
    } on Exception catch (e) {
      print(e);
    }
  }

////update
  updateProfile(UserModel userModel) async {
    await firebaseFirestore
        .collection('Users')
        .doc(userModel.id)
        .update(userModel.toMap());
  }

  addMessagesToFirestore(Map map, String chatId) async {
    firebaseFirestore
        .collection(chatId)
        .add({...map, 'userId': AuthHelper.authHelper.getUserId()});
  }
}
