# Byte Order

We all know that computers store information using bits--$1$s and $0$s, and we represent integers, floats, and chars using the binary representation of their corresponding numbers.

$$
\begin{split}
11 & = 8 + 2 + 1  \\
   & = 1\cdot2^3 + 0\cdot2^2 + 1\cdot2^1 + 1\cdot2^0 \\
   & = (1011)_{2} \\
\end{split}
$$

This is how we represent numbers in binary. Just like the decimal representation of the number, the most significant digit is the leftmost digit and the least significant digit is the rightmost digit. So, you are probably thinking that this is how CPU encodes the numbers as well. Well, *not really*...

## What is Byte Order?
You can run `lscpu | grep "Byte Order:"` to find out what byte order your CPU is using. If you are using a newer machine, you will most likely see **Little Endian**. Otherwise, you will see **Big Endian**.[^1] Here is the comparison:

- **Little Endian**: The least significant digit is on the left and the most significant digit is on the right. So, this is the reversed version of the mathematical representation of binary numbers.
- **Big Endian**: The least significant digit is on the right and the most significant digit is on the left. So, this is how we represent binary numbers mathematically.

## Why do we need to know this?
Let's take a look at this code:

```c
unsigned x = 1;
char* c = (char*)&x;
char y = *c;
std::cout << y << std::endl;
```
To find the result, let's first find how `x` is represented. `x` is an `unsigned int`, so it stores 32-bits of information with a value of 1. So, if we were to read the 32 bits starting from the address of `x`, depending on what byte order we are using, we would see the following:

| Little Endian                      | Big Endian                         |
| ---------------------------------- | ---------------------------------- |
| `10000000000000000000000000000000` | `00000000000000000000000000000001` |

Then, we assign `c` to the address of `x` with the catch that `c` is a `char*`. Then, we dereference `c` and since its type is `char`, we will read the first 8 bytes. Then, the value of `y` will be:

Little Endian | Big Endian
------------- | ----------
`10000000`    | `00000000`
`1`           | `0`

So, the output of this very simple program will differ from machine to machine.

[^1]: Apparently, there are some architectures allowing switchable Endianness in certain operations. You can read more about it [here](https://en.wikipedia.org/wiki/Endianness#Bi-endianness)
