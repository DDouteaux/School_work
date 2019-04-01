#include "substraction.h"

/**
 *  Constructeur de la différence, qui est donc constituées de deux objets et définie
 *  par un matériau.
 *
 *  Params :
 *      - a : le premier objet de la différence.
 *      - b : le deuxième objet de la différence.
 *      - material : le matériau dont est constitué la différence de nos deux objets.
 */
Substraction::Substraction(Object *a, Object *b, Material material, bool newMaterial) : Object(material){
    this->a = a;
    this->b = b;
    this->newMaterial = newMaterial;
}

/**
 *  Définition de la différence. Pour qu'un point soit dedans, il est doit
 *  être dans l'élément a, mais pas dans b.
 *
 *  Params :
 *      - P : un point dont on veut savoir s'il appartient à la différence.
 *
 *  Return :
 *      - True si P est dans la différence, false sinon.
 */
bool Substraction::isInside(const Vector &P) const{
    return this->a->isInside(P) && !this->b->isInside(P);
}

/**
 *  Calcul de l'intersection entre notre différence et un rayon. La stratégie utilisée est
 *  de calculer les intersections avec les deux objets, on garde ensuite les points de a qui
 *  ne sont pas dans b, et les point de b qui sont dans a, mais en inversant la normale pour
 *  que cette dernière soit en accord avec l'orientation de a.
 *
 *  Params :
 *      - r : le rayon avec lequel on recherche nos intersections.
 *      - LI : la liste finale des points d'intersection entre le rayon et l'union.
 *
 *  Return :
 *      - Rien, mais met à jour la liste LI par référence.
 */
void Substraction::intersect(const Ray &r, std::vector<IntersectionPointCSG *> &LI) const {
    std::vector<IntersectionPointCSG *> LIa;
    std::vector<IntersectionPointCSG *> LIb;

    this->a->intersect(r, LIa);
    this->b->intersect(r, LIb);
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
    for (unsigned int i = 0; i < LIb.size(); ++i) {
        if (this->a->isInside(LIb[i]->P)) {
            if(this->newMaterial){
                LIb[i]->M = this->material;
            }
            Vector inverseNormale = (-1)*LIb[i]->N;
            LI.push_back(new IntersectionPointCSG(LIb[i]->P, inverseNormale, LIb[i]->M));
        }
        delete LIb[i];
    }
}
