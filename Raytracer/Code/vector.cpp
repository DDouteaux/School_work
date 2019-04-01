#include "vector.h"
#include "helpers.h"
#include <stdlib.h>
#include <cstring>
#include <cmath>
#include <random>

default_random_engine engine;
uniform_real_distribution<double> distrib(0,1);

/**
 *  Constructeur de la classe Vector.
 *
 *  Params :
 *      - x ; y et z : les trois coordonnées cartésiennes.
 */
Vector::Vector(double x, double y, double z) {
    xyz[0] = x;
    xyz[1] = y;
    xyz[2] = z;
}

/**
 *  Constructeur par copie pour la classe Vector.
 *
 *  Params :
 *      - b : le Vector à copier en un nouveau vecteur.
 */
Vector::Vector(const Vector& b) {
    memcpy(xyz, b.xyz, 3*sizeof(double));
}

/**
 *  Renvoie la norme 2 d'un vecteur au carré. On préfère renvoyer
 *  cette norme au carré pour des raisons de performance.
 *
 *  Return :
 *      - Un double qui est la valeur de la norme.
 */
double Vector::squaredNorm() {
    return xyz[0]*xyz[0]+xyz[1]*xyz[1]+xyz[2]*xyz[2];
}

/**
 *  Normalise directement le vecteur sur lequel cette méthode est appelée.
 *
 *  /!\ Utiliser cette méthode avec parcimonie, car l'utilisation d'une
 *      racine carrée sera coûteuse sur le long terme.
 */
void Vector::normalize() {
    double norm = sqrt(squaredNorm());
    xyz[0] = xyz[0]/norm;
    xyz[1] = xyz[1]/norm;
    xyz[2] = xyz[2]/norm;
}

/**
 *  Codage du produit scalaire entre deux vecteurs. Un vecteur est passé en
 *  paramètre, tandis que l'autre est celui sur lequel on réalise la demande
 *  de produit scalaire.
 *
 *  Params :
 *      - b : le vecteur avec lequel calculer le produit scalaire.
 *
 *  Return :
 *      - Un double qui est la valeur retournée par le calcul.
 */
double Vector::dot(Vector& b) {
    return xyz[0]*b[0]+xyz[1]*b[1]+xyz[2]*b[2];
}

double Vector::dot(const Vector& b) const {
    return xyz[0]*b[0]+xyz[1]*b[1]+xyz[2]*b[2];
}


/**
 *  Redéfinition de l'opérateur d'accès à une composant du vecteur.
 *
 *  Params :
 *      - i : l'indice que l'on cherche dans la table.
 *
 *  Return :
 *      - Un double qui est la valeur du i-ème élément du vecteur.
 */
double Vector::operator[](int i) const {
    return xyz[i];
}

/**
 *  Méthode pour réfléchir un rayon (sur une surface spéculaire).
 *
 *  Params :
 *      - N  : la normale selon laquelle on réfléchit le rayon.
 *
 *  Return :
 *      - Le vecteur réfléchi.
 */
Vector Vector::reflect(const Vector& N) const {
    return *this-2.*dot(N)*N;
}

/**
 *  Méthode pour réfracter un rayon dans le cas de matériaux transparents.
 *
 *  Params :
 *      - N : la normale selon laquelle on réfracte le rayon.
 *      - n1 : indice du milieu duquel vient le rayon (milieu incident).
 *      - n2 : indice du milieu dans lequel va le rayon (milieu réfracté).
 *      - is_refracted : référence vers un booléen pour savoir si le rayon est :
 *                              > réfracté (true)
 *                              > réfléchi (false)
 *
 *  Return :
 *      - Un vecteur donnant le rayon réfléchi, qu'il y ait réfraction totale ou non.
 */
Vector Vector::refract(const Vector& N, double n1, double n2, bool &is_refracted) const {
    double cosThetai = dot(N);
    double D = 1-pow((n1/n2),2)*(1-pow(cosThetai,2));
    Vector Rt =((*this)-cosThetai*N)*(n1/n2);

    if(D<0){
        is_refracted = false;
        return Vector(0.,0.,0.);
    } else {
        Vector Rn = -sqrt(D)*N;
        is_refracted = true;
        return Rn+Rt;
    }
}

Vector Vector::getNormalize(){
    this->normalize();
    return *this;
}

void Vector::randomCos(const Vector &N){
    // Les coordonnées aléatoires pour le nouveau repère.
    double u = distrib(engine);
    double v = distrib(engine);
    double x = cos(2*PI*u)*sqrt(1-v);
    double y = sin(2*PI*u)*sqrt(1-v);
    double z = sqrt(v);

    // Construction d'un repère orthonormé autours de N
    Vector directionUn, directionDeux, result;
    N.orthogonalSystem(directionUn, directionDeux);

    // Calcul de la direction finale
    result = x*directionUn + y*directionDeux + z*N;

    this->xyz[0] = result[0];
    this->xyz[1] = result[1];
    this->xyz[2] = result[2];
}

/**
 *  Calcul du produit vectoriel entre le vecteur appelant et son paramètre
 *
 *  Params :
 *      - b : le vecteur avec lequel calculer le produit vectoriel.
 *
 *  Return :
 *      - Le vecteur résultat du produit vectoriel.
 */
Vector Vector::cross(const Vector &b) const{
    Vector result;
    result.xyz[0] = this->xyz[1]*b[2] - this->xyz[2]*b[1];
    result.xyz[1] = this->xyz[2]*b[0] - this->xyz[0]*b[2];
    result.xyz[2] = this->xyz[0]*b[1] - this->xyz[1]*b[0];
    return result;
}

void Vector::orthogonalSystem(Vector &tangent1, Vector &tangent2) const{
    double abs0 = abs(xyz[0]);
    double abs1 = abs(xyz[1]);
    double abs2 = abs(xyz[2]);
    double minComp = std::min(abs0,abs1);
    minComp = std::min(minComp, abs2);

    if (abs(xyz[0]) <= minComp) {
        tangent1 = Vector(0,xyz[2],-xyz[1]);
    } else if (abs(xyz[1]) <= minComp) {
        tangent1 = Vector(xyz[2],0,-xyz[0]);
    } else {
        tangent1 = Vector(xyz[1],-xyz[0],0);
    }

    tangent1.normalize();
    tangent2 = this->cross(tangent1);
}


