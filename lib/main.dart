import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shader_runner/renderer.dart';

late FragmentProgram program;

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Shaders',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 250),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int _startTime = 0;

  double get _elapsedTimeInSeconds =>
      (_startTime - DateTime.now().millisecondsSinceEpoch) / 1000;

  @override
  Widget build(BuildContext context) {
    final shaderLoader = ShaderLoader("shaders/cardioid.frag");
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: Center(
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder<ShaderLoader>(
                  future: shaderLoader.initShader(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final loader = snapshot.data!;
                      _startTime = DateTime.now().millisecondsSinceEpoch;
                      loader.setVec2Uniform(
                        "uResolution",
                        MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height,
                      );
                      loader.setVec3UniformFromColor("uColor", Colors.blueAccent);
                      return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, snapshot) {
                            loader.setFloatUniform(
                              "uTime",
                              _elapsedTimeInSeconds,
                            );
                            return CustomPaint(
                              size: Size(
                                MediaQuery.of(context).size.width,
                                MediaQuery.of(context).size.height,
                              ),
                              painter: ShaderPainter(loader.shader),
                            );
                          });
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class ShaderPainter extends CustomPainter {
  final FragmentShader shader;

  ShaderPainter(this.shader);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

Future<FragmentShader> _load() async {
  FragmentProgram program =
      await FragmentProgram.fromAsset('shaders/cardioid.frag');
  return program.fragmentShader();
}
