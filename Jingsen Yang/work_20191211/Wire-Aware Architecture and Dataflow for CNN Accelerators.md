#Wire-Aware Architecture and Dataflow for CNN Accelerators


##Abstract

In this work, we design a new wire-aware CNN accelerator, WAX, that employs a deep and distributed memory hierarchy, thus enabling data movement over short wires in the common case.

An array of computational units, each with a small set of registers, is placed adjacent to a subarray of a large cache to form a single tile. Shift operations among these registers allow for high reuse with little wire traversal overhead.


##Introduction

In this paper, we re-visit the design of PEs and memory hierarchy for CNN accelerators, with a focus on reducing these long and frequently traversed wire lengths.

It is well known that data movement is orders of magnitude more expensive than the cost of compute.

We create a new wire aware accelerator WAX, that implements a deep and distributed memory hierarchy to favor short wires.

We implement an array of PEs beside each cache subarray. Each PE is assigned less than a handful of registers. The registers have shift capabilities to implement an efficient version of systolic dataflow. Each PE therefore uses minimal wiring to access its few registers, its adjacent register, and a small (few-KB) cache subarray. Data movement within this basic WAX tile has thus been kept to a minimum. 


##Background

While a large scratchpad or register file in an Eyeriss PE promotes a high degree of reuse, it also increases the cost of every scratchpad/register access, it increases the distance to an adjacent PE, and it increases the distance to the global buffer. 

Our hypothesis is that less storage per PE helps shorten distances and reduce data movement energy.

![](./pic/wax-1.png)

For larger register files, the overall energy increases due to two factors: (i) the increasing number of rows leads to more complex read and write decoders, (ii) more flip-flops share the same signals (such as the write or address signals), leading to higher load and larger parasitics.

To the greatest extent possible, we want to (i) replace 54 KB buffer accesses with 6 KB buffer accesses (1.4× energy reduction), (ii) replace 224-byte scratchpad access with single register access (46× energy reduction), and (iii) replace 12- and 24-entry register file access with single register access (28× and 51× energy reduction).


the clock tree accounts for 33% of total power in Eyeriss.  A wire-aware accelerator must therefore also consider the impact on area and the clock distribution network. This is primarily achieved by eliminating the large register files per PE.


##Wax

designing a new memory hierarchy that is deeper and distributed, and that achieves high data reuse while requiring low storage per PE.

![](./pic/wax-2.png)

Conventional large caches are typically partitioned into several subarrays (a few KB in size), connected with an H-Tree network. We propose placing a neural array next to each subarray, forming a single WAX tile.

This design has two key features. 
First, reuse and systolic dataflow are achieved by using a shift register. This ensures that operands are moving over very short wires. 
Second, the next level of the hierarchy is an adjacent subarray of size say 8 KB.

When dealing with large network layers, the computation must be spread across multiple subarrays, followed by an aggregation step that uses the smaller branches of the H-Tree. Thus, in the common case, each computation and data movement is localized and unimpeded by chip resources working on other computations.

###Efficient Dataflow for WAX (WAXFlow 1)

![](./pic/wax-3.png)

The example convolutional layer has 32 input feature maps, each of size 32 × 32; we assume 32 kernels, each of size 3 × 3 × 32. An 8 KB subarray can have 256 rows, each with 32 8-bit operands.

detials in paper...

Note that a row of weights and a row of input activations read from the subarray are reused 32 times; this is enabled with a relatively inexpensive right-shift within the A register. These 32 cycles represent one WAXFlow slice.

a basic slice in WAXFlow and its subsequent slices exhibit very high reuse of both activations and weights. 

The only drawback here is that partial sums are being read and written from/to the subarray and not a register. 

###Increasing Reuse for Partial Sums

![](./pic/wax-4.png)

if an alternative dataflow can reduce psum accesses by 4× at the cost of increasing activation and filter accesses by 4×, that can result in overall fewer subarray accesses. That is precisely the goal of a new dataflow, WAXFlow-2.


![](./pic/wax-5.png)

WAXFlow-3

WAXFlow-2 filled a partition in a kernel row with elements from 8 different kernels (Figure 4); there was therefore no opportunity to aggregate within a partition. But for WAXFlow-3, a row of weights from a single kernel is placed together in one kernel row partition. In our example, a kernel row only has three elements; therefore, there is room to place three elements from two kernels, with the last bytes of the partition left empty.


![](./pic/wax-6.png)

