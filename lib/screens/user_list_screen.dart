import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import 'user_detail_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.fetchUsers();
    Future.delayed(Duration(milliseconds: 2000), () {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.fetchUsers();
    });
  }

  Future<void> _refreshUsers() async {
    await Provider.of<UserProvider>(context, listen: false).fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User List',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set text color to white
          ),
        ),
        backgroundColor: Colors.indigoAccent,
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (userProvider.errorMessage != null) {
            return Center(child: Text(userProvider.errorMessage!));
          } else {
            return RefreshIndicator(
              onRefresh: _refreshUsers,
              child: ListView.separated(
                itemCount: userProvider.users.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.grey[300], thickness: 1),
                itemBuilder: (context, index) {
                  final user = userProvider.users[index];
                  return ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.indigoAccent.withOpacity(0.8),
                      child: Text(
                        user.name[0],
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      user.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      user.email,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 18, color: Colors.grey[600]),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(user: user),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
