section .data
    inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
    inputLen equ $ - inputBuf
    space db ' '

section .bss
    outputBuf resb 80

section .text
    global _start

; Convert a value 0-15 to its ASCII hex representation ('0'-'9', 'A'-'F')
hex_to_ascii:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]    ; Get the parameter (value to convert)
    
    cmp al, 10          ; Check if value is 0-9 or A-F
    jl .digit           ; If less than 10, it's a digit
    
    add al, 'A' - 10    ; Convert 10-15 to 'A'-'F'
    jmp .done
    
.digit:
    add al, '0'         ; Convert 0-9 to '0'-'9'
    
.done:
    mov esp, ebp
    pop ebp
    ret

_start:
    mov esi, inputBuf      ; Source index points to input buffer
    mov edi, outputBuf     ; Destination index points to output buffer
    mov ecx, inputLen      ; Counter for number of bytes to process
    
.process_byte:
    movzx eax, byte [esi]  ; Get current byte from input buffer
    
    ; Process high nibble (first hex digit)
    mov ebx, eax           ; Copy the byte
    shr ebx, 4             ; Shift right to get high 4 bits
    
    ; Call our conversion function
    push ebx
    call hex_to_ascii
    add esp, 4             ; Clean up stack
    
    mov [edi], al          ; Store the ASCII character
    inc edi                ; Move to next position in output
    
    ; Process low nibble (second hex digit)
    mov ebx, eax           ; Copy the original byte again
    and ebx, 0x0F          ; Mask to get low 4 bits
    
    ; Call our conversion function
    push ebx
    call hex_to_ascii
    add esp, 4             ; Clean up stack
    
    mov [edi], al          ; Store the ASCII character
    inc edi                ; Move to next position in output
    
    ; Add a space after each byte (except the last one)
    mov byte [edi], ' '    ; Add space
    inc edi                ; Move to next position
    
    inc esi                ; Move to next input byte
    dec ecx                ; Decrement counter
    jnz .process_byte      ; If not zero, process next byte
    
    ; Replace the last space with a newline
    dec edi                ; Move back to the last space
    mov byte [edi], 0x0A   ; Replace with newline character
    
    ; Print the output buffer
    mov eax, 4             ; sys_write system call
    mov ebx, 1             ; file descriptor 1 (stdout)
    mov ecx, outputBuf     ; pointer to output buffer
    mov edx, edi           ; length to write (edi now points to end)
    sub edx, outputBuf     ; Calculate length (end - start + 1)
    inc edx                ; Include the newline character
    int 0x80               ; make system call
    
    ; Exit program
    mov eax, 1             ; sys_exit system call
    xor ebx, ebx           ; exit code 0
    int 0x80               ; make system call