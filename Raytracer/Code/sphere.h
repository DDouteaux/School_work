#ifndef SPHERE_H
#define SPHERE_H

#include "vector.h"
#include "ray.h"
#include "object.h"
#include "material.h"

/**
 * Toutes les méthodes non inline sont documentées dans le .cpp.
 */

class Sphere : public Object {
public:
    Sphere(Vector O, double R, Material material);
    bool isInside(const Vector &P) const;
    void intersect(const Ray&, vector<IntersectionPointCSG*>& LI) const;

    Vector O;   // Centre de la sphère
    double R;   // Rayon de la sphère
};

#endif // SPHERE_H
