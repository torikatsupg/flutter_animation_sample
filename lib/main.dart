import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: _LogoApp(),
      ),
    );
  }
}

class _LogoApp extends StatefulWidget {
  @override
  __LogoAppState createState() => __LogoAppState();
}

class __LogoAppState extends State<_LogoApp>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _controller;

  double status = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.bounceInOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return _GlowTransition(
      widget: _LogoWidget(),
      animation: _animation,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _GlowTransition extends StatelessWidget {
  const _GlowTransition({
    required this.widget,
    required this.animation,
    Key? key,
  }) : super(key: key);

  final Widget widget;
  final Animation<double> animation;

  static final _opacityTween = Tween<double>(begin: 0.1, end: 1);
  static final _sizeTween = Tween<double>(begin: 0, end: 300);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            opacity: _opacityTween.evaluate(animation),
            child: Container(
              height: _sizeTween.evaluate(animation),
              width: _sizeTween.evaluate(animation),
              child: child,
            ),
          );
        },
        child: widget,
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  const _LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: FlutterLogo(),
    );
  }
}
