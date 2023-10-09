import "dart:ui";

import "package:flutter/material.dart";

class Uniform {
  final List<int> range;

  Uniform({
    required this.range,
  });
}

class ShaderLoader {
  late final FragmentShader _shader;
  int _lastIndex = 0;
  final String _assetName;
  final Map<String, Uniform> _uniforms = {};

  ShaderLoader(this._assetName);

  FragmentShader get shader => _shader;

  Future<FragmentShader> _loadShader(String path) async {
    FragmentProgram program = await FragmentProgram.fromAsset(path);
    return program.fragmentShader();
  }

  void _setFloat(double value, List<int> range) {
    _shader.setFloat(_lastIndex, value);
    range.add(_lastIndex++);
  }

  Future<ShaderLoader> initShader() async {
    _shader = await _loadShader(_assetName);
    return this;
  }

  void setFloatUniform(String key, double x) {
    try {
      final hasUniform = _uniforms.containsKey(key);

      if (hasUniform) {
        final uniform = _uniforms[key];
        _shader.setFloat(uniform!.range[0], x);
      } else {
        _uniforms[key] = Uniform(range: [_lastIndex]);
        _shader.setFloat(_lastIndex, x);
        _lastIndex++;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setVec2Uniform(String key, double x, double y) {
    try {
      final hasUniform = _uniforms.containsKey(key);

      if (hasUniform) {
        final uniform = _uniforms[key];
        _shader.setFloat(uniform!.range[0], x);
        _shader.setFloat(uniform!.range[1], y);
      } else {
        final List<int> range = [];
        _setFloat(x, range);
        _setFloat(y, range);
        _uniforms[key] = Uniform(range: range);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setVec2UniformFromSize(String key, Size size) {
    try {
      final hasUniform = _uniforms.containsKey(key);

      if (hasUniform) {
        final uniform = _uniforms[key];
        _shader.setFloat(uniform!.range[0], size.width);
      } else {
        final List<int> range = [];
        _shader.setFloat(_lastIndex, size.width);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, size.height);
        range.add(_lastIndex++);
        _uniforms[key] = Uniform(range: range);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setVec3Uniform(String key, double x, double y, double z) {
    try {
      final hasUniform = _uniforms.containsKey(key);

      if (hasUniform) {
        final uniform = _uniforms[key];
        _shader.setFloat(uniform!.range[0], x);
        _shader.setFloat(uniform.range[1], y);
        _shader.setFloat(uniform.range[2], z);
      } else {
        final List<int> range = [];
        _shader.setFloat(_lastIndex, x);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, y);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, z);
        range.add(_lastIndex++);
        _uniforms[key] = Uniform(range: range);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setVec3UniformFromColor(String key, Color color) {
    try {
      final hasUniform = _uniforms.containsKey(key);

      final r = color.red / 255;
      final g = color.green / 255;
      final b = color.blue / 255;

      if (hasUniform) {
        final uniform = _uniforms[key];
        _shader.setFloat(uniform!.range[0], r);
        _shader.setFloat(uniform.range[1], g);
        _shader.setFloat(uniform.range[2], b);
      } else {
        final List<int> range = [];
        _shader.setFloat(_lastIndex, r);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, g);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, b);
        range.add(_lastIndex++);
        _uniforms[key] = Uniform(range: range);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setVec4Uniform(String key, double x, double y, double z, double a) {
    try {
      final hasUniform = _uniforms.containsKey(key);

      if (hasUniform) {
        final uniform = _uniforms[key];
        _shader.setFloat(uniform!.range[0], x);
        _shader.setFloat(uniform.range[1], y);
        _shader.setFloat(uniform.range[2], z);
        _shader.setFloat(uniform.range[4], a);
      } else {
        final List<int> range = [];
        _shader.setFloat(_lastIndex, x);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, y);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, z);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, a);
        range.add(_lastIndex++);
        _uniforms[key] = Uniform(range: range);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void setVec4UniformFromColor(String key, Color color) {
    try {
      final hasUniform = _uniforms.containsKey(key);

      final r = color.red / 255;
      final g = color.green / 255;
      final b = color.blue / 255;
      final a = color.alpha / 255;

      if (hasUniform) {
        final uniform = _uniforms[key];
        _shader.setFloat(uniform!.range[0], r);
        _shader.setFloat(uniform.range[1], g);
        _shader.setFloat(uniform.range[2], b);
        _shader.setFloat(uniform.range[4], a);
      } else {
        final List<int> range = [];
        _shader.setFloat(_lastIndex, r);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, g);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, b);
        range.add(_lastIndex++);
        _shader.setFloat(_lastIndex, a);
        range.add(_lastIndex++);
        _uniforms[key] = Uniform(range: range);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
