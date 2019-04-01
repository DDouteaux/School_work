#include <iostream>
#include <cmath>
#include <vector>
#include <stdlib.h>
#include <cstring>
#include <random>
#include <ctime>

#include "vector.h"
#include "ray.h"
#include "scene.h"
#include "helpers.h"
#include "material.h"
#include "object.h"
#include "intersectionpointcsg.h"
#include "box.h"
#include "intersection.h"
#include "union.h"
#include "cylinder.h"
#include "torus.h"
#include "geometry.h"
#include "boundingbox.h"
#include "plan.h"
#include "texture.h"
#include "squarestexture.h"
#include "perlin.h"
#include "perlintexture.h"
#include "marbletexture.h"
#include "woodtexture.h"
#include "substraction.h"

using namespace std;

int main()
{
    /**
     *  Paramètres génériques pour le raytracer.
     *      - H : Hauteur de l'image
     *      - W : Largeur de l'image
     */
    //int H = 1024;
    //int W = 1024;
    int H = 200;
    int W = 200;

    /**
     *  Représentation de l'image par un vecteur de taille 3*W*H.
     *  Le "3" provient des trois canaux R, G et B.
     */
    unsigned char *img = NULL;
    if (img) {
        free(img);
    }
    img = (unsigned char *)malloc(3*W*H);
    memset(img,0,sizeof(img));

    /**
     *  Objets génériques de la scène :
     *      - L : la position de la lumière ponctuelle.
     *      - C : la position de la caméra.
     *      - fov : l'angle d'ouverture de la caméra.
     *      - sphere_i : les différentes sphère de la scène.
     *      - mur_i : des sphères géantes qui vont représenter les murs.
     *      - scene : la scène à illustrer.
     */
    Vector C(0,0,55);
    double fov = 60*3.14/180;
    //Vector red(.04, .04, .96);
    Vector red(0, 0, .4);
    Vector blue(.18, .017, 0);
    Vector green(.1, .83, .2);
    Vector yellow(0, .5, 1.);
    Vector white(1., 1., 1.);
    Vector black(0., 0., 0.);
    Vector skyBlue(.48, .17, 0);
    Vector brownLight(0,.32,.61);
    Vector brown(0,.12,.27);
    SquaresTexture chess(skyBlue, white, 2);
    MarbleTexture marble = MarbleTexture(white, black, 15, 40);
    WoodTexture wood = WoodTexture(brownLight, brown, 15, 5); // 24 5
    Material whiteDiffuse(white, true, false, false, false, .7);
    Material blueDiffuse(blue, true, false, false, false, .7);
    Material skyblueDiffuse(skyBlue, true, false, false, false, .7);
    Material redDiffuse(red, true, false, false, false, .7);
    Material yellowDiffuse(yellow, true, false, false, false, .7);
    Material greenDiffuse(green, true, false, false, false, .7);
    Material brownDiffuse(brown, true, false, false, false, .7);
    Material specular(white, false, true, false, false);
    Material glass(white, false, false, true, false, 1.8);
    Material whiteLight(white, true, false, false, false, 1, 1, 1000);
    Material fresnel(white, false, false, false, true, 1.4);
    Material chessSurface(white, true, false, false, false, .7, 1, 1, &chess);
    Material marbleSurface(white, true, false, false, false, .7, 1, 1, &marble);
    Material woodSurface(brown, true, false, false, false, .7, 1, 1, &wood);
    Sphere sphere(Vector(0,-1,25), 7, marbleSurface);
    Sphere sphere1(Vector(-7,0,25), 7, marbleSurface);
    Sphere sphere2(Vector(3,0,0), 7, woodSurface);
    Sphere sphere3(Vector(13,0,-25), 7, whiteDiffuse);
    Sphere mur1(Vector(0,-1000,0), 992, skyblueDiffuse);
    Sphere mur2(Vector(0,0,-1000), 980, greenDiffuse);
    Sphere mur3(Vector(0,1000,0), 980, redDiffuse);
    Sphere mur4(Vector(1000,0,0), 975, yellowDiffuse);
    Sphere mur5(Vector(-1000,0,0), 975, yellowDiffuse);
    Sphere mur6(Vector(0,0,1000), 930, whiteDiffuse);
    Plan plan1(Vector(0,-8,0), Vector(0,1,0), redDiffuse);
    Plan plan2(Vector(0,0,70), Vector(0,0,-1), greenDiffuse);
    Plan plan3(Vector(0,20,0), Vector(0,-1,0), skyblueDiffuse);
    Plan plan4(Vector(25,0,0), Vector(-1,0,0), yellowDiffuse);
    Plan plan5(Vector(-25,0,0), Vector(1,0,0), yellowDiffuse);
    Plan plan6(Vector(0,0,-20), Vector(0,0,1), whiteDiffuse);
    Box box(Vector(0,0,20), Vector(0,0,1), Vector(0,1.5,1), Vector(1,1,1)*10, marbleSurface);
    Box box2(Vector(0,0,30), Vector(1,0,0), Vector(0,1,0), Vector(1,1,1)*8, whiteDiffuse);
    Box boxWall(Vector(0,-7.5,0), Vector(1,0,0), Vector(0,1,0), Vector(200,1,200)*.5, specular);
    Torus torus(Vector(0,5,20), Vector(0,1,1).getNormalize(), 10, 3, woodSurface);

    Cylinder cylinderUnion(Vector(0,-8,20), Vector(0,20,20), 2, woodSurface);
    Sphere sphereUnion2(Vector(0,25,20), 7, greenDiffuse);
    Sphere sphereUnion(Vector(0,-2,25), 6.7, skyblueDiffuse);

    Sphere spheretest1(Vector(0,15,10), 1, greenDiffuse);
    Sphere spheretest2(Vector(10,15,10), 1, greenDiffuse);
    Sphere spheretest3(Vector(0,5,10), 1, greenDiffuse);
    Sphere spheretest4(Vector(10,5,10), 1, greenDiffuse);

    Sphere spheretest5(Vector(0,15,20), 1, greenDiffuse);
    Sphere spheretest6(Vector(10,15,20), 1, greenDiffuse);
    Sphere spheretest7(Vector(0,5,20), 1, greenDiffuse);
    Sphere spheretest8(Vector(10,5,20), 1, greenDiffuse);
    //Sphere spheretest3(Vector(0,2,40), 10, skyblueDiffuse);
    Plan plan(Vector(0,0,10), Vector(0,0,1), greenDiffuse);
    Box boxUnion(Vector(0,2,30), Vector(1,1,0), Vector(2,1,1), Vector(3,2,1)*10, redDiffuse);
    Box boxUnion2(Vector(0,-2,25), Vector(0,0,-1), Vector(0,1,0), Vector(1,1,1)*10, woodSurface);
    Cylinder cylinder1(Vector(0,-2,19), Vector(0,-2,31), 4, brownDiffuse);
    Cylinder cylinder2(Vector(0,-8,25), Vector(0,4,25), 4, brownDiffuse);
    Cylinder cylinder3(Vector(-6,-2,25), Vector(6,-2,25), 4, brownDiffuse);
    Union tree(&cylinderUnion, &sphereUnion2, whiteDiffuse, false);
    Union union1(&cylinder1, &cylinder2, whiteDiffuse, true);
    Union union2(&union1, &cylinder3, whiteDiffuse, true);
    Union objectUnion(&cylinderUnion, &sphereUnion2, whiteDiffuse, false);
    Intersection objectIntersection(&boxUnion2, &sphereUnion, whiteDiffuse, false);
    Substraction objectSubstraction2(&sphereUnion, &boxUnion2, whiteDiffuse, false);
    Substraction objectSubstraction(&objectIntersection, &union2, woodSurface, true);
    Geometry girl("girl.obj", whiteDiffuse);
    Sphere luxSphere(Vector(-10,15,55), 3, whiteLight);
    Scene scene(skyBlue);
    scene.L = Vector(-10,15,55);
    scene.objects.push_back(&plan1);
    scene.objects.push_back(&plan2);
    scene.objects.push_back(&plan3);
    scene.objects.push_back(&plan4);
    scene.objects.push_back(&plan5);
    scene.objects.push_back(&plan6);
    //scene.addLuxSphere(&luxSphere);
    scene.objects.push_back(&sphere);

    /**
      *  La boucle principale de calcul de l'image où on passe de
      *  pixels en pixels pour le calcul.
      */
    int linesDone = 0;
    int totalPartition = 1;

    int rayPerPixel = 50;
    default_random_engine engine;
    uniform_real_distribution<double> distrib(0,1);

    clock_t begin = clock();
#pragma omp parallel for
    for (int i=0; i<H; i++) {
        printProgress(100*linesDone++*totalPartition/H, linesDone);
        for (int j=0; j <W; j++) {
            Vector sumIntensities;

            for(int k=0; k<rayPerPixel; k++){
                // La direction du rayon qui est lancé, on la suppose normalisée. r1 et r2 permettent de
                // légèrement perturber le point de départ du rayon afin d'obtenir des transitions moins abruptes.
                double r1 = 0;distrib(engine)-.5;
                double r2 = 0;distrib(engine)-.5;
                Vector u (j+r1-W/2.+1/2., H-i+r2-H/2.+1/2., -W/(2.*tan(fov/2.)));
                u.normalize();

                sumIntensities = sumIntensities + scene.getColor(Ray(C, u), 5, 5);
            }

            Vector finalIntensity = sumIntensities*(1./rayPerPixel);
            img[(i*W+j)*3]=std::min(255., 255*pow(finalIntensity[0], 1./2.2));
            img[(i*W+j)*3+1]=std::min(255., 255*pow(finalIntensity[1], 1./2.2));
            img[(i*W+j)*3+2]=std::min(255., 255*pow(finalIntensity[2], 1./2.2));
        }
    }
    clock_t end = clock();
    double elapsed_secs = double(end - begin) / CLOCKS_PER_SEC;
    cout << endl << "Time elapsed : " << elapsed_secs << endl;
    saveBMP(W, H, img);
    return 0;
}

