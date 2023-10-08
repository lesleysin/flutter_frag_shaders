import 'dart:ui';

import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: FutureBuilder<FragmentShader>(
                  future: _load(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final shader = snapshot.data!;
                      _startTime = DateTime.now().millisecondsSinceEpoch;
                      // shader.setFloat(0, MediaQuery.of(context).size.width);
                      // shader.setFloat(1, MediaQuery.of(context).size.height);
                      return AnimatedBuilder(
                          animation: _controller,
                          builder: (context, snapshot) {
                            // shader.setFloat(2, _elapsedTimeInSeconds);
                            // return CustomPaint(
                            //   size: Size(MediaQuery.of(context).size.width,
                            //       MediaQuery.of(context).size.height),
                            //   painter: ShaderPainter(shader),
                            // );
                            shader.setFloat(2, _elapsedTimeInSeconds);
                            return Center(
                              child: ShaderMask(
                                shaderCallback: (rect) {
                                  shader.setFloat(0, rect.width);
                                  shader.setFloat(1, rect.height * 1.5);
                                  return shader;
                                },
                                blendMode: BlendMode.srcIn,
                                child: const Text(
                                  "BURN THEM",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 112,
                                  ),
                                ),
                              ),
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
  FragmentProgram program = await FragmentProgram.fromAsset('shaders/fire.frag');
  return program.fragmentShader();
}
