#ifndef BOUNDINGBOX_H
#define BOUNDINGBOX_H

#include <stdlib.h>
#include <cstring>
#include <cmath>
#include <algorithm>

#include "ray.h"
#include "vector.h"

using namespace std;

class BoundingBox {
    public:
        BoundingBox();
        Vector bmin;
        Vector bmax;

        bool intersect(const Ray& r) const;
};

#endif // BOUNDINGBOX_H
