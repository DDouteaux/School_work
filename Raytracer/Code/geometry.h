#ifndef GEOMETRY_H
#define GEOMETRY_H

#include <iostream>
#include <vector>
#include <stdio.h>

#include "object.h"
#include "vector.h"
#include "ray.h"
#include "boundingbox.h"

class Geometry : public Object {
    public:
        Geometry(const char* obj, Material material);

        // Voir le rapport pour le détails des différents attributs
        vector<int> faceGroup;
        vector<int> faces;
        vector<int> normalIds;
        vector<int> uvIds;
        vector<Vector> vertices;
        vector<Vector> normals;
        vector<Vector> uvs;
        BoundingBox bbox;

        void build_bbox();
        bool intersect(const Ray &r, Vector &P, double &t, Vector &N, Material &M) const;
        bool intersect(const Ray r, int id, Vector &N, double &t) const;
        bool isInside(const Vector&) const {return false;}
        void intersect(const Ray&, vector<IntersectionPointCSG*>&) const;
};

#endif // GEOMETRY_H
