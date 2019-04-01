#ifndef SUBSTRACTION_H
#define SUBSTRACTION_H

#include "object.h"

class Substraction : public Object
{
public:
    Substraction(Object* a, Object* b, Material material, bool newMaterial);

    Object* a;          // Premier objet de l'union
    Object* b;          // Second objet de l'union
    bool newMaterial;   // Mutualiser les matériaux (true) ou non (false)

    bool isInside(const Vector& P) const;
    void intersect(const Ray& r, std::vector<IntersectionPointCSG*>& LI) const;
};

#endif // SUBSTRACTION_H
