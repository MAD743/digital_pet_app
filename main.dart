import 'package:flutter/material.dart';

void main() {
  runApp(const DigitalPetApp());
}

class DigitalPetApp extends StatefulWidget {
  const DigitalPetApp({super.key});

  @override
  State<DigitalPetApp> createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      home: TabsDemo(changeTheme: changeTheme),
    );
  }
}

class TabsDemo extends StatefulWidget {
  final Function(ThemeMode) changeTheme;

  const TabsDemo({super.key, required this.changeTheme});

  @override
  _TabsDemoState createState() => _TabsDemoState();
}

class _TabsDemoState extends State<TabsDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);

  @override
  String get restorationId => 'tabs_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['Pet Info', 'Pet Care', 'Settings'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digital Pet App'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [for (final tab in tabs) Tab(text: tab)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Pet Info Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Pet Name: Fluffy",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Species: Virtual Cat", style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("Age: 2 years", style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          // Pet Care Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Feeding: Needs to be fed twice a day",
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("Exercise: 30 minutes of play daily",
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text("Health: Healthy and active",
                    style: TextStyle(fontSize: 18)),
              ],
            ),
          ),
          // Settings Tab
          Center(
            child: FloatingActionButton(
              onPressed: () => widget.changeTheme(
                Theme.of(context).brightness == Brightness.dark
                    ? ThemeMode.light
                    : ThemeMode.dark,
              ),
              child: const Icon(Icons.brightness_6),
            ),
          ),
        ],
      ),
    );
  }
}
