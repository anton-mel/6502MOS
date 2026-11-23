# Simplified 6502 MOS

A simplified version of the MOS 6502 8-bit microprocessor with only a subset of its instructions. The 6502 is a classic CPU that powered some of the popular early systems such as the Apple II and NES. 

<img width="3840" height="2160" alt="6502_presented" src="https://github.com/user-attachments/assets/f0cbfdd2-041d-4644-abaa-63854cf70c2e" />

## Results

| Parameter | Value |
|---|---|
| Process | 180 nm SCMOS (λ = 0.09 µm), 1.8 V |
| Transistors | 6,760 (incl. pad ring) |
| Area | 333 × 334 µm (0.11 mm²) |
| f<sub>max</sub> | 76.9 MHz (13 ns two-phase clock) |
| Power | 4.1 mW @ 76.9 MHz, 0.54 mW @ 10 MHz |
| Instructions | LDA, STA, ADC, SBC, EOR, JMP |

Switch-level simulation in IRSIM. f<sub>max</sub> is the shortest clock whose pin trace matches a 400 ns reference run. Reproduce with Magic and IRSIM 9.7:

```sh
IRSIM=/path/to/irsim ./sim/sweep.sh
```
