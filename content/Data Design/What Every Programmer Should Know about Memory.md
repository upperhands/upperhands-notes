---
tags:
  - "#cs"
url: https://people.freebsd.org/~lstewart/articles/cpumemory.pdf
---
# What Every Programmer Should Know about Memory
## Commodity Hardware Today
TODO
## Types of RAMs
We have SRAMs (static) and DRAMs (dynamic) in the same machine. SRAMs are much faster than DRAMs and provide the same functionality. However, it is much harder to produce and much more expensive.

### SRAM
I won't go into the technical details, but unlike the DRAM, access to the state is available as long as the power is turned on - no need to charge/discharge the individual cells and immediate access to the cells.
### DRAM
A DRAM cell consists of a **capacitor (C)**, a **transistor (M)**, an **access line (AL)**, and a **data line (DL)**.
- **Capacitor**: Used to keep the state of the cell.
- **Transistor**: Used to guard the access to the state. When the transistor is on, the capacitor can be read or written.
- **Access Line**: Controls the transistor by turning it on or off.
- **Data Line**: Used to read from or write to the capacitor.

The design of DRAM has a number of complications.

1. Reading (data) from the cell causes the capacitor's charge to be drained into the bit line. This means, in order to use the cell properly, you will need to recharge the cell - *cost*.
2. A fully charged capacitor holds tens of thousands of electrons. Even though the resistance of the capacitor is high, it only takes a short time for the capacity to dissipate. This problem is called **leakage**. This problem is the main reason why a DRAM cell, even if it is off, must be constantly refreshed. For most DRAM chips, a cell requires refreshing every `64ms`. When recharging, access to the memory is not possible--refresh is simply a read operation with the result being discarded (`_ = readMem(myMem)`)[^1].
3. Another problem is a bit more basic, I guess: deciding if the stored information is `1` or `0`. At the end of the day, what you have is some number of electrons transferred from the capacitor to the data line. In order to decide what they are, we need to use an amplifier.
4. This one will allow some physics :D We know that the charge in a capacitor is given by the formula $Q(t) = Q_0(1 - e^{-\frac{t}{RC}})$, where $Q_0$ is the charge we want to achieve, $t$ is the time since the charging process began, $R$ is the resistance, $C$ is the capacitance of the capacitor. In a similar fashion, we have $Q(t) = Q_0e^{-\frac{t}{RC}}$ for discharging the capacitor (this time $Q_0$ is the initial charge). So, *it takes time to charge and discharge the capacitor*. Unlike the SRAM, it will always take a bit of time until the capacitor discharges sufficiently. This impacts how fast DRAM can be severely.

[^1]: So, this is a pretty normal thing for capacitors actually. Capacitors are essentially two conductive materials with dielectric between them. Dielectric is supposed to avoid any transferring of charge between the plates, but they are not perfect :( they tend to allow, gradually, some electrons to transfer between the capacitors over time.
