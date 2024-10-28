#include <iostream>
#include <dlfcn.h>

int main() {

    // Load the CUDA library dynamically
    void *cuda_lib = dlopen("libcuda.so", RTLD_NOW);
    if (!cuda_lib) {
        std::cerr << "Failed to dlopen libcuda.so: " << dlerror() << std::endl;
        return EXIT_FAILURE;
    }

    return 0;
}
