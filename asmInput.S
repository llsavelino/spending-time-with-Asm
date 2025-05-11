#include <avr/io.h>
;.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.
.text
.global main__
.global loop__

; Constante para o delay de debounce
.equ iterations, (0xABCD)
;.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.,.

main__:
    ; Configuração inicial dos pinos
    SBI (DDRB -0x20), PB0      ; Configura PB0 como saída (LED)
    CBI (DDRD -0x20), PB2      ; Configura PD2 como entrada (botão)
    SBI (PORTD -0x20), PB2     ; Ativa resistor pull-up no PD2
    
    IN r16, (DDRB -0x20)       ; Leitura de ddrb
    SBRS r16, PB0              ; Bit configurado como saída?
    SBI (DDRB -0x20), PB0      ; Não então colocamos

    IN r16, (DDRB -0x20)       ; Leitura de ddrb
    SBRC r16, PB2              ; Bit configurado como entrada?
    CBI (DDRB -0x20), PB2      ; Não então colocamos

    IN r16, (PORTB -0x20)      ;
    SBRC r16, PB2              ; <- Mesma lógica
    CBI (PORTB -0x20), PB2     ;

  RET

loop__:                        ; Main Asm
    RCALL check_button         ; Verifica estado do botão com debounce
  RJMP loop__
;                                Sub-rotina para verificação do botão com debounce
check_button:
    SBIC (PIND -0x20), PB2    ; Pula se botão NÃO pressionado
    RJMP botao_solto          ; Botão não pressionado
    ;                            Se chegou aqui, botão pode estar pressionado

    RCALL delay_debounce      ; Espera para debounce
    SBIC (PIND -0x20), PB2    ; Verifica novamente após o delay
    RJMP botao_solto          ; Falso positivo, botão não está pressionado

    ;                           Botão realmente pressionado
    LDI r17, (1 << PB0)       ;
    OUT (PORTB -0x20), r17    ; Acende o LED
    COM r17                   ; inverte os bits de r17
  RET

botao_solto:
    ANDI r17, 0b00000000      ;
    OUT (PORTB -0x20), r17    ; Apaga o LED
  RET
;                                 Sub-rotina de delay para debounce
delay_debounce:
    LDI r30, lo8(iterations)  ; Parte baixa
    LDI r31, hi8(iterations)  ; Parte alta

  delay_loop: 
    SBIW r30, 0x01            ; Decrementa r30 e r31
    BRNE delay_loop           ; Continua até zero
  RET                         ;
