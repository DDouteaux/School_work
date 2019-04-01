#include "object.h"
#include <iostream>

/**
 *  Constructeur minimal pour un object. Ce dernier nva uniquement
 *  associer un matériau à l'objet.
 *
 *  Params :
 *      - material : le matériau à associer à l'objet créé.
 */
Object::Object(Material material) {
    this->material = material;
}

/**
 *  Méthode générique pour vérifier si un rayon intersecte l'objet. Toutes
 *  étapes de calculs sont laissées aux classes héritant de Object via la
 *  méthode interset(Ray&, vector<IntersectionPointCSG*>).
 *
 *  Params :
 *      - r : le rayon donc on cherche les intersections avec les objets.
 *      - P : le point où il y aura intersection (s'il y en a une).
 *      - t : la position du point d'intersection sur le rayon (t>0).
 *      - N : la normale en ce point d'intersection.
 *      - material : la matériau de l'objet en son point d'intersection.
 *
 *  Return :
 *      - True s'il y a intersection, false sinon.
 */
bool Object::intersect(const Ray &r, Vector &P, double &t, Vector &N, Material &M) const{
    vector<IntersectionPointCSG*> LI;       // Liste des points d'intersection entre l'objet et le rayon.
    this->intersect(r, LI);                 // On ajout les points d'intersection à la liste.
    double minT = 9E5;

    // Pour chaque point d'intersection, on regarde les points suivants :
    //      1. Est-il du côté où le rayon va (T>0).
    //      2. Est-il plus proche que le précédent point retenu (T<minT).
    for(unsigned int i=0; i<LI.size(); ++i){
        IntersectionPointCSG* IP = LI[i];
        double T = (IP->P - r.C).dot(r.u);
        if(T>0 && T<minT) {
            minT = T;
            P = IP->P;
            N = IP->N;
            M = IP->M;
        }
    }

    t = minT; // Valeur finale retenue pour la position sur le rayon (t).
    for(unsigned int i=0; i<LI.size(); ++i){
        IntersectionPointCSG* IP = LI[i];
        delete IP;
    }

    // Si la valeur minimale à changée, c'est que l'on a intersecté l'objet.
    return minT < 9E5;
}
