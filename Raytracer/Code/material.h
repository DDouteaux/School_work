#ifndef MATERIAL_H
#define MATERIAL_H

#include <cstring>

#include "vector.h"
#include "texture.h"

/**
 * Toutes les méthodes non inline sont documentées dans le .cpp.
 */

class Material
{
public:
    Material(Vector color=Vector(1.,1.,1.), bool isDiffuse=true, bool isSpecular=false, bool isTransparent=false, bool isFresnel=false, double indice = 1, double diffusionCoeff = 1, double emissivity = 1, Texture *texture = NULL);
    Material(const Material& material);

    Vector computeColor(Vector& P, Vector& N);

    Vector color;           // Couleur du matériau
    bool isDiffuse;         // Caractère diffus (true) du matériau
    bool isSpecular;        // Caractère spéculaire (true) du matériau
    bool isTransparent;     // Caractère transparent (true) du matériau
    bool isFresnel;         // Caractère transparent (true) du matériau
    double indice;          // Indice optique du verre dans le cas de la diffraction
    double diffusionCoeff;  // Coefficient de diffusion pour le matériau
    double emissivity;      // Coefficient d'émissivité du matériau
    double fresnelRatio;
    Texture* texture;
};

#endif // MATERIAL_H
