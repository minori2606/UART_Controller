// This program is measure_distance.
// model pic16F877A

#include<htc.h>	// htc.h -> pic.h -> pic168xa.h
__CONFIG(HS & WDTDIS & PWRTEN & LVPDIS & UNPROTECT);

// int type is defined 16bit, char type is defined 8bit.
#define REG_36 *((volatile unsigned int *)(36))
//#define REG_27 *((volatile unsigned char *)(0x1B))
#define REG_38 *((volatile unsigned int *)(38))
//#define REG_39 *((volatile unsigned char *)(39))
#define REG_40 *((volatile unsigned int *)(40))
//#define REG_41 *((volatile unsigned char *)(41))

void main(void)
{
	int a,b;
	a=REG_40;
	b=a*500;
	//TRIS=0x0F; // for pic12f508
	while(1){
		if((PORTA&0x01)==0x01){
			REG_38=b;
		}	
		else{
			REG_36=0xACBD;
		}	
	}	
}	