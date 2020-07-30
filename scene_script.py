from random import random as rnd
import numpy as np

brdf = []
geom = []

# ground sphere
brdf.append("BRDF(0, vec3(0.5f), 0.0f, 0.0f)")
geom.append("Sphere(vec3(0.0f, -1000.0f, 0.0f), 1000.0f)")

# generate geometries
for a in range(-12, 12, 2):
    for b in range(-12, 12, 2):
        center = np.array([a - 5 + 0.9*rnd(), 0.2, b - 5 + 0.9 * rnd()])
        
        if (np.linalg.norm(center - np.array([4, 0.2, 0])) > 0.9):
          geom.append("Sphere(vec3(" + str(round(center[0], 2)) + "f," + str(round(center[1], 2)) + "f," + str(round(center[2], 2)) + "f), 0.2f)")

          mat = rnd()

          if mat < 0.6:
              # lambertian spheres
              brdf.append("BRDF(0, vec3("+str(round(rnd() * rnd(), 2))+"f, "+str(
                  round(rnd() * rnd(), 2))+"f, "+str(round(rnd() * rnd(), 2))+"f), 0.0f, 0.0f)")
          elif mat < 0.8:
              # metal spheres
              brdf.append("BRDF(1, vec3("+str(round(0.5 * (1 + rnd()), 2))+"f, "+str(round(
                  0.5 * (1 + rnd()), 2))+"f, "+str(round(0.5 * (1 + rnd()), 2))+"f), 0.5f, 0.0f)")
          else:
              # glass spheres
              brdf.append("BRDF(2, vec3(1.0f), 0.0f, 1.5f)")

# big lambertian sphere
brdf.append("BRDF(0, vec3(0.4f, 0.2f, 0.1f), 0.0f, 0.0f)")
geom.append("Sphere(vec3(-4.0f, 1.0f, 0.0f), 1.0f)")
# big metal sphere
brdf.append("BRDF(1, vec3(0.7f, 0.6f, 0.5f), 0.0f, 0.0f)")
geom.append("Sphere(vec3(4.0f, 1.0f, 0.0f), 1.0f)")
# big glass sphere
brdf.append("BRDF(2, vec3(1.0f), 0.0f, 1.5f)")
geom.append("Sphere(vec3(0.0f, 1.0f, 0.0f), 1.0f)")

# print geometry array
geomstring = "Sphere spheres[" + str(len(geom)) + "] = Sphere[]("
for a in range(len(geom) - 1):
    geomstring += geom[a] + ","
geomstring += geom[len(geom) - 1]
geomstring += ");"
print(geomstring)

# print BRDF array - one brdf per geometry
brdfstring = "BRDF brdfs[" + str(len(brdf)) + "] = BRDF[]("
for a in range(len(brdf) - 1):
    brdfstring += brdf[a] + ","
brdfstring += brdf[len(brdf) - 1]
brdfstring += ");"
print(brdfstring)
