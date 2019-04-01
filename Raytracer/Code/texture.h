#ifndef TEXTURE_H
#define TEXTURE_H

#include "vector.h"

class Texture {
    public:
        Texture();

        virtual Vector applyTexture(const Vector&, const Vector&) const = 0;
};

#endif // TEXTURE_H
