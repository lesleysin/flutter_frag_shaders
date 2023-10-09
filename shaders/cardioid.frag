#version 460 core

#include <flutter/runtime_effect.glsl>

precision mediump float;

uniform vec2 uResolution;
uniform vec3 uColor;

uniform float uTime;

out vec4 fragColor;

vec2 rotate2D(vec2 uv, float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c) * uv;
}

void main() {
    vec2 uv = -(2.0 * FlutterFragCoord().xy - uResolution.xy) / uResolution.y;
    vec3 col = vec3(0.0);

    uv = rotate2D(uv, 3.14 / 2.0);

    float r = 0.17;
    for (float i=0.0; i < 60.0; i++) {
        float factor = (sin(uTime) * 0.5 + 0.5) + 0.5;
        i += factor;

        float a = i / 3;
        float dx = 2 * r * cos(a) - r * cos(2. * a);
        float dy = 2 * r * sin(a) - r * sin(2. * a);

        col += 0.013 * factor / length(uv - vec2(dx + 0.1, dy));
    }
    col *= sin(uColor * uTime) * 0.15 + 0.2;

    fragColor = vec4(col, 1.0);
}