import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class FireBaseAuthHelper {
  FireBaseAuthHelper._();
  static final FireBaseAuthHelper fireBaseAuthHelper = FireBaseAuthHelper._();

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//  TODO SignIn
  Future<User?> signIn(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      return user;
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        print("------------------------------------");
        print('Password at least Char long....');
        print("------------------------------------");
      } else if (e.code == 'email-already-in-use') {
        print("------------------------------------");
        print('The account already exists for that email.');
        print("------------------------------------");
      }
    } catch (e) {
      print(e);
    }
  }

//  TODO: FireStore DataBase
  Future setUpData(String email, String password) async {
    await FirebaseFirestore.instance
        .collection("user")
        .doc(firebaseAuth.currentUser!.uid)
        .set({
      "email": email,
      "password": password,
    });
  }

//  TODO: SignOut
  signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
