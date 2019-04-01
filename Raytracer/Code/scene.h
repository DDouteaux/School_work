#ifndef SCENE_H
#define SCENE_H

#include <vector>

#include "object.h"
#include "sphere.h"
#include "vector.h"
#include "helpers.h"


/**
 * Toutes les méthodes non inline sont documentées dans le .cpp.
 */

class Scene {
public:
    Scene(Vector envColor);
    bool intersect(const Ray& r, Vector& P, Vector& N, int& id, Material& material);
    Vector getColor(const Ray &ray, int recursion, int recursionMax);
    void addLuxSphere(Object*);

    std::vector<Object*> objects;    // Tous les objets de la scène
    Vector L;
    Vector envColor;
    int luxSphereIndex;
};

#endif // SCENE_H
