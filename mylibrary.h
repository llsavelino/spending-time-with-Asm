#pragma once
#ifdef __cplusplus
extern "C" 
{ 
#endif
  void main__               (void);
  void loop__               (void); 
#ifdef __cplusplus
}
#endif
extern volatile uint8_t* portb_reg;
extern volatile uint8_t*  ddrb_reg;
extern volatile uint8_t*  pinb_reg;

extern volatile uint8_t* portc_reg;
extern volatile uint8_t*  ddrc_reg;
extern volatile uint8_t*  pinc_reg;

extern volatile uint8_t* portd_reg;
extern volatile uint8_t*  ddrd_reg;
extern volatile uint8_t*  pind_reg;
