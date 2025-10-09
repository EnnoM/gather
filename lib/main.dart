import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/activity_state.dart';
import 'screens/feed_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ActivityState())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '2Gather',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FeedScreen(),
    );
  }
}
