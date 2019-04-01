#ifndef TORUS_H
#define TORUS_H

#include "object.h"

class Torus : public Object
{
public:
    Torus(Vector C, Vector u, double R, double r, Material m);
    bool isInside(const Vector &P) const;
    void intersect(const Ray &r, std::vector<IntersectionPointCSG *> &LI) const;
    Vector C;       // Centre du tore
    Vector u;       // Direction de l'axe du tore
    double R;       // Grand rayon
    double r;       // Petit rayon (dans la couronne)
};

#endif // TORUS_H
