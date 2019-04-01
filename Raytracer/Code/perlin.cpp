#include "perlin.h"
#include <cmath>

static int permutation[] = { 151,160,137,91,90,15,
   131,13,201,95,96,53,194,233,7,225,140,36,103,30,69,142,8,99,37,240,21,10,23,
   190, 6,148,247,120,234,75,0,26,197,62,94,252,219,203,117,35,11,32,57,177,33,
   88,237,149,56,87,174,20,125,136,171,168, 68,175,74,165,71,134,139,48,27,166,
   77,146,158,231,83,111,229,122,60,211,133,230,220,105,92,41,55,46,245,40,244,
   102,143,54, 65,25,63,161, 1,216,80,73,209,76,132,187,208, 89,18,169,200,196,
   135,130,116,188,159,86,164,100,109,198,173,186, 3,64,52,217,226,250,124,123,
   5,202,38,147,118,126,255,82,85,212,207,206,59,227,47,16,58,17,182,189,28,42,
   223,183,170,213,119,248,152, 2,44,154,163, 70,221,153,101,155,167, 43,172,9,
   129,22,39,253, 19,98,108,110,79,113,224,232,178,185, 112,104,218,246,97,228,
   251,34,242,193,238,210,144,12,191,179,162,241, 81,51,145,235,249,14,239,107,
   49,192,214, 31,181,199,106,157,184, 84,204,176,115,121,50,45,127, 4,150,254,
   138,236,205,93,222,114,67,29,24,72,243,141,128,195,78,66,215,61,156,180
   };

Perlin::Perlin() {
    for (int i=0; i<512; i++) {
        p.push_back(permutation[i%256]);
    }
}

/**
 *  Fonction d'atténuation pour le bruit de Perlin.
 *
 *  Params :
 *      - t : la valeur pour laquelle on calcule l'atténuation.
 *
 *  Return :
 *      - La valeur atténuée de t.
 */
double Perlin::fade(double t){
    return t * t * t * (t * (t * 6 - 15) + 10);
}

/**
 *  Fonction d'interpollation linéaire pour réaliser les interpolations
 *  entre les différentes valeurs rendues par le bruit.
 *
 *  Params :
 *      - t : "l'avancement" dans l'interpollation
 *      - a : la borne inférieure de la zone interpollée (t=0 => a).
 *      - b : la borne supérieure de la zone interpollée (t=1 => b).
 *
 *  Return :
 *      - La valeur interpollée en se positionnant à t% entre a et b.
 */
double Perlin::lerp(double t, double a, double b) {
    return a + t * (b - a);
}

/**
 *  Fonction de hashage pour le générateur de bruit.
 */
double Perlin::grad(int hash, double x, double y, double z) {
    int h = hash & 15;
    double u = h<8||h==12||h==13 ? x : y,
           v = h<4||h==12||h==13 ? y : z;
    return ((h&1) == 0 ? u : -u) + ((h&2) == 0 ? v : -v);
}

/**
 *  Renvoie la valeur du bruit de Perlin pour les coordonnées (x;y;z).
 *
 *  Params :
 *      - x ; y ; z : les coordonnées du point en lequel on demande la valeur du bruit.
 *
 *  Return :
 *      - La valeur du bruit au point donné.
 */
double Perlin::noise(double x, double y, double z) {
    // On transforme les coordonnées x, y et z pour les ramener dans le
    // cube dans lequel on a défini notre bruit.
    int X = (int)floor(x) & 255;
    int Y = (int)floor(y) & 255;
    int Z = (int)floor(z) & 255;
    x -= floor(x);
    y -= floor(y);
    z -= floor(z);

    // On estompe les valeurs en utilisant la fonction d'atténuation associée au bruit.
    double u = fade(x);
    double v = fade(y);
    double w = fade(z);

    // Fonction de hashage pour les coordonnées.
    int A = this->p[X]+Y;
    int AA = this->p[A]+Z;
    int AB = this->p[A+1]+Z;
    int B = this->p[X+1]+Y;
    int BA = this->p[B]+Z;
    int BB = this->p[B+1]+Z;

    // Interpollation des valeurs en utilisant également le gradient défini par Perlin.
    return lerp(w, lerp(v, lerp(u, grad(this->p[AA], x, y, z), grad(this->p[BA], x-1, y, z)),
                           lerp(u, grad(this->p[AB], x, y-1, z), grad(this->p[BB], x-1, y-1, z))),
                   lerp(v, lerp(u, grad(this->p[AA+1], x, y, z-1), grad(this->p[BA+1], x-1, y, z-1)),
                           lerp(u, grad(this->p[AB+1], x, y-1, z-1), grad(this->p[BB+1], x-1, y-1, z-1))));
}
