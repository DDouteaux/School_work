#include "ray.h"

/**
 *  Constructeur d'un rayon pour initialiser ses attributs.
 *
 *  Params :
 *      - C : le point de départ du rayon (un vecteur pour le représenter).
 *      - u : la direction du rayon (elle aussi représentée par un vecteur).
 */
Ray::Ray(Vector C, Vector u) {
    this->C = C;
    this->u = u;
}
