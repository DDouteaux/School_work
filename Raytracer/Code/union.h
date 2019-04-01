#ifndef UNION_H
#define UNION_H

#include "object.h"

class Union:public Object
{
public:
    Union(Object* a, Object* b, Material material, bool newMaterial);

    Object* a;          // Premier objet de l'union
    Object* b;          // Second objet de l'union
    bool newMaterial;   // Mutualiser les matériaux (true) ou non (false)

    bool isInside (const Vector& P) const;
    void intersect(const Ray& r, std::vector<IntersectionPointCSG *>& LI) const;
};

#endif // UNION_H
