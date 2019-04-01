#ifndef CYLINDERCSG_H
#define CYLINDERCSG_H

#include "object.h"
#include "vector.h"

class Cylinder : public Object
{
public:
    Cylinder(Vector A, Vector B, double R, Material M);
    Vector A;       // Première extrémité
    Vector B;       // Deuxième extrémité
    double R;       // Rayon
    bool isInside(const Vector & P) const;
    void intersect(const Ray & r, std::vector<IntersectionPointCSG *> & LI) const;
};

#endif // CYLINDERCSG_H
