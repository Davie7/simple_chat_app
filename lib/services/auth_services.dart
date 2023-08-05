import 'package:chat_app/barrel/export.dart';

class AuthService extends ChangeNotifier {
  // instance of Auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // sign user in
  Future<UserCredential> signInWithEmailandPassword(
      String email, String password) async {
    try {
      // sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // add a new document for the user in users collection if it doesn't already exist
      _firestore.collection('users').doc(userCredential.user!.uid).set(
        {'uid': userCredential.user!.uid, 'email': email},
        SetOptions(merge: true),
      );
      return userCredential;
    }
    // catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // sign user out
  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }

  // create a new user
  Future<UserCredential> signUpWithEmailandPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create a new document for the user in the users collection
      _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email});

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // // Google Sign in
  // signInWithGoogle() async {
  //   // begin interactive sign in process
  //   final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  //   // obtain auth details from request
  //   final GoogleSignInAuthentication gAuth = await gUser!.authentication;

  //   // create a new credential for user
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: gAuth.accessToken,
  //     idToken: gAuth.idToken,
  //   );
  //   // sign in
  //   await FirebaseAuth.instance.signInWithCredential(credential);

    
  // }

  // Google Sign in
Future<UserCredential?> signInWithGoogle() async {
  // begin interactive sign in process
  final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

  if (gUser == null) {
    // User canceled the Google sign-in process
    return null;
  }

  try {
    // obtain auth details from request
    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    // create a new credential for the user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    // sign in with the credential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    // Handle any errors that might occur during the sign-in process
    throw Exception(e.toString());
  }
}

}
