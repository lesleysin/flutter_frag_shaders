#version 460 core

#include <flutter/runtime_effect.glsl>

precision lowp float;

uniform vec2 uResolution;

uniform float uTime;

out vec4 fragColor;

float random(in vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898, 78.233))) *
                 43758.5453123);
}

float noise(in vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0 - 2.0 * f);

    return mix(a, b, u.x) +
    (c - a) * u.y * (1.0 - u.x) +
    (d - b) * u.x * u.y;
}

#define OCTAVES 6
float fbm(in vec2 st) {
    // Initial values
    float value = .0;
    float amplitude = .5;
    float frequency = .0;
    //
    // Loop of octaves
    for (int i = 0; i < OCTAVES; i++) {
        value += amplitude * noise(st);
        st *= 2.;
        amplitude *= .5;
    }
    return value;
}

void fire(out vec4 fragColor, in vec2 fragCoord) {
    const float speed = 100;
    const float details = .034;
    const float force = 1.2;
    const float shift = .1;
    const float scale = 2.7;
    //noise
    vec2 xyFast = vec2(fragCoord.x, fragCoord.y - uTime * speed) * details;
    float noise1 = fbm(xyFast);
    float noise2 = force * (fbm(xyFast + noise1 + uTime) - shift);
    float nnoise1 = force * fbm(vec2(noise2, noise1));
    float nnoise2 = fbm(vec2(noise2, noise1));

    //color
    const vec3 red = vec3(.9, .4, .2);
    const vec3 yellow = vec3(.9, .4, .0);
    const vec3 darkRed = vec3(.5, .0, .0);
    const vec3 dark = vec3(.1, .1, .1);

    vec3 c1 = mix(red, darkRed, nnoise1 + shift);
    vec3 c2 = mix(yellow, dark, nnoise2 - shift);

    //mask
    vec3 gradient = force * vec3(fragCoord.y / (uResolution.y / 2));
    vec3 col = c2 + c1 + gradient - shift;

    fragColor = vec4(col, 1.0);
}

void main() {
    vec2 currentPos = FlutterFragCoord().xy - uResolution.xy;
    fire(fragColor, currentPos);
}