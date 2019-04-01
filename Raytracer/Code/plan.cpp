#include "plan.h"
#include "helpers.h"

Plan::Plan(Vector P0, Vector N, Material material) : Object(material){
    this->P0 = P0;                  // Un point du plan
    this->N = N.getNormalize();     // Vecteur normal au plan
}

/**
 *  Méthode pour savoir si le point P est à l'intérieur du plan considéré.
 *  Pour cela, on regarde simplement si le vecteur PP0 est orthogonal à N.
 *
 *  Params :
 *      - P : le point dont on cherche à savoir s'il est dans le plan.
 *
 *  Return :
 *      - True si le point est dans le plan, false sinon.
 */
bool Plan::isInside(const Vector& P) const{
    return abs(dot(P-this->P0, N)) < 0.0001;
}

/**
 *  Calcul des points d'intersection entre le plan et un rayon. Pour cela,
 *  on vérifie simplement que le rayon n'est pas parallèle au plan et on
 *  calcule ensuite l'intersection par simple projection.
 *
 *  Params :
 *      - r : le rayon dont on recherche les intersections.
 *      - LI : la liste des points d'intersection déjà connus dans la scène.
 *
 *  Return :
 *      - Rien, mais met à jour la liste des points d'intersection connus si elle en trouve.
 */
void Plan::intersect(const Ray& r, vector<IntersectionPointCSG *>& LI) const{
    // On vérifie que le rayon n'est pas parallèle au plan.
    if(abs(dot(r.u, this->N)) > 0.0001){
        // Calcul du t où a lieu l'intersection par projections.
        double t = dot(this->P0-r.C, this->N)/dot(r.u, this->N);
        Vector P = r.C + t*r.u;         // Point d'intersection.
        Vector N_ = this->N;            // Normale en ce point (N car le point est sur le plan).
        Material m = this->material;    // Matériau de l'objet

        // Ajout du point à la liste des intersections connues
        IntersectionPointCSG* IP = new IntersectionPointCSG(P, N_, m);
        LI.push_back(IP);
    }
}
