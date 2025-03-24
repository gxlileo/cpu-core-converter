# cpu-core-converter
A bare-metal ARMv7 assembly program that converts a binary string to decimal, prints it, then converts it back to binary. Runs on CPUlator without OS or libraries. Built from scratch for low-level systems understanding.

ARMv7 Binary ↔ Decimal Converter

This project is a **bare-metal ARMv7 assembly program** that:
- Takes a **binary string** (e.g. `"1101"`)
- Converts it to a **decimal integer** (`13`)
- Converts the **decimal value back** into a binary string
- **Prints both** to the terminal via memory-mapped I/O
- Runs entirely on [CPUlator](https://cpulator.01xz.net/?sys=arm-de1soc), without an OS, libraries, or external dependencies

Designed for deep learning and demonstration of low-level system fundamentals.

---

Features

Binary-to-decimal conversion using bitwise shifts  
Decimal-to-binary conversion using masking and reverse string construction  
Manual memory management with ASCII string buffers  
UART-style terminal printing using memory-mapped I/O (`0xFF201000`)  
Built from scratch in **pure ARMv7 assembly**  
Fully annotated for learning and educational use  
Compatible with **CPUlator** (DE1-SoC ARMv7 CPU simulator)

Why This Project Matters?

Understanding how to convert between number systems at the assembly level teaches:

- How machines represent data
- How higher-level functions like `atoi()` work internally
- How to format strings without relying on printf
- How to interact directly with hardware (UART)

This project bridges the gap between software and hardware thinking.
---

Folder Structure

```bash
.
├── binary-decimal.s     # Main assembly program
├── README.md            # You're here
├── LICENSE              # MIT License
├── .gitignore           # Standard ignore file
└── screenshots/         # (Optional) screenshots of output and code

