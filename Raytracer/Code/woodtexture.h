#ifndef WOODTEXTURE_H
#define WOODTEXTURE_H

#include "perlintexture.h"

class WoodTexture: public PerlinTexture {
public:
    WoodTexture(Vector color1, Vector color2, int grain, int octave);

    Vector applyPerlin(double noiseCoef, const Vector& P, const Vector& N) const;
};

#endif // WOODTEXTURE_H
