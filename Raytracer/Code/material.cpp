#include "material.h"

/**
 *  Constructeur par défaut de la classe Material.
 *
 *  Params :
 *      - color : un vecteur pour représenter la couleur du matériau.
 *      - isDiffuse : true si le matériau est diffus, false sinon.
 *      - isSpecular : true si le matériau est spéculaire, false sinon.
 *      - isTransparent : true si le matériau est transparent, false sinon.
 *      - indice : l'indice de réfraction du matériau.
 *      - diffusionCoeff : le coefficient de diffusion de la surface.
 */
Material::Material(Vector color, bool isDiffuse, bool isSpecular, bool isTransparent, bool isFresnel, double indice, double diffusionCoeff, double emissivity, Texture* texture){
    this->color = color;
    this->isDiffuse = isDiffuse;
    this->isSpecular = isSpecular;
    this->isTransparent = isTransparent;
    this->isFresnel = isFresnel;
    this->indice = indice;
    this->diffusionCoeff = diffusionCoeff;
    this->emissivity = emissivity;
    this->texture = texture;
}

/**
 *  Constructeur par copie pour la matériau.
 *
 *  Params :
 *      - material : une référence vers le matériau que l'on désire copier.
 */
Material::Material(const Material& material){
    this->color = material.color;
    this->isDiffuse = material.isDiffuse;
    this->isSpecular = material.isSpecular;
    this->isTransparent = material.isTransparent;
    this->isFresnel = material.isFresnel;
    this->indice = material.indice;
    this->diffusionCoeff = material.diffusionCoeff;
    this->emissivity = material.emissivity;
    this->texture = material.texture;
}

Vector Material::computeColor(Vector& P, Vector& N){
    if(this->texture == NULL){
        return this->color;
    } else {
        return this->texture->applyTexture(P, N);
    }
}
