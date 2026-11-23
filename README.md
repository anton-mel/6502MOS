# Simplified 6502 MOS

A simplified version of the MOS 6502 8-bit microprocessor with only a subset of its instructions. The 6502 is a classic CPU that powered some of the popular early systems such as the Apple II and NES. 

<img width="3840" height="2160" alt="6502_presented" src="https://github.com/user-attachments/assets/f0cbfdd2-041d-4644-abaa-63854cf70c2e" />

## Results

| | |
|---|---|
| Process | SCMOS rules, TSMC 0.18 µm extraction (λ = 0.09 µm), 1.8 V |
| Transistors | 6,760 (3,814 n, 2,946 p), including the pad ring |
| Layout | 333 × 334 µm (0.11 mm²) |
| Instructions tested | LDA (imm, abs), STA, ADC, SBC, EOR, JMP (abs) |
| Max clock (IRSIM) | 76.9 MHz (13 ns two-phase period); fails at 12 ns on the PC-high path after JMP |
| Dynamic power (IRSIM) | 4.1 mW at 76.9 MHz (3.9 mW without pads), 0.54 mW at 10 MHz |

The clock is swept by running `magic/6502_final.irsim` at shorter step sizes and comparing the address, data and R/W pins against a 400 ns run. Power is IRSIM's CV²f estimate over all nodes.

```sh
IRSIM=/path/to/irsim ./sim/sweep.sh
```

Needs Magic and IRSIM 9.7. The script re-extracts `magic/6502.mag` with pads, so the pin names in the test resolve.
