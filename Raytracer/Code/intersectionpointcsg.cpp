#include "intersectionpointcsg.h"

/**
 *  Constructeur de la classe des points d'intersection entre le rayon et un objet.
 *
 *  Params :
 *      - P : le point d'intersection.
 *      - N : la normale en ce point d'intersection.
 *      - M : le matériau du point d'intersection.
 */
IntersectionPointCSG::IntersectionPointCSG(Vector &P, Vector &N, Material &M){
    this->P = P;
    this->N = N;
    this->M = M;
}
