Baud  rate formula :-

Tx/Rx Baud = fck/(8*(2-OVER8)*USARTDIV)

Here Over8 is for oversampling
if 8 bit oversamping over8 = 1
if 16 bit oversampling over8 = 0

USARTDIV is an unsigned fixed point number that is coded on USART_BRR register
In verilog we represent fixed point number in binary like 12 bit mantissa and 4 bit fraction which is 16 times the USARTDIV value(fixed point number)
eg 27.75 = 000000011011_1100 which is equivalent to 444 i.e  16 times 27.75

