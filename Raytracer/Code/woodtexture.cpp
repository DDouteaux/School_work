#include "woodtexture.h"
#include "helpers.h"
#include <cmath>

WoodTexture::WoodTexture(Vector color1, Vector color2, int grain, int octave) : PerlinTexture(color1, color2, grain, octave) {
}

Vector WoodTexture::applyPerlin(double noiseCoef, const Vector& P, const Vector& N) const{
    double v = this->grain*noiseCoef;
    double finalCoef = (1-cos(PI*(v-floor(v))))*.5;
    return Vector((1-finalCoef)*this->color1 + finalCoef*this->color2);
}
