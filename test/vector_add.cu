#include <stdio.h>

#define CUDA_CALL(call)                                                     \
    do {                                                                    \
        cudaError_t err = call;                                             \
        if (err != cudaSuccess) {                                           \
            fprintf(stderr, "CUDA error in file '%s' in line %i: %s.\n",    \
                    __FILE__, __LINE__, cudaGetErrorString(err));           \
            exit(EXIT_FAILURE);                                             \
        }                                                                   \
    } while(0)

__global__ void vectorAdd(int *a, int *b, int *c, int n) {
    int index = threadIdx.x;
    if (index < n) {
        c[index] = a[index] + b[index];
    }
}

int main() {
    int n = 5;
    int h_a[] = {1, 2, 3, 4, 5};
    int h_b[] = {10, 20, 30, 40, 50};
    int h_c[n];

    int *d_a, *d_b, *d_c;

    // Allocate device memory and check for errors
    CUDA_CALL(cudaMalloc((void**)&d_a, n * sizeof(int)));
    CUDA_CALL(cudaMalloc((void**)&d_b, n * sizeof(int)));
    CUDA_CALL(cudaMalloc((void**)&d_c, n * sizeof(int)));

    // Copy host memory to device memory and check for errors
    CUDA_CALL(cudaMemcpy(d_a, h_a, n * sizeof(int), cudaMemcpyHostToDevice));
    CUDA_CALL(cudaMemcpy(d_b, h_b, n * sizeof(int), cudaMemcpyHostToDevice));

    // Launch kernel and check for errors
    vectorAdd<<<1, n>>>(d_a, d_b, d_c, n);
    CUDA_CALL(cudaGetLastError()); // Check for any kernel launch errors

    // Copy result from device to host and check for errors
    CUDA_CALL(cudaMemcpy(h_c, d_c, n * sizeof(int), cudaMemcpyDeviceToHost));

    // Print the results
    printf("Result: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", h_c[i]);
    }
    printf("\n");

    // Free device memory and check for errors
    CUDA_CALL(cudaFree(d_a));
    CUDA_CALL(cudaFree(d_b));
    CUDA_CALL(cudaFree(d_c));

    return 0;
}
