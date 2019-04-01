#include "geometry.h"
#include <sstream>
#include <string>
#include <fstream>

/**
 *  Constructeur qui va charger le fichier et générer la boîte englobante.
 */
Geometry::Geometry(const char* obj, Material material) : Object(material) {
    ifstream f(obj);
    int curGroup = -1;
    string line_;

    while(getline(f, line_)) {
        char line[255];
        strcpy(line, line_.c_str());

        if (line[0]=='u' && line[1]=='s') {
            curGroup++;
        }
        if (line[0]=='v' && line[1]==' ') {
            double t0, t2, t1;
            sscanf(line, "v %lf %lf %lf\n", &t0, &t2, &t1); // girl
            t1 -= 1.2;
            Vector vec(t0, t1, t2);
            vertices.push_back(vec*30);
        }
        if (line[0]=='v' && line[1]=='n') {
            double t0, t2, t1;
            sscanf(line, "vn %lf %lf %lf\n", &t0, &t2, &t1); //girl
            Vector vec(t0, t1, t2);
            normals.push_back(vec);
        }
        if (line[0]=='v' && line[1]=='t') {
            double t0, t1;
            sscanf(line, "vt %lf %lf\n", &t0, &t1);
            Vector vec(t0, t1);
            uvs.push_back(vec);
        }
        if (line[0]=='f') {
            int i0, i1, i2;
            int j0, j1, j2;
            int k0, k1, k2;
            faceGroup.push_back(curGroup);
            int nn = sscanf(line, "f %u/%u/%u %u/%u/%u %u/%u/%u\n", &i0, &j0, &k0, &i1, &j1, &k1, &i2, &j2, &k2);
            if (nn==9) {
                faces.push_back(i0-1);
                faces.push_back(i1-1);
                faces.push_back(i2-1);
                uvIds.push_back(j0-1);
                uvIds.push_back(j1-1);
                uvIds.push_back(j2-1);
                normalIds.push_back(k0-1);
                normalIds.push_back(k1-1);
                normalIds.push_back(k2-1);
            } else {
                int i3, j3;
                nn = sscanf(line, "f %u/%u %u/%u %u/%u %u/%u\n", &i0, &j0, &i1, &j1, &i2, &j2, &i3, &j3); //le dragon contient des quads
                if (nn == 8) {
                    faces.push_back(i0-1);
                    faces.push_back(i1-1);
                    faces.push_back(i2-1);
                    faces.push_back(i0-1);
                    faces.push_back(i2-1);
                    faces.push_back(i3-1);
                    faceGroup.push_back(curGroup);
                    uvIds.push_back(j0-1);
                    uvIds.push_back(j1-1);
                    uvIds.push_back(j2-1);
                    uvIds.push_back(j0-1);
                    uvIds.push_back(j2-1);
                    uvIds.push_back(j3-1);
                } else {
                    nn = sscanf(line, "f %u/%u %u/%u %u/%u\n", &i0, &j0, &i1, &j1, &i2, &j2);
                    faces.push_back(i0-1);
                    faces.push_back(i1-1);
                    faces.push_back(i2-1);
                    uvIds.push_back(j0-1);
                    uvIds.push_back(j1-1);
                    uvIds.push_back(j2-1);
                }
            }
        }
    }
    f.close();
    build_bbox();
}

/**
 *  Construction de la boîte englobante en regardant tous les sommets
 *  du maillage un à un.
 */
void Geometry::build_bbox(){
    // On initialiser avec des valeurs très élevées.
    bbox.bmin = Vector(1E9, 1E9, 1E9);
    bbox.bmax = Vector(-1E9, -1E9, -1E9);
    double bmin0 = 1E9, bmin1 = 1E9, bmin2 = 1E9, bmax0 = -1E9, bmax1 = -1E9, bmax2 = -1E9;

    // On parcours tous les sommets et on met à jour les valeurs
    for (unsigned int i = 0; i < vertices.size(); i++) {
        bmin0 = std::min(bmin0, vertices[i][0]);
        bmin1 = std::min(bmin1, vertices[i][1]);
        bmin2 = std::min(bmin2, vertices[i][2]);

        bmax0 = std::max(bmax0, vertices[i][0]);
        bmax1 = std::max(bmax1, vertices[i][1]);
        bmax2 = std::max(bmax2, vertices[i][2]);
    }

    // Construction des points extrêmes à partir des valeurs calculées.
    bbox.bmin = Vector(bmin0, bmin1, bmin2);
    bbox.bmax = Vector(bmax0, bmax1, bmax2);

    // Information de l'utilisateur
    cout << bbox.bmin[0] << " " << bbox.bmin[1] << " " << bbox.bmin[2] << " " << bbox.bmax[0] << " " << bbox.bmax[1] << " " << bbox.bmax[1]<< endl;
}

/**
 *  Intersection d'un triangle par un rayon.
 *
 *  Params :
 *      - r : le rayon
 *      - id : l'id du triangle pour lequel on veut l'information
 *      - N : la normale au triangle.
 *      - t : la position sur le rayon de l'intersection
 *
 *  Return :
 *      - true si intersection, false sinon.
 */
bool Geometry::intersect(const Ray r, int id, Vector &N, double &t) const{
    // Les sommets du triangle
    const Vector &A = vertices[faces[id*3]];
    const Vector &B = vertices[faces[id*3+1]];
    const Vector &C = vertices[faces[id*3+2]];

    // Intersection avec le plan (ABC)
    N = (C-A).cross(B-A).getNormalize();
    t = N.dot(A-r.C) / N.dot(r.u);
    if(t<=0){
        return false;
    }

    // Résolution du système pour savoir si P est dans le triangle
    Vector P = r.C + t*r.u;

    Vector u = B-A;
    Vector v = C-A;
    Vector w = P-A;

    double uu = u.dot(u);
    double uv = u.dot(v);
    double vv = v.dot(v);
    double uw = u.dot(w);
    double vw = v.dot(w);

    double detM = uu*vv - uv*uv;
    double alpha = (uw*vv - vw*uv)/detM;
    double beta =(uu*vw - uv*uw)/detM;

    // Si P vérifie les trois conditions, c'est gagné!
    if(alpha>0 && beta>0 && alpha+beta<1){
        return true;
    }

    return false;
}

/**
 *  Intersection entre le maillage est un rayon. Les points d'intersection sont
 *  stockés dans LI. Pour se faire, on regarde si la boîte englobante est interceptée
 *  puis le cas échéant pour chaque triangle.
 *
 *  Params :
 *      - r : le rayon
 *      - LI : la liste des points d'intersection
 */
void Geometry::intersect(const Ray & r, std::vector<IntersectionPointCSG *> & LI) const {
    double t = 1E9;
    Vector N;
    Material M;
    Vector P;

    bool has_intersection = false;

    // Test de la boîte englobante.
    if(!bbox.intersect(r)){
        return;
    }

    // Boucle sur tous les triangles
    for(unsigned int i=0; i<faces.size()/3; i++){
        Vector currentN;
        double currentT;

        // On garde le triangle le plus proche du point de départ du rayon
        if(intersect(r, i, currentN, currentT)){
            has_intersection = true;
            if(currentT < t){
                t = currentT;
                N = currentN;
                M = material;
            }
        }
    }

    // Le meilleur point est enregistré pour la suite
    P = r.C + t*r.u;
    IntersectionPointCSG* IP = new IntersectionPointCSG(P, N, M);
    LI.push_back(IP);
}
