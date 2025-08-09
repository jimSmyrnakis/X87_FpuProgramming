// X87_FPU_Programming.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include "X87_FPU_Programming.hpp"
double vol = 0.0;

void TestMeanStdev(void) {
    uint32_t n;
    double* arr = nullptr;
    double mean = 0.0;
    double stdev = 0.0;
    std::cout << "n : ";
    std::cin >> n;
    if (n == 0) {
        std::cerr << "STDEV can not have zero elements " << std::endl;
        exit(1);
    }
    arr = (double*)malloc(n * sizeof(double));
    for (int i = 0; i < n; i++) {
        std::cout << "a[" << i << "] : ";
        std::cin >> arr[i];


    }
    cacMeanStdev_C(arr, n, &mean, &stdev);
    std::cout << "mean : " << mean << " stdev : " << stdev <<std::endl;
    double mean2 = 0.0, stdev2 = 0.0;
    cacMeanStdev_ASM(arr, n, &mean2, &stdev2);
    std::cout << "mean2 : " <<  mean2 << " stdev2 : " << stdev2 << std::endl;

    float arr2[10] = {
        1,2,3,4,5,6,7,8,9,10
    };
    float minArr2, maxArr2;
    MinMaxF32Asm(arr2, 10, &minArr2, &maxArr2);
    std::cout << "Min : " << minArr2 << " Max : " << maxArr2 << std::endl;

}

void LeastSquares(void) {
    double x[] = { 1,2,3,4,5,6,7 };
    double y[] = { 1*2 + 1,2 * 2 + 1,3 * 2 + 1,4 * 2 + 1,5 * 2 + 1,6 * 2 + 1,7 * 2 + 1 };
    double m, b; 
    calcLeastSquaresCpp(x,y, 7, &m, &b);
    std::cout << "m : " << m << " b : " << b << std::endl;
    calcLeastSquares(x, y, 7, &m, &b);
    std::cout << "m : " << m << " b : " << b << std::endl;
}
int main()
{
    double f = 25.0;
    double c = 0.0;
    c = FahrenheitToCelsius(f);
    std::cout << "f : " << f << " , c : " << c << std::endl;
	CelsiusToFahrenheit(c, &f);
    std::cout << "f : " << f << " , c : " << c << std::endl;

    double r, surf = 0.0;
    std::cout << "r : ";
    std::cin >> r;
    bool status = SphereCompute(r, &surf, &vol);
    if (status)
        std::cout << "Surf : " << surf << " Volume : " << vol << std::endl;
    else
        std::cerr << "r makes result as Nan or i less equal to zero !!!";

    TestMeanStdev();

    double cartX = 5, cartY = 10 , polR , polA;
    CartesianToPolarCoords(cartX, cartY, &polR, &polA);
    std::cout << "Cart( x : " << cartX << " y : " << cartY << 
        ") ==> Polar( R : " << polR << " Ang = " << polA << "degrees ) " << std::endl;
    PolarToCartesianCoords(polR, polA, &cartX, &cartY);
    std::cout << "Cart( x : " << cartX << " y : " << cartY <<
        ") ==> Polar( R : " << polR << " Ang = " << polA << "degrees ) " << std::endl;

    LeastSquares();
}
bool cacMeanStdev_C(const double* arr, uint32_t n, double* mean, double* stdev) {
    if (n <= 1)
        return false;

    uint32_t i = 0;
    double sum = 0.0;
    for (i = 0; i < n; i++) {
        sum += arr[i];
    }
    (*mean) = sum / n;

    sum = 0.0;
    for (i = 0; i < n; i++) {
        double temp = arr[i] - (*mean);
        sum += temp * temp;
    }
    (*stdev) = sqrt(sum / (n - 1));
    return true;
}

bool calcLeastSquaresCpp(double* x , double* y, int32_t n, double* m, double* b) {
    if (n <= 0)
        return false;

    double sum_x = 0, sum_y = 0, sum_xy = 0, sum_xx = 0;

    for (int i = 0; i < n; i++) {
        sum_x += x[i];
        sum_y += y[i];
        sum_xy += (x[i] * y[i]);
        sum_xx += (x[i] * x[i]);
    }
    double denom = (n * sum_xx - (sum_x * sum_x));
    if (LsEpsilon >= fabs(denom))
        return false;

    (*m) = (n * sum_xy - sum_x * sum_y) / denom;
    (*b) = (sum_xx * sum_y - sum_x * sum_xy) / denom;

    return true;
}

//le > Open > Project and select the .sln file
