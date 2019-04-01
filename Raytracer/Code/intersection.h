#ifndef INTERSECTION_H
#define INTERSECTION_H

#include "object.h"

class Intersection : public Object
{
public:
    Intersection(Object* a, Object* b, Material material, bool newMaterial);

    Object* a;          // Premier objet
    Object* b;          // Deuxième objet
    bool newMaterial;   // Mutualiser les matériaux (true) ou non (false)

    bool isInside(const Vector& P) const;
    void intersect(const Ray& r, vector<IntersectionPointCSG *>& LI) const;
};

#endif // INTERSECTION_H
