#Manna: An Accelerator for Memory-Augmented Neural Networks

##Abstract

Manna, a specialized hardware inference accelerator for MANNs. 

Manna is a memory-centric design that focuses on maximizing performance in an extremely low FLOPS/Byte context.

(i) investing most of the die area and power in highly banked on-chip memories that provide ample bandwidth rather than large matrix-multiply units that would be underutilized due to the low reuse 
(ii) a hardware-assisted transpose mechanism for accommodating the diverse memory access patterns observed in MANNs, 
(iii) a specialized processing tile that is equipped to handle the nearly-equal mix of MAC and non-MAC computations present in MANNs
(iv) methods to map MANNs to Manna that minimize data movement while fully exploiting the little reuse present


##Introduction

one-shot learning (the ability to learn from one or very few examples),

• We provide a detailed investigation of the computational characteristics of MANNs, a promising emerging class of DNNs.
• We propose Manna, an end-to-end, CMOS-based accelerator that is able to efficiently perform all kernels used in memory-augmented neural networks. We provision Manna with a memory-to-compute resource allocation reflective of the low FLOPs/Byte inherent to MANNs.
• We implement a hardware-based transpose mechanism to efficiently execute both vector-matrix and vector-transposed matrix multiplications.
• We provision Manna with specialized units (called eMACs), which are designed for the unique mix of operations beyond just MACs that are used in MANNs.
• We develop an ISA and compiler that map MANNs to Manna so as to minimize data transfers and maximize the utilization of on-chip bandwidth.
• We develop an architectural simulator and synthesize RTL implementations of key components in order to demonstrate the benefits of Manna. Our experiments indicate that Manna achieves average speedups of 39x (24x) and average energy improvements of 122x (86x) over an NVIDIA 1080-Ti (2080-Ti) GPU with a Pascal (Turing) architecture.


## MANNA

The building blocks of Manna are DiffMem tiles that execute the MANN-specific kernels (i.e., read and write head operations, key similarity, addressing, soft read, and soft write) which control the external differentiable memory (hence, the name DiffMem tiles). The entire external memory is partitioned and distributed across the DiffMem tiles. The DiffMem tiles are designed to cater to the low FLOPS/Byte ratio observed in MANN kernels. 

![](./pic/manna-1.png)

 MANN kernels, which exhibit a higher share of non-MAC element-wise operations than the traditional MAC-centric DNN workloads.


