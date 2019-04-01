#include "squarestexture.h"
#include <cmath>

SquaresTexture::SquaresTexture(Vector color1, Vector color2, int pas) : Texture() {
    this->color1 = color1;
    this->color2 = color2;
    this->pas = pas;
}

Vector SquaresTexture::applyTexture(const Vector& P, const Vector& N) const {
    int newX = int(P[0])/this->pas - (P[0]<0 ? 1 : 0);
    int newZ = int(P[2])/this->pas - (P[2]<0 ? 1 : 0);

    return ((newX + newZ)%2) ? this->color1 : this->color2;
}
