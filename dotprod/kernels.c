//
#if defined(__INTEL_COMPILER)
#include <mkl.h>
#else
#include <cblas.h>
#endif

//
#include "types.h"

//Baseline - naive implementation
f64 dotprod_base(f64 *restrict a, f64 *restrict b, u64 n)
{
  double d = 0.0;
  
  for (u64 i = 0; i < n; i++)
    d += a[i] * b[i];

  return d;
}

//
f64 dotprod_unroll(f64 *restrict a, f64 *restrict b, u64 n)
{

#define UNROLL4 4
  
  double d = 0.0;
  
  for (u64 i = 0; i < n; i+=UNROLL4)
    {
      d += a[i] * b[i];
      d += a[i+1] * b[i+1];
      d += a[i+2] * b[i+2];
      d += a[i+3] * b[i+3];
    }
    //Manage the leftovers
		for (u64 i = (n - (n & UNROLL4-1)); i < n; i++)
			d += a[i] * b[i];
  return d;
}

void dotprod_cblas(f64 *restrict a, f64 *restrict b, u64 n)
{
  cblas_ddot(n, a, 1, b, 1);
}