#ifndef PERLIN_H
#define PERLIN_H

#include <vector>
#include <iostream>

using namespace  std;

// Code adapté de http://www.massal.net/article/raytrace/page3.html

class Perlin {
    public:
        Perlin();
        void perlin();
        double fade(double t);
        double lerp(double t, double a, double b);
        double grad(int hash, double x, double y, double z);
        double noise(double x, double y, double z);

        std::vector<int> p;
};

#endif // PERLIN_H
