#ifndef HELPERS_H
#define HELPERS_H
#include "vector.h"
#include <iostream>
#include <stdio.h>
#include <iomanip>
#include <cmath>
#include <ctime>
#include <stdlib.h>
#include <iostream>
#include <sstream>

using namespace std;

/**
  * Définition de la constante PI
  */
#ifndef PI
    #define PI (3.14159265358979323846)
#endif

/**
 *  Définition du produit scalaire entre deux vecteurs sans être appelé
 *  depuis un vecteur.
 *
 *  Params :
 *      - a : le premier terme du produit scalaire.
 *      - b : le second terme du produit scalaire.
 *
 *  Return :
 *      - Un double avec la valeur de ce produit scalaire.
 */
inline double dot (const Vector& a, const Vector&b) {
    return a[0]*b[0]+a[1]*b[1]+a[2]*b[2];
}

/**
 *  Méthode utilitaire pour enregistrer une image au format BMP.
 *
 *  Params :
 *      - w : la largeur de l'image.
 *      - h : la hauteur de l'image.
 *      - img : un tableau de caractères qui représente l'image.
 *
 *  Info :
 *      - Cette méthode est adapatée d'un code disponible sur Stack Overflow.
 */
inline void saveBMP (int w, int h, const unsigned char * img) {
    FILE *f;
    int filesize = 54 + 3*w*h;  //w is your image width, h is image height, both int

    unsigned char bmpfileheader[14] = {'B','M', 0,0,0,0, 0,0, 0,0, 54,0,0,0};
    unsigned char bmpinfoheader[40] = {40,0,0,0, 0,0,0,0, 0,0,0,0, 1,0, 24,0};
    unsigned char bmppad[3] = {0,0,0};

    bmpfileheader[ 2] = (unsigned char)(filesize    );
    bmpfileheader[ 3] = (unsigned char)(filesize>> 8);
    bmpfileheader[ 4] = (unsigned char)(filesize>>16);
    bmpfileheader[ 5] = (unsigned char)(filesize>>24);

    bmpinfoheader[ 4] = (unsigned char)(       w    );
    bmpinfoheader[ 5] = (unsigned char)(       w>> 8);
    bmpinfoheader[ 6] = (unsigned char)(       w>>16);
    bmpinfoheader[ 7] = (unsigned char)(       w>>24);
    bmpinfoheader[ 8] = (unsigned char)(       h    );
    bmpinfoheader[ 9] = (unsigned char)(       h>> 8);
    bmpinfoheader[10] = (unsigned char)(       h>>16);
    bmpinfoheader[11] = (unsigned char)(       h>>24);

    f = fopen("img.bmp","wb");
    fwrite(bmpfileheader,1,14,f);
    fwrite(bmpinfoheader,1,40,f);
    for(int i=0; i<h; i++)
    {
        fwrite(img+(w*(h-i-1)*3),3,w,f);
        fwrite(bmppad,1,(4-(w*3)%4)%4,f);
    }
    fclose(f);
}

inline void printProgress(int x, int lines=0){
    stringstream msg;
    string s;
    s="[";
    for (int i=1;i<=(100/2);i++){
        if (i<=(x/2) || x==100)
            s+="=";
        else if (i==(x/2))
            s+=">";
        else
            s+=" ";
    }

    s+="]";
    msg << "\r" << setw(-40) << s << " " << x << "% completed.";
    if (lines > 0) {
        msg << "(" << lines << ")";
    }
    msg << flush;
    cout << msg.str();
}

/**
  * L'ensemble de méthodes qui suit a pour but de faciliter les
  * calculs qui utilisent la méthode de Monte Carlo.
  */

inline double pdf(double x, double mu, double sigma){
    return exp(-pow(x-mu,2)/(2*pow(sigma,2))/(sigma*sqrt(2*PI)));
}

#endif // HELPERS_H
