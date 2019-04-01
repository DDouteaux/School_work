#include <cmath>
#include "sphere.h"
#include "helpers.h"

/**
 *  Constructeur d'une sphère. Va initialiser les attributs spécifiques de
 *  la sphère, et déléguer la partie matériau à la classe Object.
 *
 *  Params :
 *      - O : le centre de la sphère.
 *      - R : le rayon de la sphère.
 *      - material : le matériau à associer (cf. Object(Material)).
 */
Sphere::Sphere(Vector O, double R, Material material) : Object(material) {
    this->O = O;
    this->R = R;
}

/**
 *  Fonction nécessaire à la CSG, pour savoir si un point est contenu ou non dans notre sphère.
 *  La vérification se fait simplement en vérifiant que (P-O) < R^2.
 *
 *  Params :
 *      - P : le point dont on veut savoir s'il est dans la sphère.
 *
 *  Return :
 *      - True si P est dans la sphère, false sinon.
 */
bool Sphere::isInside(const Vector &P) const{
    return (P-O).squaredNorm() < pow(R, 2);
}

/**
 *  Deuxième version de la fonction d'intersection, à utiliser dans le cas d'un CSG, et qui
 *  va en plus de calculer le point d'intersection mettre à jour une liste de points d'intersections.
 *
 *  Params :
 *      - r : le rayon dont on cherche les intersections avec la sphère.
 *      - LI : la liste des points d'intersection avec le rayon.
 *
 *  Return :
 *      - Rien, mais met à jour par références la liste des points d'intersection.
 */
void Sphere::intersect(const Ray & r, std::vector<IntersectionPointCSG *> & LI) const {
    Vector P;
    Vector N;
    double a =1;
    double b = 2.*r.u.dot(r.C-O);
    double c = (r.C-O).squaredNorm() - R*R;
    double delta = b*b - 4*a*c;

    if (delta>=0) {

        double t1 = (-b-sqrt(delta))/(2*a);
        double t2 = (-b+sqrt(delta))/(2*a);

        if (t1 > 0) {
            P = r.C+ t1*r.u;
            N = P-O;
            N.normalize();
            Material m = Material(this->material);
            IntersectionPointCSG* IP = new IntersectionPointCSG(P, N, m);
            LI.push_back(IP);
        }
        if (t2 > 0) {
            P = r.C+ t2*r.u;
            N = P-O;
            N.normalize();
            Material m = Material(this->material);
            IntersectionPointCSG* IP = new IntersectionPointCSG(P, N, m);
            LI.push_back(IP);
        }
    }
}
