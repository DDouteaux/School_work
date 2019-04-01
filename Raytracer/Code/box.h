#ifndef BOX_H
#define BOX_H

#include "object.h"
#include "intersectionpointcsg.h"

using namespace std;

class Box : public Object
{
public:
    Box(Vector C, Vector T1, Vector T2, Vector size, Material material);

    Vector C;       // Centre de la boîte
    Vector T1;      // Premier vecteur du repère local
    Vector T2;      // Deuxième vecteur du repère local
    Vector T3;      // Troisième vecteur du repère local
    Vector size;    // Dimensions totales de la boîte

    bool isInside(const Vector &P) const;
    bool isAlmostInside(const Vector& P, bool localSystem) const;
    void intersect(const Ray &, vector<IntersectionPointCSG *> &LI) const;
    void addIntersectionPoint(double t, Vector& E, Vector& D, vector<IntersectionPointCSG*> &LI) const;
};

#endif // BOX_H
