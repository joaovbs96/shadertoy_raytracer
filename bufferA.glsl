// ===================== Ray =====================
struct Ray {
  vec3 origin;
  vec3 direction;
};

// p = o + t * d
vec3 pointAt(Ray r, float t) { return r.origin + t * r.direction; }

// ===================== Camera =====================
struct Camera {
  vec3 origin;
  vec3 hor, vert;
  vec3 llc;
  vec3 u, v, w;
  float lens_radius;
};

// Creates new Camera
Camera newCamera(vec3 lookfrom, vec3 lookat, vec3 vup, float vfov, float aRatio,
                 float aperture, float focus_dist) {
  float theta = radians(vfov);
  float vpH = 2.0f * tan(theta / 2.0f);
  float vpW = aRatio * vpH;

  vec3 w = normalize(lookfrom - lookat);
  vec3 u = normalize(cross(vup, w));
  vec3 v = cross(w, u);

  vec3 o = lookfrom;
  vec3 hh = focus_dist * vpW * u;
  vec3 vv = focus_dist * vpH * v;
  vec3 llc = o - hh / 2.0f - vv / 2.0f - focus_dist * w;
  return Camera(o, hh, vv, llc, u, v, w, aperture / 2.0f);
}

// Generates a new ray leaving from the camera
Ray getRay(Camera c, float s, float t) {
  vec3 rd = c.lens_radius * randomInUnitDisk();
  vec3 offset = c.u * rd.x + c.v * rd.y;
  return Ray(c.origin + offset,
             c.llc + s * c.hor + t * c.vert - c.origin - offset);
}

// ===================== Hit Record =====================

struct HitRecord {
  vec3 p;
  vec3 n;
  bool front_face;
  float t;
  int index;
};

// TODO: add brdfIdx to the geometry, allowing us to reuse BRDFs accross several
// geometries

// ===================== Sphere =====================

struct Sphere {
  vec3 center;
  float r;
};

bool hitSphere(Sphere s, Ray r, float t_min, float t_max, out HitRecord rec) {
  vec3 oc = r.origin - s.center;
  float a = squaredLength(r.direction);
  float hb = dot(oc, r.direction);
  float c = squaredLength(oc) - s.r * s.r;
  float d = hb * hb - a * c;

  // if the descriminant is > 0, we might have a hit
  if (d > 0.0f) {
    float root = sqrt(d);

    float t = (-hb - root) / a;
    if (t < t_max && t > t_min) {
      vec3 p = pointAt(r, t);
      vec3 n = (p - s.center) / s.r;
      rec = HitRecord(p, faceforward(n, r.direction, n),
                      dot(r.direction, n) < 0.0f, t, 0);
      return true;
    }

    t = (-hb + root) / a;
    if (t < t_max && t > t_min) {
      vec3 p = pointAt(r, t);
      vec3 n = (p - s.center) / s.r;
      rec = HitRecord(p, faceforward(n, r.direction, n),
                      dot(r.direction, n) < 0.0f, t, 0);
      return true;
    }

    // if neither of the t's is in the (t_min, t_max) range, it's not a hit
  }

  // else, not a hit
  return false;
}

// List of Geometries - must have one BRDF per geometry
Sphere spheres[148] = Sphere[](Sphere(vec3(0.0f, -1000.0f, 0.0f), 1000.0f),
                               Sphere(vec3(-16.32f, 0.2f, -16.2f), 0.2f),
                               Sphere(vec3(-16.93f, 0.2f, -14.8f), 0.2f),
                               Sphere(vec3(-16.19f, 0.2f, -12.17f), 0.2f),
                               Sphere(vec3(-16.43f, 0.2f, -10.84f), 0.2f),
                               Sphere(vec3(-16.72f, 0.2f, -8.63f), 0.2f),
                               Sphere(vec3(-16.67f, 0.2f, -6.33f), 0.2f),
                               Sphere(vec3(-16.81f, 0.2f, -4.89f), 0.2f),
                               Sphere(vec3(-16.23f, 0.2f, -2.25f), 0.2f),
                               Sphere(vec3(-16.16f, 0.2f, -0.3f), 0.2f),
                               Sphere(vec3(-16.15f, 0.2f, 1.3f), 0.2f),
                               Sphere(vec3(-16.92f, 0.2f, 3.47f), 0.2f),
                               Sphere(vec3(-16.22f, 0.2f, 5.57f), 0.2f),
                               Sphere(vec3(-14.5f, 0.2f, -16.55f), 0.2f),
                               Sphere(vec3(-14.84f, 0.2f, -14.86f), 0.2f),
                               Sphere(vec3(-14.86f, 0.2f, -12.63f), 0.2f),
                               Sphere(vec3(-14.77f, 0.2f, -10.79f), 0.2f),
                               Sphere(vec3(-14.11f, 0.2f, -8.96f), 0.2f),
                               Sphere(vec3(-14.36f, 0.2f, -6.92f), 0.2f),
                               Sphere(vec3(-14.28f, 0.2f, -4.61f), 0.2f),
                               Sphere(vec3(-14.21f, 0.2f, -2.19f), 0.2f),
                               Sphere(vec3(-14.85f, 0.2f, -0.49f), 0.2f),
                               Sphere(vec3(-14.33f, 0.2f, 1.82f), 0.2f),
                               Sphere(vec3(-14.84f, 0.2f, 3.28f), 0.2f),
                               Sphere(vec3(-14.79f, 0.2f, 5.62f), 0.2f),
                               Sphere(vec3(-12.7f, 0.2f, -16.97f), 0.2f),
                               Sphere(vec3(-12.97f, 0.2f, -14.72f), 0.2f),
                               Sphere(vec3(-12.1f, 0.2f, -12.76f), 0.2f),
                               Sphere(vec3(-12.85f, 0.2f, -10.97f), 0.2f),
                               Sphere(vec3(-12.36f, 0.2f, -8.51f), 0.2f),
                               Sphere(vec3(-12.61f, 0.2f, -6.9f), 0.2f),
                               Sphere(vec3(-12.81f, 0.2f, -4.4f), 0.2f),
                               Sphere(vec3(-12.36f, 0.2f, -2.22f), 0.2f),
                               Sphere(vec3(-12.37f, 0.2f, -0.63f), 0.2f),
                               Sphere(vec3(-12.69f, 0.2f, 1.11f), 0.2f),
                               Sphere(vec3(-12.17f, 0.2f, 3.8f), 0.2f),
                               Sphere(vec3(-12.13f, 0.2f, 5.58f), 0.2f),
                               Sphere(vec3(-10.81f, 0.2f, -16.69f), 0.2f),
                               Sphere(vec3(-10.51f, 0.2f, -14.18f), 0.2f),
                               Sphere(vec3(-10.73f, 0.2f, -12.68f), 0.2f),
                               Sphere(vec3(-10.29f, 0.2f, -10.26f), 0.2f),
                               Sphere(vec3(-10.72f, 0.2f, -8.65f), 0.2f),
                               Sphere(vec3(-10.14f, 0.2f, -6.72f), 0.2f),
                               Sphere(vec3(-10.38f, 0.2f, -4.77f), 0.2f),
                               Sphere(vec3(-10.32f, 0.2f, -2.55f), 0.2f),
                               Sphere(vec3(-10.97f, 0.2f, -0.27f), 0.2f),
                               Sphere(vec3(-10.44f, 0.2f, 1.34f), 0.2f),
                               Sphere(vec3(-10.81f, 0.2f, 3.26f), 0.2f),
                               Sphere(vec3(-10.25f, 0.2f, 5.69f), 0.2f),
                               Sphere(vec3(-8.45f, 0.2f, -16.27f), 0.2f),
                               Sphere(vec3(-8.19f, 0.2f, -14.33f), 0.2f),
                               Sphere(vec3(-8.11f, 0.2f, -12.69f), 0.2f),
                               Sphere(vec3(-8.6f, 0.2f, -10.5f), 0.2f),
                               Sphere(vec3(-8.89f, 0.2f, -8.72f), 0.2f),
                               Sphere(vec3(-8.74f, 0.2f, -6.89f), 0.2f),
                               Sphere(vec3(-8.64f, 0.2f, -4.46f), 0.2f),
                               Sphere(vec3(-8.22f, 0.2f, -2.4f), 0.2f),
                               Sphere(vec3(-8.65f, 0.2f, -0.12f), 0.2f),
                               Sphere(vec3(-8.51f, 0.2f, 1.35f), 0.2f),
                               Sphere(vec3(-8.65f, 0.2f, 3.6f), 0.2f),
                               Sphere(vec3(-8.12f, 0.2f, 5.31f), 0.2f),
                               Sphere(vec3(-6.44f, 0.2f, -16.18f), 0.2f),
                               Sphere(vec3(-6.44f, 0.2f, -14.48f), 0.2f),
                               Sphere(vec3(-6.89f, 0.2f, -12.51f), 0.2f),
                               Sphere(vec3(-6.47f, 0.2f, -10.12f), 0.2f),
                               Sphere(vec3(-6.12f, 0.2f, -8.35f), 0.2f),
                               Sphere(vec3(-6.56f, 0.2f, -6.62f), 0.2f),
                               Sphere(vec3(-6.49f, 0.2f, -4.67f), 0.2f),
                               Sphere(vec3(-6.28f, 0.2f, -2.25f), 0.2f),
                               Sphere(vec3(-6.57f, 0.2f, -0.27f), 0.2f),
                               Sphere(vec3(-6.55f, 0.2f, 1.11f), 0.2f),
                               Sphere(vec3(-6.19f, 0.2f, 3.62f), 0.2f),
                               Sphere(vec3(-6.88f, 0.2f, 5.48f), 0.2f),
                               Sphere(vec3(-4.99f, 0.2f, -16.8f), 0.2f),
                               Sphere(vec3(-4.28f, 0.2f, -14.23f), 0.2f),
                               Sphere(vec3(-4.91f, 0.2f, -12.98f), 0.2f),
                               Sphere(vec3(-4.8f, 0.2f, -10.87f), 0.2f),
                               Sphere(vec3(-4.22f, 0.2f, -8.99f), 0.2f),
                               Sphere(vec3(-4.66f, 0.2f, -6.84f), 0.2f),
                               Sphere(vec3(-4.93f, 0.2f, -4.96f), 0.2f),
                               Sphere(vec3(-4.63f, 0.2f, -2.57f), 0.2f),
                               Sphere(vec3(-4.39f, 0.2f, -0.97f), 0.2f),
                               Sphere(vec3(-4.83f, 0.2f, 1.6f), 0.2f),
                               Sphere(vec3(-4.99f, 0.2f, 3.42f), 0.2f),
                               Sphere(vec3(-4.21f, 0.2f, 5.42f), 0.2f),
                               Sphere(vec3(-2.28f, 0.2f, -16.8f), 0.2f),
                               Sphere(vec3(-2.95f, 0.2f, -14.18f), 0.2f),
                               Sphere(vec3(-2.49f, 0.2f, -12.86f), 0.2f),
                               Sphere(vec3(-2.2f, 0.2f, -10.78f), 0.2f),
                               Sphere(vec3(-2.35f, 0.2f, -8.14f), 0.2f),
                               Sphere(vec3(-2.17f, 0.2f, -6.33f), 0.2f),
                               Sphere(vec3(-2.18f, 0.2f, -4.96f), 0.2f),
                               Sphere(vec3(-2.81f, 0.2f, -2.72f), 0.2f),
                               Sphere(vec3(-2.29f, 0.2f, -0.47f), 0.2f),
                               Sphere(vec3(-2.19f, 0.2f, 1.72f), 0.2f),
                               Sphere(vec3(-2.16f, 0.2f, 3.08f), 0.2f),
                               Sphere(vec3(-2.13f, 0.2f, 5.57f), 0.2f),
                               Sphere(vec3(-0.93f, 0.2f, -16.37f), 0.2f),
                               Sphere(vec3(-0.2f, 0.2f, -14.6f), 0.2f),
                               Sphere(vec3(-0.16f, 0.2f, -12.83f), 0.2f),
                               Sphere(vec3(-0.12f, 0.2f, -10.63f), 0.2f),
                               Sphere(vec3(-0.19f, 0.2f, -8.48f), 0.2f),
                               Sphere(vec3(-0.12f, 0.2f, -6.29f), 0.2f),
                               Sphere(vec3(-0.38f, 0.2f, -4.51f), 0.2f),
                               Sphere(vec3(-0.63f, 0.2f, -2.32f), 0.2f),
                               Sphere(vec3(-0.43f, 0.2f, -0.22f), 0.2f),
                               Sphere(vec3(-0.13f, 0.2f, 1.65f), 0.2f),
                               Sphere(vec3(-0.81f, 0.2f, 3.17f), 0.2f),
                               Sphere(vec3(-0.98f, 0.2f, 5.45f), 0.2f),
                               Sphere(vec3(1.59f, 0.2f, -16.7f), 0.2f),
                               Sphere(vec3(1.56f, 0.2f, -14.79f), 0.2f),
                               Sphere(vec3(1.55f, 0.2f, -12.72f), 0.2f),
                               Sphere(vec3(1.65f, 0.2f, -10.3f), 0.2f),
                               Sphere(vec3(1.56f, 0.2f, -8.77f), 0.2f),
                               Sphere(vec3(1.45f, 0.2f, -6.86f), 0.2f),
                               Sphere(vec3(1.8f, 0.2f, -4.45f), 0.2f),
                               Sphere(vec3(1.6f, 0.2f, -2.87f), 0.2f),
                               Sphere(vec3(1.73f, 0.2f, -0.62f), 0.2f),
                               Sphere(vec3(1.53f, 0.2f, 1.46f), 0.2f),
                               Sphere(vec3(1.11f, 0.2f, 3.41f), 0.2f),
                               Sphere(vec3(1.02f, 0.2f, 5.43f), 0.2f),
                               Sphere(vec3(3.5f, 0.2f, -16.62f), 0.2f),
                               Sphere(vec3(3.2f, 0.2f, -14.96f), 0.2f),
                               Sphere(vec3(3.12f, 0.2f, -12.36f), 0.2f),
                               Sphere(vec3(3.74f, 0.2f, -10.69f), 0.2f),
                               Sphere(vec3(3.34f, 0.2f, -8.54f), 0.2f),
                               Sphere(vec3(3.66f, 0.2f, -6.5f), 0.2f),
                               Sphere(vec3(3.88f, 0.2f, -4.34f), 0.2f),
                               Sphere(vec3(3.55f, 0.2f, -2.33f), 0.2f),
                               Sphere(vec3(3.37f, 0.2f, -0.69f), 0.2f),
                               Sphere(vec3(3.85f, 0.2f, 1.23f), 0.2f),
                               Sphere(vec3(3.08f, 0.2f, 3.22f), 0.2f),
                               Sphere(vec3(3.22f, 0.2f, 5.45f), 0.2f),
                               Sphere(vec3(5.02f, 0.2f, -16.42f), 0.2f),
                               Sphere(vec3(5.53f, 0.2f, -14.65f), 0.2f),
                               Sphere(vec3(5.19f, 0.2f, -12.15f), 0.2f),
                               Sphere(vec3(5.27f, 0.2f, -10.96f), 0.2f),
                               Sphere(vec3(5.43f, 0.2f, -8.32f), 0.2f),
                               Sphere(vec3(5.5f, 0.2f, -6.92f), 0.2f),
                               Sphere(vec3(5.88f, 0.2f, -4.37f), 0.2f),
                               Sphere(vec3(5.61f, 0.2f, -2.77f), 0.2f),
                               Sphere(vec3(5.13f, 0.2f, -0.34f), 0.2f),
                               Sphere(vec3(5.79f, 0.2f, 1.71f), 0.2f),
                               Sphere(vec3(5.53f, 0.2f, 3.34f), 0.2f),
                               Sphere(vec3(5.19f, 0.2f, 5.52f), 0.2f),
                               Sphere(vec3(-4.0f, 1.0f, 0.0f), 1.0f),
                               Sphere(vec3(4.0f, 1.0f, 0.0f), 1.0f),
                               Sphere(vec3(0.0f, 1.0f, 0.0f), 1.0f));

// ===================== BRDFs =====================
struct BRDF {
  // Common params
  int type;  // 0 - Lambertian, 1 - Metal, 2 - Dielectric
  vec3 color;

  // Metal Params
  float fuzz;

  // dielectric
  float ior;
};

// List of BRDFs - must have one BRDF per geometry
BRDF brdfs[148] =
    BRDF[](BRDF(0, vec3(0.5f), 0.0f, 0.0f),
           BRDF(0, vec3(0.14f, 0.46f, 0.02f), 0.0f, 0.0f),
           BRDF(1, vec3(0.88f, 0.57f, 0.73f), 0.5f, 0.0f),
           BRDF(1, vec3(0.51f, 0.83f, 0.75f), 0.5f, 0.0f),
           BRDF(1, vec3(0.73f, 0.86f, 0.69f), 0.5f, 0.0f),
           BRDF(0, vec3(0.43f, 0.22f, 0.01f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(1, vec3(0.88f, 0.88f, 0.66f), 0.5f, 0.0f),
           BRDF(1, vec3(0.69f, 0.78f, 0.52f), 0.5f, 0.0f),
           BRDF(0, vec3(0.37f, 0.09f, 0.27f), 0.0f, 0.0f),
           BRDF(0, vec3(0.02f, 0.03f, 0.06f), 0.0f, 0.0f),
           BRDF(0, vec3(0.05f, 0.57f, 0.29f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.22f, 0.11f, 0.61f), 0.0f, 0.0f),
           BRDF(0, vec3(0.0f, 0.12f, 0.26f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.03f, 0.33f, 0.06f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.05f, 0.45f, 0.3f), 0.0f, 0.0f),
           BRDF(0, vec3(0.42f, 0.19f, 0.45f), 0.0f, 0.0f),
           BRDF(0, vec3(0.14f, 0.19f, 0.07f), 0.0f, 0.0f),
           BRDF(0, vec3(0.38f, 0.06f, 0.03f), 0.0f, 0.0f),
           BRDF(1, vec3(0.69f, 0.76f, 0.57f), 0.5f, 0.0f),
           BRDF(0, vec3(0.47f, 0.33f, 0.14f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.68f, 0.26f, 0.01f), 0.0f, 0.0f),
           BRDF(1, vec3(0.57f, 0.67f, 0.58f), 0.5f, 0.0f),
           BRDF(0, vec3(0.04f, 0.62f, 0.14f), 0.0f, 0.0f),
           BRDF(1, vec3(0.64f, 0.81f, 0.75f), 0.5f, 0.0f),
           BRDF(0, vec3(0.44f, 0.12f, 0.32f), 0.0f, 0.0f),
           BRDF(0, vec3(0.3f, 0.21f, 0.47f), 0.0f, 0.0f),
           BRDF(1, vec3(0.82f, 0.61f, 0.69f), 0.5f, 0.0f),
           BRDF(1, vec3(0.69f, 0.73f, 0.84f), 0.5f, 0.0f),
           BRDF(0, vec3(0.14f, 0.55f, 0.48f), 0.0f, 0.0f),
           BRDF(0, vec3(0.78f, 0.87f, 0.47f), 0.0f, 0.0f),
           BRDF(0, vec3(0.31f, 0.05f, 0.75f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.17f, 0.41f, 0.44f), 0.0f, 0.0f),
           BRDF(0, vec3(0.38f, 0.41f, 0.12f), 0.0f, 0.0f),
           BRDF(0, vec3(0.66f, 0.16f, 0.23f), 0.0f, 0.0f),
           BRDF(0, vec3(0.31f, 0.23f, 0.03f), 0.0f, 0.0f),
           BRDF(0, vec3(0.66f, 0.0f, 0.14f), 0.0f, 0.0f),
           BRDF(1, vec3(0.94f, 0.91f, 0.55f), 0.5f, 0.0f),
           BRDF(0, vec3(0.27f, 0.03f, 0.04f), 0.0f, 0.0f),
           BRDF(0, vec3(0.05f, 0.44f, 0.16f), 0.0f, 0.0f),
           BRDF(0, vec3(0.05f, 0.77f, 0.13f), 0.0f, 0.0f),
           BRDF(1, vec3(0.53f, 0.51f, 0.8f), 0.5f, 0.0f),
           BRDF(0, vec3(0.64f, 0.13f, 0.59f), 0.0f, 0.0f),
           BRDF(0, vec3(0.03f, 0.0f, 0.13f), 0.0f, 0.0f),
           BRDF(1, vec3(0.78f, 0.59f, 0.59f), 0.5f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.04f, 0.91f, 0.02f), 0.0f, 0.0f),
           BRDF(0, vec3(0.08f, 0.62f, 0.16f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.12f, 0.03f, 0.22f), 0.0f, 0.0f),
           BRDF(0, vec3(0.04f, 0.36f, 0.73f), 0.0f, 0.0f),
           BRDF(0, vec3(0.18f, 0.68f, 0.08f), 0.0f, 0.0f),
           BRDF(1, vec3(0.67f, 0.86f, 0.88f), 0.5f, 0.0f),
           BRDF(0, vec3(0.05f, 0.18f, 0.19f), 0.0f, 0.0f),
           BRDF(1, vec3(0.84f, 0.78f, 0.61f), 0.5f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.1f, 0.0f, 0.08f), 0.0f, 0.0f),
           BRDF(1, vec3(0.56f, 0.81f, 0.69f), 0.5f, 0.0f),
           BRDF(0, vec3(0.32f, 0.25f, 0.01f), 0.0f, 0.0f),
           BRDF(0, vec3(0.09f, 0.14f, 0.47f), 0.0f, 0.0f),
           BRDF(0, vec3(0.57f, 0.46f, 0.01f), 0.0f, 0.0f),
           BRDF(0, vec3(0.09f, 0.14f, 0.69f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.12f, 0.32f, 0.37f), 0.0f, 0.0f),
           BRDF(0, vec3(0.67f, 0.66f, 0.03f), 0.0f, 0.0f),
           BRDF(0, vec3(0.12f, 0.74f, 0.07f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f), BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.35f, 0.35f, 0.32f), 0.0f, 0.0f),
           BRDF(0, vec3(0.53f, 0.04f, 0.27f), 0.0f, 0.0f),
           BRDF(0, vec3(0.01f, 0.55f, 0.26f), 0.0f, 0.0f),
           BRDF(0, vec3(0.45f, 0.07f, 0.24f), 0.0f, 0.0f),
           BRDF(0, vec3(0.01f, 0.02f, 0.08f), 0.0f, 0.0f),
           BRDF(0, vec3(0.03f, 0.06f, 0.16f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.24f, 0.07f, 0.61f), 0.0f, 0.0f),
           BRDF(0, vec3(0.14f, 0.2f, 0.16f), 0.0f, 0.0f),
           BRDF(0, vec3(0.03f, 0.55f, 0.03f), 0.0f, 0.0f),
           BRDF(0, vec3(0.17f, 0.12f, 0.15f), 0.0f, 0.0f),
           BRDF(0, vec3(0.09f, 0.21f, 0.0f), 0.0f, 0.0f),
           BRDF(0, vec3(0.1f, 0.02f, 0.1f), 0.0f, 0.0f),
           BRDF(0, vec3(0.04f, 0.02f, 0.18f), 0.0f, 0.0f),
           BRDF(1, vec3(0.84f, 0.67f, 0.96f), 0.5f, 0.0f),
           BRDF(0, vec3(0.31f, 0.12f, 0.45f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.15f, 0.45f, 0.07f), 0.0f, 0.0f),
           BRDF(1, vec3(0.63f, 0.62f, 0.93f), 0.5f, 0.0f),
           BRDF(0, vec3(0.06f, 0.18f, 0.0f), 0.0f, 0.0f),
           BRDF(1, vec3(0.94f, 0.5f, 0.56f), 0.5f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.27f, 0.12f, 0.09f), 0.0f, 0.0f),
           BRDF(0, vec3(0.25f, 0.08f, 0.28f), 0.0f, 0.0f),
           BRDF(1, vec3(0.63f, 0.76f, 0.97f), 0.5f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.21f, 0.0f, 0.09f), 0.0f, 0.0f),
           BRDF(0, vec3(0.26f, 0.43f, 0.03f), 0.0f, 0.0f),
           BRDF(0, vec3(0.44f, 0.73f, 0.4f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(1, vec3(0.82f, 0.8f, 0.94f), 0.5f, 0.0f),
           BRDF(0, vec3(0.17f, 0.04f, 0.6f), 0.0f, 0.0f),
           BRDF(0, vec3(0.51f, 0.44f, 0.07f), 0.0f, 0.0f),
           BRDF(0, vec3(0.37f, 0.17f, 0.11f), 0.0f, 0.0f),
           BRDF(1, vec3(0.91f, 0.83f, 0.56f), 0.5f, 0.0f),
           BRDF(0, vec3(0.07f, 0.44f, 0.16f), 0.0f, 0.0f),
           BRDF(0, vec3(0.58f, 0.01f, 0.04f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.27f, 0.01f, 0.01f), 0.0f, 0.0f),
           BRDF(0, vec3(0.59f, 0.24f, 0.17f), 0.0f, 0.0f),
           BRDF(0, vec3(0.1f, 0.03f, 0.3f), 0.0f, 0.0f),
           BRDF(0, vec3(0.02f, 0.66f, 0.28f), 0.0f, 0.0f),
           BRDF(1, vec3(0.83f, 0.78f, 0.73f), 0.5f, 0.0f),
           BRDF(0, vec3(0.76f, 0.14f, 0.31f), 0.0f, 0.0f),
           BRDF(0, vec3(0.09f, 0.15f, 0.19f), 0.0f, 0.0f),
           BRDF(1, vec3(0.71f, 0.58f, 0.81f), 0.5f, 0.0f),
           BRDF(1, vec3(0.91f, 0.99f, 0.83f), 0.5f, 0.0f),
           BRDF(0, vec3(0.53f, 0.47f, 0.25f), 0.0f, 0.0f),
           BRDF(0, vec3(0.27f, 0.09f, 0.53f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.15f, 0.14f, 0.26f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.32f, 0.05f, 0.18f), 0.0f, 0.0f),
           BRDF(0, vec3(0.61f, 0.4f, 0.42f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(1, vec3(0.59f, 0.98f, 0.89f), 0.5f, 0.0f),
           BRDF(0, vec3(0.09f, 0.45f, 0.33f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f), BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.13f, 0.87f, 0.33f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.64f, 0.31f, 0.38f), 0.0f, 0.0f),
           BRDF(0, vec3(0.34f, 0.04f, 0.63f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.66f, 0.01f, 0.07f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(1, vec3(0.99f, 0.62f, 0.87f), 0.5f, 0.0f),
           BRDF(0, vec3(0.13f, 0.02f, 0.73f), 0.0f, 0.0f),
           BRDF(0, vec3(0.35f, 0.06f, 0.3f), 0.0f, 0.0f),
           BRDF(0, vec3(0.37f, 0.69f, 0.02f), 0.0f, 0.0f),
           BRDF(0, vec3(0.38f, 0.11f, 0.16f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f),
           BRDF(0, vec3(0.4f, 0.2f, 0.1f), 0.0f, 0.0f),
           BRDF(1, vec3(0.7f, 0.6f, 0.5f), 0.0f, 0.0f),
           BRDF(2, vec3(1.0f), 0.0f, 1.5f));

float schlick(float cosine, float ref_idx) {
  float r0 = (1.0f - ref_idx) / (1.0f + ref_idx);
  r0 = r0 * r0;
  return r0 + (1.0f - r0) * pow((1.0f - cosine), 5.0f);
}

// Samples BRDF
vec3 sampleBRDF(Ray r, HitRecord rec) {
  switch (brdfs[rec.index].type) {
    case 0:  // Lambertian
      return rec.n + randomUnitVector();
      break;

    case 1:  // Metal
      return reflect(normalize(r.direction), normalize(rec.n)) +
             brdfs[rec.index].fuzz * randomInUnitSphere();
      break;

    case 2:  // Dielectric
      float ior = brdfs[rec.index].ior;
      float etai_over_etat = rec.front_face ? (1.0f / ior) : ior;

      vec3 dir = normalize(r.direction);
      vec3 nn = normalize(rec.n);

      float cos_theta = min(dot(-dir, nn), 1.0f);
      float sin_theta = sqrt(1.0f - cos_theta * cos_theta);
      if (etai_over_etat * sin_theta > 1.0f) {
        return normalize(reflect(dir, nn));
      }

      return normalize(refract(dir, nn, etai_over_etat));

      break;
  }
}

// Evaluates BRDF
vec3 evalBRDF(Ray r, HitRecord rec) {
  switch (brdfs[rec.index].type) {
    case 0:  // Lambertian
      return brdfs[rec.index].color;
      break;

    case 1:  // Metal
      return brdfs[rec.index].color;
      break;

    case 2:  // Dielectric
      return brdfs[rec.index].color;
      break;
  }
}

// ===================== Main =====================

// Iterates over a list of geometries and tries to find a hit
bool hitWorld(Ray r, float t_min, float t_max, out HitRecord rec) {
  HitRecord temp;
  bool hitAnything = false;
  float closest = t_max;

  for (int i = 0; i < spheres.length(); i++) {
    if (hitSphere(spheres[i], r, t_min, t_max, temp)) {
      if (temp.t < closest) {
        hitAnything = true;
        closest = temp.t;
        rec = temp;
        rec.index = i;
      }
    }
  }

  return hitAnything;
}

// Traces ray
vec3 trace(Ray r) {
  vec3 throughput = vec3(1.0f);

  // iterative version of recursion
  for (int i = 0; i < 50; i++) {
    HitRecord rec;

    // ray hit
    if (hitWorld(r, 0.001f, FLT_MAX, rec)) {
      vec3 wi = sampleBRDF(r, rec);
      throughput *= evalBRDF(r, rec);

      r = Ray(rec.p, wi);
    }

    // ray miss
    else {
      vec3 uDirection = normalize(r.direction);
      float t = 0.5f * (uDirection.y + 1.0f);
      vec3 color = (1.0f - t) * vec3(1.0f) + t * vec3(0.5f, 0.7f, 1.0f);
      return throughput * color;
    }
  }

  return vec3(0.0f);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
  // rnd seed
  seed = tea(int(iResolution.x) * int(fragCoord.y) + int(fragCoord.x), iFrame);

  // camera
  float aRatio = iResolution.x / iResolution.y;
  vec3 lookfrom = vec3(13.0f, 2.0f, 3.0f);
  vec3 lookat = vec3(0.0f, 0.0f, 0.0f);
  vec3 vup = vec3(0.0f, 1.0f, 0.0f);
  Camera c = newCamera(lookfrom, lookat, vup, 20.0f, aRatio, 0.1f, 10.0f);

  // shoot a ray
  float u = (fragCoord.x + rnd()) / iResolution.x;
  float v = (fragCoord.y + rnd()) / iResolution.y;
  Ray r = getRay(c, u, v);

  // Accumulate and output to screen
  vec2 uv = fragCoord.xy / iResolution.xy;
  vec4 oldColor = texture(iChannel0, uv);

  // initiates buffer if we are on frame 0
  if (iFrame == 0) oldColor = vec4(0.0f);

  // TODO: Fix. The reset on keypress works, but we need to save the current
  // frame somewhere so we can do accum /(currentFrame - savedFrame).
  // if(KeyPressed(82)) oldColor = vec4(0.0f); // Press R to reset

  fragColor = oldColor + vec4(de_nan(trace(r)), 0.0f);
}