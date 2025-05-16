section .data
    inputBuf db 0x83, 0x6A, 0x88, 0xDE, 0x9A, 0xC3, 0x54, 0x9A
    inputLen equ $ - inputBuf
    space db ' '

section .bss
    outputBuf resb 80

section .text
    global _start

; Subroutine: Convert hex digit (0-15) to ASCII representation
; Input: Single hex digit value on stack
; Output: ASCII character in AL register
hex_to_ascii:
    push ebp
    mov ebp, esp
    mov eax, [ebp+8]    
    
    ; Branch based on numerical range for correct ASCII conversion
    cmp al, 10          
    jl .digit           
    
    ; Convert A-F range using ASCII offset
    add al, 'A' - 10    
    jmp .done
    
.digit:
    ; Convert 0-9 range using ASCII offset
    add al, '0'         
    
.done:
    mov esp, ebp
    pop ebp
    ret

_start:
    ; Initialize registers for buffer processing
    mov esi, inputBuf     
    mov edi, outputBuf    
    mov ecx, inputLen      
    
.process_byte:
    ; Load next byte from input buffer for translation
    movzx eax, byte [esi]  
    
    ; Extract and translate high nibble (first hex digit)
    mov ebx, eax          
    shr ebx, 4            ; Isolate upper 4 bits for first hex character
    
    ; Convert high nibble to ASCII and store
    push ebx
    call hex_to_ascii
    add esp, 4            
    mov [edi], al         ; Store first hex character in output
    inc edi               
    
    ; Extract and translate low nibble (second hex digit)
    mov ebx, eax          
    and ebx, 0x0F         ; Isolate lower 4 bits for second hex character
    
    ; Convert low nibble to ASCII and store
    push ebx
    call hex_to_ascii
    add esp, 4            
    mov [edi], al         ; Store second hex character in output
    inc edi               
    
    ; Format output with space delimiter between byte values
    mov byte [edi], ' '   
    inc edi               
    
    ; Advance to next byte and continue if more bytes remain
    inc esi               
    dec ecx               
    jnz .process_byte     
    
    ; Format final output with proper line termination
    dec edi                
    mov byte [edi], 0x0A  ; Replace final space with newline
    
    ; Calculate exact output length for system call
    mov eax, 4            
    mov ebx, 1            
    mov ecx, outputBuf    
    mov edx, edi          
    sub edx, outputBuf    
    inc edx               ; Adjust length to include newline
    int 0x80              
    
    ; Clean exit
    mov eax, 1            
    xor ebx, ebx          
    int 0x80