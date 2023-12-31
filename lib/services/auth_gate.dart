import '../barrel/export.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        // user is logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        // user is NOT logged in
        else {
          return const LoginOrRegister();
        }
      },
    ));
  }
}
