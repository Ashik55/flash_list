import 'package:flutter/material.dart';
import 'package:flash_list/flash_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashList Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  final List<String> items = [];
  bool isLoading = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      items.addAll(List.generate(20, (index) => 'Item ${index + 1}'));
      isLoading = false;
    });
  }

  Future<void> _loadMore() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      items.addAll(
        List.generate(
          20,
          (index) => 'Item ${items.length + index + 1}',
        ),
      );
      hasMore = items.length < 100;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      items.clear();
      hasMore = true;
    });
    await _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlashList Example')),
      body: FlashList<String>(
        data: items,
        isLoading: isLoading,
        hasMore: hasMore,
        headerTitle: 'Items List',
        onLoadMore: _loadMore,
        onRefresh: _onRefresh,
        itemBuilder: (context, item, index) => ListTile(
          title: Text(item),
          subtitle: Text('Index: $index'),
        ),
      ),
    );
  }
}
