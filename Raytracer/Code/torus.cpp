#include "torus.h"
#include "quarticsolver.h"

Torus::Torus(Vector C, Vector u, double R, double r, Material m) : Object(m){
    this->C = C;    // Centre du tore.
    this->u = u;    // Vecteur directeur du tore.
    this->R = R;    // Grand rayon du tore (rayon entre C et le cercle des centres de la couronne).
    this->r = r;    // Rayon des cercles de la couronne.
}

/**
 *  Méthode pour savoir si le point P est à l'intérieur du tore considéré.
 *  Pour cela, on regarde si sa distance à sa projection sur le cercle des
 *  centres de la couronne est bien inférieur à leur rayon.
 *
 *  Params :
 *      - P : le point dont on cherche à savoir s'il est dans le tore.
 *
 *  Return :
 *      - True si le point est dans le tore, false sinon.
 */
bool Torus::isInside(const Vector &P) const{
    // On projete P sur le cercle de centre C et de rayon R.
    Vector deltaP = P-C;
    Vector projection = C+(deltaP-deltaP.dot(u)*u).getNormalize()*R;
    // Si la distance de P à sa projection est < r^2 alors P est dans le tore.
    // Sinon P est trop loin pour être dans ce tore.
    double distToCircle2 = (P-projection).squaredNorm();
    return distToCircle2 < pow(r,2);
}

/**
 *  Calcul des points d'intersection entre le tore et un rayon. Pour faciliter ces
 *  calculs, on utilise un changement de repère pour se ramener à un cas simple où
 *  le tore est centré sur l'axe vertical.
 *
 *  /!\ Cette méthode utilise un solveur pour résoudre son équation
 *
 *  Params :
 *      - r : le rayon dont on recherche les intersections.
 *      - LI : la liste des points d'intersection déjà connus dans la scène.
 *
 *  Return :
 *      - Rien, mais met à jour la liste des points d'intersection connus si elle en trouve.
 */
void Torus::intersect(const Ray & r, std::vector<IntersectionPointCSG *> & LI) const {
    // On change le repère du rayon pour l'exprimer dans un repère où le tore est centré autours de l'axe vertical.
    // Dans ce nouveau repère, l'axe vertical est u et les deux autres axes T1 et T2.
    Vector T1;
    Vector T2;
    this->u.orthogonalSystem(T1, T2);
    Vector E(r.u.dot(T1), r.u.dot(T2), r.u.dot(this->u));               // Coordonnées de u dans le nouveau repère.
    Vector D((r.C-C).dot(T1), (r.C-C).dot(T2), (r.C-C).dot(this->u));   // Coordonnées de C dans le nouveau repère.

    // Calcul des coefficients de l'équation d'intersection.
    double R2 = pow(R,2);
    double G = 4*R2*(E[0]*E[0]+E[1]*E[1]);
    double H = 8*R2*(D[0]*E[0]+D[1]*E[1]);
    double I = 4*R2*(D[0]*D[0]+D[1]*D[1]);
    double J = E.squaredNorm();
    double K = 2*E.dot(D);
    double L = D.squaredNorm()+R2-this->r*this->r;

    double coef[4];
    double roots[4];
    coef[0] = 2*K/J;
    coef[1] = (2L*L+K*K-G)/(J*J);
    coef[2] = (2*K*L-H)/(J*J);
    coef[3] = (L*L-I)/(J*J);

    // L'équation est de degré quatre, on utilise un solveur numérique.
    unsigned int nbroots = quarticSolver(coef, roots);

    Material m = this->material;

    // Pour chaque solution, on ajoute cette dernière la liste des points d'intersection déjà connus.
    for (unsigned int i = 0; i <nbroots; ++i) {
        // Pour mémoire, on veut être en face du pont de départ du rayon ie. t>0.
        if (roots[i] > 0) {
            Vector P = r.C+roots[i]*r.u;                                // Coordonnées dans le repère général.
            Vector Pprime = C+(P-C-(P-C).dot(u)*u).getNormalize()*R;    // Projeté de P sur le cercle (cf. intersect).
            Vector N = (P-Pprime).getNormalize();                       // Vecteur normal au point d'intersection donné par un "vecteur rayon".

            // L'ajout à proprement parler
            IntersectionPointCSG* IP = new IntersectionPointCSG(P,N,m);
            LI.push_back(IP);
        }
    }
}
