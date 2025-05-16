# Hex to ASCII Translator

This is a simple assembly program that takes a buffer of bytes and prints their hexadecimal ASCII representation to the screen.

## What This Program Does

Given a hardcoded input buffer like:
```
[0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A]
```

The program converts each byte into its two-digit hexadecimal ASCII representation. It prints the results as space-separated values followed by a newline.

### Expected Output
```
83 6A 88 DE 9A C3 54 9A
```

## How to Compile and Run

### Prerequisites

Make sure you have `nasm` and the required 32-bit compilation tools installed.

On Ubuntu/Debian, you can install them using:
```bash
sudo apt-get install nasm gcc-multilib
```

### Compile the Program

Use make to compile the program:
```bash
make
```

This will assemble and link the program using NASM and GCC.

### Run the Program

After compiling, run the executable with:
```bash
./hw11translate2Ascii
```

## Implementation Details

The program uses a subroutine called `hex_to_ascii` to convert hexadecimal digits into their ASCII equivalents. Each byte in the input buffer is processed as follows:

1. Extract the high nibble (the first 4 bits)
2. Convert it to its ASCII character using `hex_to_ascii`
3. Extract the low nibble (the last 4 bits)
4. Convert it to ASCII
5. Append a space after each converted byte
6. After all bytes are processed, the last space is replaced with a newline

The resulting ASCII characters are stored in an output buffer, which is then printed to the screen.
