// ===================== Math Defines =====================
#define PI 3.14159265359
#define TWOPI 6.28318530718

#define FLT_MAX 3.402823466e+38
#define FLT_MIN 1.175494351e-38

#define squaredLength(x) pow(length(x), 2.0f)

// ===================== Random Generator =====================
// RNG adapted from the random generator used by NVidia in their OptiX's samples.
// The following licence only applies to the functions tea, rnd and lcg.

//////////////////////////////////////////////////////////////////////////////////////
// ******************************************************************************** //
/*
 * Copyright (c) 2018, NVIDIA CORPORATION. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *  * Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  * Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *  * Neither the name of NVIDIA CORPORATION nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


int seed;

int tea(int val0, int val1) {
  int v0 = val0;
  int v1 = val1;
  int s0 = 0;

  for (int n = 0; n < 16; n++) {
    s0 += 0x9e3779b9;
    v0 += ((v1 << 4) + 0xa341316c) ^ (v1 + s0) ^ ((v1 >> 5) + 0xc8013ea4);
    v1 += ((v0 << 4) + 0xad90777d) ^ (v0 + s0) ^ ((v0 >> 5) + 0x7e95761e);
  }

  return v0;
}

int lcg() {
  int LCG_A = 1664525;
  int LCG_C = 1013904223;
  seed = (LCG_A * seed + LCG_C);
  return seed & 0x00FFFFFF;
}

float rnd() {
  return (float(lcg()) / float(0x01000000));
}


// ******************************************************************************** //
//////////////////////////////////////////////////////////////////////////////////////

// ===================== Sampling =====================

vec3 randomInUnitSphere() {
  	float z = rnd() * 2.f - 1.f;

  	float t = rnd() * 2.f * PI;
  	float r = sqrt((0.f > (1.f - z * z) ? 0.f : (1.f - z * z)));

  	float x = r * cos(t);
  	float y = r * sin(t);

  	vec3 res = vec3(x, y, z);
  	res *= pow(rnd(), 1.f / 3.f);

  	return res;
}

vec3 randomUnitVector() {
    float a = rnd() * TWOPI;
    float z = (rnd() * 2.0f) - 1.0f;
    float r = sqrt(1.0f - z * z);
    
    return vec3(r * cos(a), r * sin(a), z);
}

vec3 randomInUnitDisk() {
	float a = rnd() * TWOPI;
	vec3 xy = vec3(sin(a), cos(a), 0.0f);
	xy *= sqrt(rnd());
	return xy;
}

// ===================== Removing NaNs =====================

// Source: https://stackoverflow.com/a/34276047
bool isNan(float val) {
  return (val < 0.0 || 0.0 < val || val == 0.0) ? false : true;

}

vec3 de_nan(vec3 c) {
  vec3 temp = c;
  if (isNan(temp.x)) temp.x = 0.0f;
  if (isNan(temp.y)) temp.y = 0.0f;
  if (isNan(temp.z)) temp.z = 0.0f;
  return temp;
}

// ===================== Keyboard Input =====================
#define keyChannel iChannel1
#define KeyPressed(key) _keyPressed(keyChannel, key)

// Return true if given key is pressed
// Source: https://www.shadertoy.com/view/XsycWw
bool _keyPressed(sampler2D keyChannel, int key) {
  return texelFetch(keyChannel, ivec2(key,0), 0).x > 0.0;
}