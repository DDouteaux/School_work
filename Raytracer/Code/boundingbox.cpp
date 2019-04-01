#include "boundingbox.h"

BoundingBox::BoundingBox(){}

// Même principe que pour les boîtes, pas plus de commentaire donc.
bool BoundingBox::intersect(const Ray &r) const{
    double tx1 = (bmin[0] - r.C[0])/r.u[0];
    double tx2 = (bmax[0] - r.C[0])/r.u[0];

    double ty1 = (bmin[1] - r.C[1])/r.u[1];
    double ty2 = (bmax[1] - r.C[1])/r.u[1];

    double tz1 = (bmin[2] - r.C[2])/r.u[2];
    double tz2 = (bmax[2] - r.C[2])/r.u[2];

    double tmax = min(min(max(tx1, tx2), max(ty1, ty2)), max(tz1, tz2));
    double tmin = max(max(min(tx1, tx2), min(ty1, ty2)), min(tz1, tz2));

    return tmax > tmin;
}
