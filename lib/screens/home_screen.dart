import '../barrel/export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

// sign user out
  void signOut() {
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _buildUserList(),
    );
  }

  // build a list of users except for the current logged in user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView(
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        }
      },
    );
  }

  // build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    // display all users except current user
    if (_auth.currentUser!.email != data['email']) {
      return ListTile(
          title: Text(
            data['email'],
          ),
          onTap: () {
            // pass the clicked user's UID to the chat page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  receiveUserEmail: data['email'],
                  receiveUserID: data['uid'],
                ),
              ),
            );
          });
    } else {
      // return empty container
      return Container();
    }
  }
}
