#include "scene.h"
#include "helpers.h"
#include <random>
#include "box.h"
#include <typeinfo>

/**
 *  Constructeur de la classe Scene. Ce constructeur ne fait rien, si
 *  ce n'est dire que les objets sont des sphères qui seront stockées
 *  dans un tableau dynamique.
 */
Scene::Scene(Vector envColor)
{
    objects = std::vector<Object*>();
    luxSphereIndex = -1;
    this->envColor = envColor;
}

/**
 *  Fonction qui permet de savoir si un rayon donné va intercepter un
 *  des objets de la scène proposée.
 *
 *  Params :
 *      - r : le rayon pour lequel on cherche les intersections.
 *      - P : le point d'intersection à mettre à jour si on en trouve un.
 *      - N : la normale en ce point d'intersection.
 *      - id : l'identifiant de l'objet qui est intersecté.
 *      - material : le matériau de l'objet à l'intersection.
 *
 *  Return :
 *      - True si le rayon intersecte un objet de la scène, false sinon.
 */
bool Scene::intersect(const Ray& r, Vector& P, Vector& N, int& id, Material& material) {
    double mint = 1E9;
    bool result = false;

    for(int i = 0; i<objects.size(); i++) {
        double t;
        Vector N1;
        Vector P1;
        Material material1;

        if (objects[i]->intersect(r, P1, t, N1, material1)) {
            result = true;

            if (t<mint) {
                mint = t;
                P = P1;
                N = N1;
                id = i;
                material = material1;
            }
        }
    }

    return result;
}

/**
 *  Pour gérer l'ajout d'une source lumineuse non ponctuelle et que
 *  l'on retienne pour la suite son indice dans le vecteur d'objets.
 *
 *  Params:
 *      - luxSphere : la sphère lumineuse à ajouter.
 */
void Scene::addLuxSphere(Object * luxSphere){
    this->objects.push_back(luxSphere);
    this->luxSphereIndex = this->objects.size() - 1;
}

/**
 *  Fonction pour renvoyer la couleur (en intensités) du pixel en fonction
 *  des éléments composants la scène.
 *
 *  Params :
 *      - ray : le rayon envoyé dans la scène.
 *      - recursion : le nombre d'étapes de rebonds maximum dans la scène. Au
 *                    delà de la valeur initial, on considère le rayon perdu (noir).
 *
 *  Return :
 *      - un vecteur d'intensité lumineuse pour les trois composantes RGB.
 */
Vector Scene::getColor(const Ray &ray, int recursion, int recursionMax){
    // P sera le point d'intersection s'il existe et N la normale si P existe.
    Vector P, N;
    int objectId;   // id de l'objet intersecté s'il existe
    Vector finalColor;
    Material objectMaterial;

    // On regarde si le rayon intersecte l'objet
    if (intersect(ray, P, N, objectId, objectMaterial)) {
        // S'il y a une sphère lumineuse et que notre rayon l'intersecte en premier, on renvoie directement la valeur.
        if(this->luxSphereIndex != -1 && objectMaterial.emissivity > 1){
            return objectMaterial.emissivity * objectMaterial.color; // pas de texture pour une sphère lumineuse
        }
        // Premier cas, l'objet est diffus
        if(objectMaterial.isDiffuse){
            if(this->luxSphereIndex == -1){
                // L'éclairage se fait par une source ponctuelle.
                Vector l = L-P;
                double distLight2 = l.squaredNorm();
                l.normalize();

                // Prise en compte des ombres portées
                double shadow_coeff = 1;
                Vector Pp, Np;
                int idp;
                Material materialP;

                if(intersect(Ray(P+0.001*N, l), Pp, Np, idp, materialP)){
                    if((Pp-P).squaredNorm() < distLight2){
                        shadow_coeff = 0;
                    }
                }
                finalColor = finalColor + shadow_coeff * (1500*std::max(0., dot(N,l))/distLight2)*objectMaterial.computeColor(P, N);

                // Dans le cas diffus, on prend en compte l'éclairage indirect.
                // Pour cela on renvoie un rayon depuis la surface de manière aléatoire (cf. BRDF de la surface diffuse).
                if(recursion > 0){
                    // Génération de la direction aléatoire.
                    Vector randomDirection;
                    randomDirection.randomCos(N);
                    Vector indirect = getColor(Ray(P+0.001*N, randomDirection), recursion-1, recursionMax);
                    finalColor = finalColor + objectMaterial.diffusionCoeff*objectMaterial.computeColor(P, N)*indirect*(1./PI);
                }
                return finalColor;
            } else {
                // L'éclairage se fait par une source étendue.
                // On échantillonne dans la direction de la source lumineuse.
                Vector xP = (P-dynamic_cast<Sphere*>(objects[this->luxSphereIndex])->O).getNormalize();
                Vector randomDirection;
                randomDirection.randomCos(xP);
                Vector sampledLightSource = randomDirection*dynamic_cast<Sphere*>(objects[this->luxSphereIndex])->R + dynamic_cast<Sphere*>(objects[this->luxSphereIndex])->O;
                double distLight = (sampledLightSource-P).squaredNorm();
                Vector omega_i = (sampledLightSource-P).getNormalize();
                double shadow_coeff = 1;
                Vector PPrime, NPrime;
                int idPrime;
                Material materialPrime;

                if(intersect(Ray(P+0.001*N, omega_i), PPrime, NPrime, idPrime, materialPrime)){
                    if(idPrime != 0){
                        shadow_coeff = 0;
                    }
                }

                // Dans le cas diffus, on prend en compte l'éclairage indirect.
                // Pour cela on renvoie un rayon depuis la surface de manière aléatoire (cf. BRDF de la surface diffuse).
                double pdf = dot(xP, randomDirection);
                finalColor = shadow_coeff * max(0., dot(N, omega_i)/distLight) * dot(NPrime, -omega_i)/pdf*objectMaterial.computeColor(P, N) * objects[this->luxSphereIndex]->material.emissivity;

                if(recursion > 0){
                    // Génération de la direction aléatoire.
                    Vector randomDirection;
                    randomDirection.randomCos(N);
                    Vector indirect = getColor(Ray(P+0.001*N, randomDirection), recursion-1, recursionMax);
                    finalColor = finalColor + objectMaterial.diffusionCoeff * objectMaterial.computeColor(P, N) * indirect * (1./PI);
                }
                return finalColor;
            }
        }
        // Deuxième cas, l'objet est transparent et spéculaire (coeff de Fresnel)
        else if(objectMaterial.isFresnel){
            if(recursion > 0){
                Vector refractionComposant;
                bool is_refracted;
                double n1 = 1;
                double n2 = objectMaterial.indice;
                Vector normale = N;

                // Si le rayon rentre dans la sphère, il faut inverser la normale
                if(dot(normale, ray.u)>0){
                    std::swap(n1, n2);
                    normale = -normale;
                }

                // On réfracte le rayon selon les normales
                Vector refr = ray.u.refract(normale, n1, n2, is_refracted);
                if(is_refracted){
                    refractionComposant = getColor(Ray(P+0.001*refr, refr), recursion-1, recursionMax);
                }
                Vector refl = ray.u.reflect(N);

                // Calcul des coefficients de Fresnel
                double k0 = pow(n1-n2,2)/pow(n1+n2,2);
                double T = k0 + (1-k0)*pow(1-dot(normale,-ray.u),5);
                double R = 1-T;

                return R*refractionComposant + T*getColor(Ray(P+0.001*N, refl), recursion-1, recursionMax)*objectMaterial.computeColor(P, N);
            } else {
                return this->envColor;
            }
        }
        // Troisième cas, l'objet est spéculaire, on réfléchit le rayon
        else if (objectMaterial.isSpecular){
            if(recursion > 0){
                Vector refl = ray.u.reflect(N);
                return getColor(Ray(P+0.001*N, refl), recursion-1, recursionMax)*objectMaterial.computeColor(P, N);
            } else {
                return this->envColor;
            }
        }
        // Quatrième cas, l'objet est transparent, on réfracte le rayon
        else if (objectMaterial.isTransparent){
            if(recursion > 0){
                bool is_refracted;
                double n1 = 1;
                double n2 = objectMaterial.indice;
                Vector normale = N;

                // Si le rayon rentre dans la sphère, il faut inverser la normale
                if(dot(normale, ray.u)>0){
                    std::swap(n1, n2);
                    normale = -normale;
                }

                // On réfracte le rayon selon les normales
                Vector refr = ray.u.refract(normale, n1, n2, is_refracted);
                if(is_refracted){
                    return getColor(Ray(P+0.001*refr, refr), recursion-1, recursionMax);
                } else {
                    Vector refl = ray.u.reflect(N);
                    return getColor(Ray(P+0.001*N, refl), recursion-1, recursionMax)*objectMaterial.computeColor(P, N);
                }
            } else {
                return this->envColor;
            }
        }
    } else {
        return this->envColor;
    }
}
