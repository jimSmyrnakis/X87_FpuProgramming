#pragma once

extern "C" {
	void CelsiusToFahrenheit(double celsius , double* fahrenheit);
	double FahrenheitToCelsius(double fahrenheit);

	bool SphereCompute(double r, double* surf, double* vol);
	bool cacMeanStdev_ASM(const double* arr, uint32_t n, double* mean, double* stdev)
}