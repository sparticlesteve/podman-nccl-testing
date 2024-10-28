Tests of cuda libs in podman containers with NCCL plugin lib setup.

## Simple cuda program linked with cuda

Commands
```bash
# Compile
nvcc -lcuda -lcudart -o vector_add vector_add.cu

# Start container
WORKDIR=$PWD . ../setup_podman.sh
podman-hpc run -it ${CONT_PARAMS[@]} $CONT_NAME bash -l

# In container, run ldd
ldd vector_add
# Run the binary
./vector_add
```

Outputs looked good
```
root@dd09a6a2be88:/workspace# ldd vector_add
	linux-vdso.so.1 (0x00007ffc073c6000)
	libcuda.so.1 => /usr/local/cuda/compat/lib.real/libcuda.so.1 (0x00007f3317c80000)
	libcudart.so.12 => /usr/local/cuda/targets/x86_64-linux/lib/libcudart.so.12 (0x00007f3317800000)
	librt.so.1 => /lib/x86_64-linux-gnu/librt.so.1 (0x00007f3317c6e000)
	libpthread.so.0 => /lib/x86_64-linux-gnu/libpthread.so.0 (0x00007f3317c69000)
	libdl.so.2 => /lib/x86_64-linux-gnu/libdl.so.2 (0x00007f3317c62000)
	libstdc++.so.6 => /lib/x86_64-linux-gnu/libstdc++.so.6 (0x00007f33175d4000)
	libm.so.6 => /lib/x86_64-linux-gnu/libm.so.6 (0x00007f3317b7b000)
	libgcc_s.so.1 => /lib/x86_64-linux-gnu/libgcc_s.so.1 (0x00007f3317b5b000)
	libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f33173ab000)
	/lib64/ld-linux-x86-64.so.2 (0x00007f33197b5000)

root@dd09a6a2be88:/workspace# ./vector_add
Result: 11 22 33 44 55
```

## Simple c++ program using dlopen for libcuda

Commands
```bash
# Compile baremetal
g++ dlopen.cpp -o dlopen -ldl

# Start container
WORKDIR=$PWD . ../setup_podman.sh
podman-hpc run -it ${CONT_PARAMS[@]} $CONT_NAME bash -l

# Run test
ldd dlopen
./dlopen
```

Runs successfully. If I run in strace, I see it loading the compat lib at
`/usr/local/cuda/compat/lib.real/libcuda.so`
