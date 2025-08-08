#pragma once

extern "C" {
	void CelsiusToFahrenheit(double celsius , double* fahrenheit);
	double FahrenheitToCelsius(double fahrenheit);

	bool SphereCompute(double r, double* surf, double* vol);
	bool cacMeanStdev_ASM(const double* arr, uint32_t n, double* mean, double* stdev);
	bool MinMaxF32Asm(const float* arr, uint32_t n, float* min, float* max);

	void CartesianToPolarCoords(double x, double y, double* radius, double* angle);
	void PolarToCartesianCoords(double radius, double angle, double* x, double* y);
}

bool cacMeanStdev_C(const double* arr, uint32_t n, double* mean, double* stdev);