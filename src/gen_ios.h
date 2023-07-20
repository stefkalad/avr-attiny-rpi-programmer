#ifndef _GEN_IOS_H
#define _GEN_IOS_H

//Generic IO header.  Usually paired with the Raspberry Pi version of this file.

int  InitGenGPIO();
void GPIODirection( int iono, int out );
int  GPIOGet( int iono );
void GPIOSet( int iono, int turnon );

#endif
