#ifndef RAY_H
#define RAY_H
#include "vector.h"

/**
 * Toutes les méthodes non inline sont documentées dans le .cpp.
 */

class Ray {
public:
    Ray(Vector C, Vector u);
    Vector C;   // Point de départ du rayon
    Vector u;   // Direction du rayon
};

#endif // RAY_H
