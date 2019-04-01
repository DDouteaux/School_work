#ifndef PLAN_H
#define PLAN_H

#include "vector.h"
#include "ray.h"
#include "object.h"
#include "material.h"

class Plan : public Object {
    public:
        Plan(Vector P0, Vector N, Material material);
        bool isInside(const Vector &) const;
        void intersect(const Ray &, vector<IntersectionPointCSG *> &) const;

        Vector P0;      // Un point du plan
        Vector N;       // Vecteur normal au plan
};

#endif // PLAN_H
