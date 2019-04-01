#include "box.h"
#include <limits>
#include <stdlib.h>
#include <stdio.h>

#define epsilon 0.00001

Box::Box(Vector C, Vector T1, Vector T2, Vector size, Material material) : Object(material){
    this->C = C;                                        // Origine du repère local.
    this->T1 = T1.getNormalize();                       // Normalisation de la première direction.
    this->T2 = (T2-T2.dot(T1)*T1).getNormalize();       // On retire la composante selon T1 de T2 et on normalise cette seconde direction.
    this->T3 = T1.cross(T2);                            // La troisième direction s'obtient par produit vectoriel.
    this->size = size;                                  // Dimensions de la boîte.
}

/**
 *  Méthode pour savoir si le point P est à l'intérieur de la boîte considérée.
 *  Pour cela, on regarde son écart par rapport au centre de la boîte, dans la
 *  mesure où on connaît ses dimensions selon les axes.
 *
 *  Params :
 *      - P : le point dont on cherche à savoir s'il est dans la boîte.
 *
 *  Return :
 *      - True si le point est dans la boîte, false sinon.
 */
bool Box::isInside(const Vector &P) const{
    Vector deltaP = P-C;
    return abs(deltaP.dot(T1)) < size[0]/2 && abs(deltaP.dot(T2)) < size[1]/2 && abs(deltaP.dot(T3)) < size[2]/2;
}

/**
 *  Méthode pour savoir si un point est bien dans la boîte, mais en incluant un facteur
 *  epsilon pour les approximations numériques. On ajoute de plus un booléen pour savoir
 *  si on utilise un repère local à la boîte ou le repère global de la scène.
 *
 *  Params :
 *      - P : le point dont on cherche à savoir s'il est dans la boîte.
 *      - localSystem : true si on utilise un système local à la boîte, false s'il s'agit du global.
 *
 *  Return :
 *      - True si le point est dans la boîte, false sinon.
 */
bool Box::isAlmostInside(const Vector &P, bool localSystem) const{
    if(localSystem){
        return abs(P[0]) < size[0]/2+epsilon && abs(P[1]) < size[1]/2+epsilon && abs(P[2]) < size[2]/2+epsilon;
    } else {
        Vector deltaP = P-C;
        return abs(deltaP.dot(T1)) < size[0]/2+epsilon && abs(deltaP.dot(T2)) < size[1]/2+epsilon && abs(deltaP.dot(T3)) < size[2]/2+epsilon;
    }
}

/**
 *  Méthode pour ajouter les points d'intersection à la liste de points d'intersection déjà calculée
 *  pour cette scène. Cette fonction est appelée à la fin de la méthode de calcul de ces points.
 *
 *  Params :
 *      - t : la position de l'intersection calculée sur le rayon (P = C+t*u ou P=D+t*E en coord. locales).
 *      - E : l'expression du vecteur u du rayon dans le système de coordonnées de la boîte.
 *      - D : l'expression du point de départ C du rayon dans le système de coordonnées de la boîte.
 *      - LI : la liste des points d'intersection déjà calculés dans la scène.
 */
void Box::addIntersectionPoint(double t, Vector &E, Vector &D, vector<IntersectionPointCSG *> &LI) const{
    Vector P = D + t*E; // Point d'intersection sur la surface du cube
    Vector N;           // Normale en ce point d'intersection

    if(this->isAlmostInside(P, true)){
        double min = numeric_limits<double>::max();

        // Le point d'intersection est sur une face orthogonale à T1.
        double distance = abs(size[0]/2 - abs(P[0]));
        if(distance < min){
            min = distance;
            N = (P[0] > 0 ? 1 : -1)*T1;
        }

        // Le point d'intersection est sur une face orthogonale à T2.
        distance = abs(size[1]/2 - abs(P[1]));
        if(distance < min){
            min = distance;
            N = (P[1] > 0 ? 1 : -1)*T2;
        }

        // Le point d'intersection est sur une face orthogonale à T3.
        distance = abs(size[2]/2 - abs(P[2]));
        if(distance < min){
            min = distance;
            N = (P[2] > 0 ? 1 : -1)*T3;
        }

        // Si le point est bien dans la boîte (modulo un espilon), on créé le point d'intersection
        Material m = this->material;

        Vector realP = C + P[0]*T1 + P[1]*T2 + P[2]*T3;
        IntersectionPointCSG* IP = new IntersectionPointCSG(realP, N, m);
        LI.push_back(IP);
    }
}

/**
 *  Calcul des points d'intersection avec les plans contenant les différentes faces
 *  du cube. Pour cette recherche, on considère initiallement que les plans sont
 *  infinis, les questions relatives au fait que le point soit "réellement" dans la
 *  boîte seront traités dans la méthode d'ajout des points à la liste des intersections.
 *
 *  Params :
 *      - r : le rayon dont on cherche les intersections.
 *      - LI : la liste des points d'intersection déjà calculées avec d'autres éléments.
 *
 *  Return :
 *      - Rien, mais arrête son traitement si aucun point n'est trouvé.
 */
void Box::intersect(const Ray &r, std::vector<IntersectionPointCSG *> &LI) const {
    // Changement de repère du rayon pour se ramener au cas où la box est alignée avec les axes.
    Vector E(r.u.dot(T1), r.u.dot(T2), r.u.dot(T3));                // Coordonnées de u dans le repère de la boîte
    Vector D((r.C-C).dot(T1), (r.C-C).dot(T2), (r.C-C).dot(T3));    // Coordonnées de C dans le repère de la boîte

    // Enregistrement des dimensions de la boîte divisées par deux.
    double halfx = size[0]/2;
    double halfy = size[1]/2;
    double halfz = size[2]/2;

    // Les valeurs minimales et maximales du t du rayon sur chacun des axes de la boîte
    // pour la partie du rayon qui intersecte cette boîte.
    double tmin, tmax, tymin, tymax, tzmin, tzmax;

    bool rsign0 = 1/E[0] < 0;
    bool rsign1 = 1/E[1] < 0;
    bool rsign2 = 1/E[2] < 0;

    // Les limites extrêmes de la boîte dans le repère de cette dernière.
    Vector bounds[2];
    bounds[0] = Vector(-halfx, -halfy, -halfz);
    bounds[1] = Vector( halfx,  halfy,  halfz);

    // Valeurs extrêmes de t selon T1.
    tmin = (bounds[rsign0][0] - D[0]) / E[0];
    tmax = (bounds[1-rsign0][0] - D[0]) / E[0];

    // Valeurs extrêmes de t selon T2.
    tymin = (bounds[rsign1][1] - D[1]) / E[1];
    tymax = (bounds[1-rsign1][1] - D[1]) / E[1];

    // Mise à jour des valeurs selon que les positions relatives des domaines de t
    // selon les axes T1 et T2.
    if ((tmin > tymax) || (tymin > tmax)){
        return;
    }
    if (tymin > tmin){
        tmin = tymin;
    }
    if (tymax < tmax){
        tmax = tymax;
    }

    // Valeurs extrêmes de t selon T3.
    tzmin = (bounds[rsign2][2] - D[2]) / E[2];
    tzmax = (bounds[1-rsign2][2] - D[2]) / E[2];

    // Mise à jour des valeurs selon que les positions relatives des domaines de t
    // selon les deux axes précédents et T3.
    if ((tmin > tzmax) || (tzmin > tmax)){
        return;
    }
    if (tzmin > tmin){
        tmin = tzmin;
    }
    if (tzmax < tmax){
        tmax = tzmax;
    }

    // Ajout des deux points d'intersection trouvés à la liste d'intersections.
    addIntersectionPoint(tmin, E, D, LI);
    addIntersectionPoint(tmax, E, D, LI);
}
