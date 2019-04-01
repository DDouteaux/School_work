#ifndef OBJECT_H
#define OBJECT_H

#include <vector>

#include "material.h"
#include "ray.h"
#include "vector.h"
#include "intersectionpointcsg.h"

using namespace std;

/**
 * Toutes les méthodes non inline sont documentées dans le .cpp.
 */

class Object{
public:
    Object(Material material);

    // Déclaration virtuelle pour la fonction d'intersection à réimplémenter pour chaque objet
    //virtual bool intersect(const Ray&, Vector&, double&, Vector&, Material&) {return false;}
    virtual bool isInside(const Vector&) const = 0;
    virtual void intersect(const Ray&, vector<IntersectionPointCSG*>&) const = 0;
    bool intersect(const Ray& r, Vector& P, double& t, Vector& N, Material& M) const;

    Material material;
};

#endif // OBJECT_H
