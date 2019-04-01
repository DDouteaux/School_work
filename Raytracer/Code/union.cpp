#include "union.h"
#include <iostream>

/**
 *  Constructeur de l'union, qui est donc constituées de deux objets et définie
 *  par un matériau.
 *
 *  Params :
 *      - a : le premier objet de l'union.
 *      - b : le deuxième objet de l'union.
 *      - material : le matériau dont est constitué l'union de nos deux objets.
 */
Union::Union(Object *a, Object *b, Material material, bool newMaterial) : Object(material){
    this->a = a;
    this->b = b;
    this->newMaterial = newMaterial;
}

/**
 *  Définition de l'union. Pour qu'un point soit dans l'union, il est au
 *  moins dans un des deux objets utilisés dans cette union.
 *
 *  Params :
 *      - P : un point dont on veut savoir s'il appartient à l'union.
 *
 *  Return :
 *      - True si P est dans l'union, false sinon.
 */
bool Union::isInside(const Vector &P) const{
    return a->isInside(P) || b->isInside(P);
}

/**
 *  Calcul de l'intersection entre notre union et un rayon. La stratégie utilisée est
 *  de calculer les intersections avec les deux objets, puis de ne garder que les points
 *  qui sont dans l'un des deux uniquement. Ainsi, on ne conservera que les points qui
 *  sont sur l'extérieur de l'union, et on obtiendra donc le nombre de points minimum
 *  servant à définir cette union.
 *
 *  Params :
 *      - r : le rayon avec lequel on recherche nos intersections.
 *      - LI : la liste finale des points d'intersection entre le rayon et l'union.
 *
 *  Return :
 *      - Rien, mais met à jour la liste LI par référence.
 */
void Union::intersect(const Ray &r, std::vector<IntersectionPointCSG *> &LI) const{
    // Listes d'intersection du rayon avec l'objet a et l'objet b.
    vector<IntersectionPointCSG *> LIa;
    vector<IntersectionPointCSG *> LIb;

    // On récupère les intersections avec ces deux objets.
    this->a->intersect(r, LIa);
    this->b->intersect(r, LIb);

    // Pour chaque intersection entre a et le rayon, si l'intersection n'est pas dans b,
    // on l'ajoute dans la liste des intersections avec l'union.
    for (unsigned int i = 0; i < LIa.size(); ++i) {
        if (!this->b->isInside(LIa[i]->P)) {
            if(this->newMaterial){
                LIa[i]->M = this->material;
            }
            LI.push_back(LIa[i]);
        }
        else {
            delete LIa[i];
        }
    }

    // Pour chaque intersection entre b et le rayon, si l'intersection n'est pas dans a,
    // on l'ajoute dans la liste des intersections avec l'union.
    for (unsigned int i = 0; i < LIb.size(); ++i) {
        if (!this->a->isInside(LIb[i]->P)) {
            if(this->newMaterial){
                LIb[i]->M = this->material;
            }
            LI.push_back(LIb[i]);
        }
        else {
            delete LIb[i];
        }
    }
}
