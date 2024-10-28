# Source me
# Environment
WORKDIR=${WORKDIR:-$SCRATCH/podman-nccl-tests/run_tests} #_$SLURM_JOB_ID
CONT_NAME=nersc/pytorch:24.06.01
NCCL_NET_PATH=/global/common/software/nersc9/nccl/2.19/plugin
LIBFABRIC_PATH=/opt/cray/libfabric/1.20.1/lib64
export FI_MR_CACHE_MONITOR=userfaultfd
export NCCL_DEBUG=INFO
export FI_LOG_LEVEL=debug

export FI_CXI_DISABLE_HOST_REGISTER=1
export NCCL_CROSS_NIC=1
export NCCL_SOCKET_IFNAME=hsn
export NCCL_NET_GDR_LEVEL=PHB
export NCCL_NET="AWS Libfabric"

# Container settings
CONT_PARAMS=(
    --rm --gpu
    #--openmpi-pmi2
    --env NCCL_* --env FI_*
    -v $NCCL_NET_PATH:/opt/nccl-ofi
    -v $WORKDIR:/workspace
    -w /workspace
)

# Mount the NCCL plugin's system dependencies
CONT_PARAMS+=(
    --mount type=glob,src=$LIBFABRIC_PATH/libfabric.so\*,dst=/usr/lib64/,ro=true
    --mount type=glob,src=/opt/cray/xpmem/default/lib64/libxpmem.so\*,dst=/usr/lib64/,ro=true
    --mount type=glob,src=/usr/lib64/libcxi.so\*,ro=true
    --mount type=glob,src=/usr/lib64/libjson-c.so\*,ro=true
    --mount type=glob,src=/usr/lib64/libatomic.so\*,ro=true
    --mount type=glob,src=/usr/lib64/libldap_r-2.4.so\*,ro=true
    --mount type=glob,src=/usr/lib64/liblber-2.4.so\*,ro=true
    --mount type=glob,src=/usr/lib64/libsasl2.so\*,ro=true
)
