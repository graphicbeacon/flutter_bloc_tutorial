import 'package:flbloc_demo/counter/counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterApp extends StatelessWidget {
  const CounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider<CounterBloc>(
        create: (context) => CounterBloc(),
        child: const _CounterAppView(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class _CounterAppView extends StatefulWidget {
  const _CounterAppView({required this.title});

  final String title;

  @override
  State<_CounterAppView> createState() => __CounterAppViewState();
}

class __CounterAppViewState extends State<_CounterAppView> {
  void _incrementCounter() {
    context.read<CounterBloc>().add(CounterIncremented());
  }

  void _decrementCounter() {
    context.read<CounterBloc>().add(CounterDecremented());
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilding full widget tree');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            BlocBuilder<CounterBloc, int>(
              builder: (context, state) {
                print('only rebuilding this widget');

                return Text(
                  '$state',
                  style: Theme.of(context).textTheme.headline4,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
