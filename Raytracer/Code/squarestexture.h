#ifndef SQUARESTEXTURE_H
#define SQUARESTEXTURE_H

#include "texture.h"

class SquaresTexture : public Texture {
    public:
        SquaresTexture(Vector color1, Vector color2, int pas);

        Vector applyTexture(const Vector&, const Vector&) const;

        Vector color1;
        Vector color2;
        int pas;
};

#endif // SQUARESTEXTURE_H
