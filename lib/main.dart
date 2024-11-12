import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/user_provider.dart';
import './screens/user_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'User List App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: UserListScreen(),
      ),
    );
  }
}
