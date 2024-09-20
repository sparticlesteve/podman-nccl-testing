#!/bin/bash
#SBATCH -J shifter-nccl-tests
#SBATCH -C gpu
#SBATCH -N 1
#SBATCH -t 10
#SBATCH --ntasks-per-node 4
#SBATCH --cpus-per-task 32
#SBATCH --gpus-per-node 4
#SBATCH --image=nersc/pytorch:24.06.01
#SBATCH --module=gpu,nccl-plugin
#SBATCH -o logs/%x-%j.out

set -x

# Environment
WORKDIR=$SCRATCH/podman-nccl-tests/run_shifter #_$SLURM_JOB_ID
export NCCL_DEBUG=INFO
export FI_LOG_LEVEL=debug

# Run the build
if [ ! -d $WORKDIR/nccl-tests ]; then
    mkdir -p $WORKDIR
    git clone https://github.com/NVIDIA/nccl-tests.git $WORKDIR/nccl-tests
    shifter --workdir=$WORKDIR/nccl-tests make MPI=1 MPI_HOME=/usr/local/mpi
fi

# Run the test
srun --mpi=pmi2 shifter \
    $WORKDIR/nccl-tests/build/all_reduce_perf -b 8 -e 4G -f 2
    #strace -o $WORKDIR/strace.out
