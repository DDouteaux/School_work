#ifndef VECTOR_H
#define VECTOR_H

/**
 * Toutes les méthodes non inline sont documentées dans le .cpp.
 */
class Vector {
public:
    // Constructeurs
    Vector(double x=0, double y=0, double z=0);
    Vector(const Vector& b);

    // Opérateurs
    double operator[](int i) const;
    double dot(const Vector& b) const;
    double dot(Vector& b);
    double squaredNorm();
    void normalize();
    Vector getNormalize();
    void orthogonalSystem(Vector &tangent1, Vector &tangent2) const;

    // Manipulations optiques
    Vector reflect(const Vector& N) const;
    Vector refract(const Vector& N, double n1, double n2, bool &is_refracted) const;

    // Fonctions pour les BRDF
    void randomCos(const Vector& N);
    Vector cross(const Vector& b) const;

    // Attributs
    double xyz[3];                      // Coordonnées du vecteur
};

/**
 *  Sur-définition des différents opérateurs arithmétiques pour les
 *  éléments de type Vector selon les besoins de notre code.
 */
inline Vector operator+(const Vector &a, const Vector &b) {
    return Vector(a[0]+b[0], a[1]+b[1], a[2]+b[2]);
}

inline Vector operator-(const Vector& a, const Vector& b) {
    return Vector(a[0]-b[0], a[1]-b[1], a[2]-b[2]);
}

inline Vector operator-(const Vector& a) {
    return Vector(-a[0], -a[1], -a[2]);
}

inline Vector operator*(const double a, const Vector& b) {
    return Vector(a*b[0], a*b[1], a*b[2]);
}

inline Vector operator*(const Vector& a, const Vector& b) {
    return Vector(a[0]*b[0], a[1]*b[1], a[2]*b[2]);
}

inline Vector operator*(const Vector& a, const double b) {
    return Vector(a[0]*b, a[1]*b, a[2]*b);
}

#endif // VECTOR_H
