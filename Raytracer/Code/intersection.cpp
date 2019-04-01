#include "intersection.h"
#include <cstring>

Intersection::Intersection(Object* a, Object* b, Material material, bool newMaterial) : Object(material) {
    this->a = a;
    this->b = b;
    this->newMaterial = newMaterial;
}

// Être dans l'intersection c'est être dans A et B
bool Intersection::isInside(const Vector &P) const{
    return this->a->isInside(P) && this->b->isInside(P);
}

// Réalisation de l'intersection, voir le rapport pour plus de détails
void Intersection::intersect(const Ray &r, vector<IntersectionPointCSG *> &LI) const{
    vector<IntersectionPointCSG*> LIa;
    vector<IntersectionPointCSG*> LIb;

    this->a->intersect(r, LIa);
    this->b->intersect(r, LIb);

    for(int i=0; i<LIa.size(); ++i){
        if(this->b->isInside(LIa[i]->P)){
            if(this->newMaterial){
                LIa[i]->M = this->material;
            }
            LI.push_back(LIa[i]);
        } else {
            delete LIa[i];
        }
    }

    for(int i=0; i<LIb.size(); ++i){
        if(this->a->isInside(LIb[i]->P)){
            if(this->newMaterial){
                LIb[i]->M = this->material;
            }
            LI.push_back(LIb[i]);
        } else {
            delete LIb[i];
        }
    }
}
