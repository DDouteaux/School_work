#ifndef PERLINTEXTURE_H
#define PERLINTEXTURE_H

#include "texture.h"
#include "perlin.h"

class PerlinTexture : public Texture {
    public:
        PerlinTexture(Vector color1, Vector color2, int grain, int octave);
        Vector applyTexture(const Vector& P, const Vector& N) const;
        virtual Vector applyPerlin(double, const Vector&, const Vector&) const = 0;

        Perlin* perlin;     // Générateur de bruit
        int grain;          // Importance relative du bruit dans la fonction à bruiter
        int octave;         // Nombre d'octaves à utiliser
        Vector color1;      // Couleur niveau bas
        Vector color2;      // Couleur niveau haut
};

#endif // PERLINTEXTURE_H
