#include "perlintexture.h"
#include <cmath>

PerlinTexture::PerlinTexture(Vector color1, Vector color2, int grain, int octave) : Texture(){
    this->perlin = new Perlin();
    this->color1 = color1;
    this->color2 = color2;
    this->grain = grain;
    this->octave = octave;
}

Vector PerlinTexture::applyTexture(const Vector& P, const Vector& N) const{
    double noiseCoef = 0;

    for (int level = 1; level<this->octave; level++) {
        noiseCoef += (1./level) * fabsf(float(this->perlin->noise(level*.05*P[0], level*.05*P[1], level*.05*P[2])));
    }
    return applyPerlin(noiseCoef, P, N);
}
