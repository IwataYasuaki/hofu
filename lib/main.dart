import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hofu/models/hofu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'HOFU',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lime),
          useMaterial3: true,
          fontFamily: "Noto Sans JP",
        ),
        home: const MyHomePage(title: '抱負'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  Widget page = const HofuForm();
  Hofu? hofu;

  void hofuCreated(Hofu hofu) {
    page = const HofuPage();
    this.hofu = hofu;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    var page = myAppState.page;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: page,
    );
  }
}

class HofuForm extends StatefulWidget {
  const HofuForm({super.key});

  @override
  State<HofuForm> createState() {
    return _HofuFormState();
  }
}

class _HofuFormState extends State<HofuForm> {
  final _formKey = GlobalKey<FormState>();
  final hofuController = TextEditingController();

  @override
  void dispose() {
    hofuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: HofuFormCard(formKey: _formKey, hofuController: hofuController),
    );
  }
}

class HofuFormCard extends StatelessWidget {
  const HofuFormCard({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.hofuController,
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final TextEditingController hofuController;

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background,
                  hintText: '(例) 12月までに体重を60kg以下にする！',
                ),
                controller: hofuController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // 抱負を登録する
                      final SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      var hofu = Hofu(pref, hofuController.text);
                      hofu.save();
                      myAppState.hofuCreated(hofu);
                    }
                  },
                  child: const Text('登録'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HofuPage extends StatelessWidget {
  const HofuPage({super.key});

  @override
  Widget build(BuildContext context) {
    var myAppState = context.watch<MyAppState>();
    var hofu = myAppState.hofu;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(hofu!.content, style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
