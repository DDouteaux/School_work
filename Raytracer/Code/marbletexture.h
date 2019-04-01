#ifndef MARBLE_H
#define MARBLE_H

#include "perlintexture.h"

class MarbleTexture : public PerlinTexture {
    public:
        MarbleTexture(Vector color1, Vector color2, int grain, int octave);

        Vector applyPerlin(double noiseCoef, const Vector& P, const Vector& N) const;
};

#endif // MARBLE_H
