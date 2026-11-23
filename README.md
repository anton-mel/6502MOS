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

## Bring-up board

`pcb/` is a KiCad 10 design for a two-layer, 100 × 80 mm board to bring up the chip once it is bonded into a DIP-40. It is a design only; it has not been fabricated or tested.

<img width="600" alt="6502 bring-up board" src="pcb/fab/render_top.png" />

The chip sits in a ZIF socket on its own 1.8 V rail. Four SN74LVC8T245 and one SN74LVC1T45 translate its bus to 3.3 V, where a 32 KB SRAM (AS6C62256) and a 3.3 V parallel flash (SST39VF010 in a PLCC-32 socket, programmed off-board) hold data and program. A Raspberry Pi Pico generates the two-phase clock and reset, snoops the bus and drives a monochrome VGA port. J2 (2×10) carries PHI0, PHI1, RESET, R/W̄, D0–D7, A11–A15 and /WE for a logic analyzer; the Pico sees the rest.

| DIP-40 pin | Signal |
|---|---|
| 1, 21 | VDD (1.8 V) |
| 11, 31 | GND |
| 2–9 | D0–D7 |
| 10 | R/W̄ (high = read) |
| 13–20 | A8–A15 |
| 29–22 | A0–A7 |
| 38 | RESET (active high) |
| 39, 40 | PHI1, PHI0 |
| 12, 30, 32–37 | NC |

A15 selects SRAM or ROM; /OE = not R/W̄ and /WE = NAND(not R/W̄, PHIx) come from one 74LVC00. Only the first 32 KB of the flash is used.

| Jumper | Setting | Effect |
|---|---|---|
| JP2 MAP | LO (1-3, 2-4) | ROM $0000–$7FFF, RAM $8000–$FFFF, for PC = $0000 at reset |
| JP2 MAP | HI (3-5, 4-6) | ROM $8000–$FFFF, RAM $0000–$7FFF, for a reset vector at $FFFC |
| JP3 WE | PHI0 or PHI1 | phase that strobes /WE on writes |
| JP1 IDD | fitted / removed | removed: chip current = V(TP1–TP2) / 10 Ω |

Power comes from the Pico's USB. Its 3V3 output (300 mA max) feeds the 3.3 V side, which draws under 100 mA. An AP2112K-1.8 LDO makes 1.8 V for the translators and, through R1 and JP1, the chip (about 2.3 mA at 76.9 MHz from the simulated 4.1 mW). Pico pins: GP0–7 = A0–A7, GP8–15 = D0–D7, GP16–18 = A8–A10, GP19 = R/W̄, GP20–22 = PHI0, PHI1, RESET, GP26–28 = VIDEO, HSYNC, VSYNC (VIDEO is inverted by its buffer gate). Pull resistors hold RESET high and both clocks low while the Pico boots.

`pcb/fab/` has the gerbers and drill files, BOM, schematic PDF and renders.
