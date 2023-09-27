import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/services.dart';
import 'result_notice.dart';

Random _random = Random();

class GuessPage extends StatefulWidget {
  const GuessPage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    controller.forward();
  }

  int _value = 0;
  bool _guessing = false;
  bool? _isBig;

  void _generateRandomValue() {
    setState(() {
      _guessing = true;
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _value without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _value = _random.nextInt(100);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  TextEditingController _guessCtrl = TextEditingController();

  void _onCheck() {
    print('=====Check:目标数值：$_value,${_guessCtrl.text}');
    int? guessValue = int.tryParse(_guessCtrl.text);
    if (!_guessing || guessValue == null) return;
    controller.forward(from: 0);
    if (guessValue == _value) {
      setState(() {
        _isBig = null;
        _guessing = false;
      });
      return;
    }
    setState(() {
      _isBig = guessValue > _value;
    });
    _guessCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: _onCheck,
              icon: const Icon(
                Icons.run_circle_outlined,
                color: Colors.blue,
              ))
        ],
        title: TextField(
          controller: _guessCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              filled: true,
              fillColor: Color(0xffF3F6F9),
              constraints: BoxConstraints(maxHeight: 35),
              border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              hintText: '输入0~99的数字',
              hintStyle: TextStyle(fontSize: 14)),
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarBrightness: Brightness.dark,
            statusBarColor: Colors.transparent),
      ),
      body: Stack(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          children: [
            if (_isBig != null)
              Column(
                children: [
                  if (_isBig!)
                    ResultNotice(
                        color: Colors.redAccent,
                        info: '大了',
                        controller: controller),
                  Spacer(),
                  if (!_isBig!)
                    ResultNotice(
                        color: Colors.blueAccent,
                        info: '小了',
                        controller: controller)
                ],
              ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (!_guessing) Text('点击生成随机数值'),
                  Text(
                    _guessing ? '**' : '$_value',
                    style: const TextStyle(
                        fontSize: 68, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            )
          ]
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          // mainAxisAlignment: MainAxisAlignment.center,
          // children: <Widget>[
          //   const Text('点击生成随机值'),
          //   Text(
          //     '$_value',
          //     style: Theme.of(context).textTheme.headlineMedium,
          //   ),
          // ],
          // ),
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: _guessing ? null : _generateRandomValue,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
