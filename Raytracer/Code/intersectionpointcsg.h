#ifndef INTERSECTIONPOINTCSG_H
#define INTERSECTIONPOINTCSG_H

#include "vector.h"
#include "material.h"

class IntersectionPointCSG
{
public:
    IntersectionPointCSG(Vector& P, Vector& N, Material& M);

    Vector P;       // Le point d'intersection
    Vector N;       // Sa normale
    Material M;     // Son matériau
};

#endif // INTERSECTIONPOINTCSG_H
