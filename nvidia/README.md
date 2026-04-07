## ncu

NCU is by default disabled for non admin users. To enable it's use, follow https://developer.nvidia.com/nvidia-development-tools-solutions-err_nvgpuctrperm-permission-issue-performance-counters.

After following the instructions and rebooting, the CUDA/OpenACC programs may start to fail with 

```bash
Failing in Thread:0
Accelerator Fatal Error: call to cuInit returned error 999
(CUDA_ERROR_UNKNOWN): Unknown
```

To fix this (Rocky Linux 9), run

```bash
sudo rmmod nvidia_uvm
sudo modprobe nvidia_uvm
```
