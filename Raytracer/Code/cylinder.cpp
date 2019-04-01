#include "cylinder.h"
#include <cmath>

Cylinder::Cylinder(Vector A, Vector B, double R, Material M) : Object(M){
    this->A = A;
    this->B = B;
    this->R = R;
}

/**
 *  Méthode pour savoir si le point P est à l'intérieur du cylindre considéré.
 *  Pour cela, on réalise trois tests :
 *      1. On projette P sur le disque "au sommet" du cylindre et de centre A.
 *              Si la distance projeté - A < R^2, c'est bon
 *      2. On vérifie que P est du "bon côté" de A, à savoir vers les u positifs.
 *      3. On vérifie que P est du "bon côté" de B, à savoir vers les u négatifs.
 *
 *  Params :
 *      - P : le point dont on cherche à savoir s'il est dans le cylindre.
 *
 *  Return :
 *      - True si le point est dans le cylindre, false sinon.
 */
bool Cylinder::isInside(const Vector &P) const{
    Vector u = (B-A).getNormalize();
    // Tests dans l'ordre 1. && 2. && 3.
    return ((P-A-(P-A).dot(u)*u).squaredNorm()<(R*R)) && ((P-A).dot(u)>0) && ((P-B).dot(u) < 0);
}

/**
 *  Calcul des points d'intersection entre le cylindre et un rayon. Pour
 *  cela,
 *
 *  Params :
 *      - r : le rayon dont on recherche les intersections.
 *      - LI : la liste des points d'intersection déjà connus dans la scène.
 *
 *  Return :
 *      - Rien, mais met à jour la liste des points d'intersection connus si elle en trouve.
 */
void Cylinder::intersect(const Ray &r, std::vector<IntersectionPointCSG *> &LI) const {
    const Vector normale = (B-A).getNormalize();
    const double ndotr = normale.dot(r.u);

    Material m = this->material;

    // --- Partie 1 : Intersection avec les deux demi-plans extrêmes

    // Demi-plan passant par A. On calcule le point d'intersection avec le plan et on vérifie :
    //      1. Que le point et au plus à une distance R de A.
    //      2. Que le point est bien devant le départ du rayon (t>0).
    double tA = normale.dot(A-r.C)/ndotr;
    Vector PA = r.C+tA*r.u;
    if ((PA-A-(PA-A).dot(normale)*normale).squaredNorm()<R*R && tA > 0) {
        // Toutes les conditions sont réunies, on créé la normale et on ajoute l'intersection.
        Vector N = (-1)*normale;
        LI.push_back(new IntersectionPointCSG(PA, N, m));
    }

    // Demi-plan passant par B, même principe, sauf la normale qui est orientée dans l'autre sens.
    double tB = normale.dot(B-r.C)/ndotr;
    Vector PB = r.C+tB*r.u;
    if ((PB-A-(PB-A).dot(normale)*normale).squaredNorm()<R*R && tB > 0) {
        Vector N = normale;
        LI.push_back(new IntersectionPointCSG(PB, N, m));
    }

    // --- Partie 2 : Intersection avec le corps du cylindre

    // La mise en équation conduit à une équation de degré deux avec pour coeff...
    Vector deltaC = r.C-A;
    double a = 1-ndotr*ndotr;
    double dcdotn = normale.dot(deltaC);
    double b = 2*(r.u-ndotr*normale).dot(deltaC-dcdotn*normale);
    double c = (deltaC-dcdotn*normale).squaredNorm()-R*R;
    double delta = b*b-4*a*c;

    // On résout notre équation du second degré
    if (delta > 0) {
        double tc1 = (-b-sqrt(delta))/(2*a);    // Le t solution de l'équation
        Vector Pc1 = r.C+tc1*r.u;               // Le point d'intersection calculé
        // On vérifie que le point calculé vérifie :
        //      1. Devant le rayon (t>0).
        //      2. Du bon côté de A (vers les u positifs).
        //      3. Du bon côté de B (vers les u négatifs).
        // Si c'est le cas, on ajoute le point à la liste des intersections.
        if (tc1 > 0 && (Pc1-A).dot(normale) > 0 && (Pc1-B).dot(normale) < 0) {
            Vector N = (Pc1-A-(Pc1-A).dot(normale)*normale).getNormalize();
            LI.push_back(new IntersectionPointCSG(Pc1,N,m));
        }

        // Même principe qu'avec la première solution.
        double tc2 = (-b+sqrt(delta))/(2*a);
        Vector Pc2 = r.C+tc2*r.u;
        if (tc2 > 0 && (Pc2-A).dot(normale) > 0 && (Pc2-B).dot(normale) < 0) {
            Vector N = (Pc2-A-(Pc2-A).dot(normale)*normale).getNormalize();
            LI.push_back(new IntersectionPointCSG(Pc2,N,m));
        }
    }
}
