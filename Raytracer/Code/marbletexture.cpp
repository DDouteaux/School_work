#include "marbletexture.h"
#include <math.h>

MarbleTexture::MarbleTexture(Vector color1, Vector color2, int grain, int octave) : PerlinTexture(color1, color2, grain, octave){
}

Vector MarbleTexture::applyPerlin(double noiseCoef, const Vector& P, const Vector& N) const{
    double finalCoef = .5 * sinf((P[0]+P[1]+P[2])*.5 + this->grain*noiseCoef) + .5;
    return Vector((1-finalCoef)*this->color1 + finalCoef*this->color2);
}
