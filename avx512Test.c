#include <immintrin.h>
#include <stdio.h>

//cc -mavx512f -o avx512Test avx512Test.c

int main() {

  /* Initialize the two argument vectors */
  __m512 evens = _mm512_set_ps(2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0, 18.0, 20.0, 22.0, 24.0, 26.0, 28.0, 30.0, 32.0);
  __m512 odds = _mm512_set_ps(1.0, 3.0, 5.0, 7.0, 9.0, 11.0, 13.0, 15.0, 17.0, 19.0, 21.0, 23.0, 25.0, 27.0, 29.0, 31.0);

  /* Compute the difference between the two vectors */
  __m512 result = _mm512_sub_ps(evens, odds);

  float* f = (float*)&result;
  printf("%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n",
    f[0], f[1], f[2], f[3], f[4], f[5], f[6], f[7], f[8], f[9], f[10], f[11], f[12], f[13], f[14], f[15]);

  result = _mm512_add_ps(evens, odds);

  /* Display the elements of the result vector */
  printf("%f %f %f %f %f %f %f %f %f %f %f %f %f %f %f %f\n",
    f[0], f[1], f[2], f[3], f[4], f[5], f[6], f[7], f[8], f[9], f[10], f[11], f[12], f[13], f[14], f[15]);

  return 0;
}