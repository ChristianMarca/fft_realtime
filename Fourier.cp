#line 1 "D:/file/9no Ciclo/D.S.P/Fourier_dsPIC/Fourier.c"

char uart_rd;int tam=64;int ikl;int dir=1;
double x[64];double y[64];double dato[64];int m=6;
int num;int nn;int nmedios;
int nivel;int i;int j;int k;int i1;int ikj;
 double w1a;double w2a;double wn1;double wn2;double tx;double ty;double tw;double t1;double t2;
 double trans[64]; char txt[15];char txt1[15];

void main() {
 for(ikl=0;ikl<=tam-1;ikl++){
 dato[ikl] = 0;
 }
 PORTB = 0x0000;
 TRISB.F1 = 1;
 TRISB.F0 = 1;
 UART1_Init(115200);
 Delay_ms(100);
 ADC1_Init();
 while (1) {

 for(ikl=0;ikl<=tam-1;ikl++){
 dato[ikl] = ADC1_Read(1)*(5.0)/4095.0;
 x[ikl]=dato[ikl];
 y[ikl]=0.0;
 }


 for (k=0,num=1; k<m; k++){
 num *= 2;}
 nmedios=num>>1;
 for (i=1, j=nmedios; i<num-2; i++)
 {
 if (i < j) {
 tx = x[i];
 ty = y[i];
 x[i] = x[j];
 y[i] = y[j];
 x[j] = tx;
 y[j] = ty;
 }
 for(k=nmedios; k <= j; k >>= 1)
 {j -= k;}
 j+=k;
 }

 nn=1;
 wn1 = -1.0;
 wn2 = 0.0;
 for (nivel=0; nivel<m; nivel++)
 { nn=2*nn;
 for(j=0; j<num; j=j+nn)
 {
 w1a = 1.0; w2a = 0.0;
 for (k=0; k< nn/2; k++)
 {
 i=k+j;
 i1=i+nn/2;
 t1 = w1a * x[i1] - w2a * y[i1];
 t2 = w1a * y[i1] + w2a * x[i1];
 x[i1] = x[i] - t1;
 y[i1] = y[i] - t2;

 x[i] += t1;
 y[i] += t2;
 tw = w1a * wn1 - w2a * wn2;
 w2a = w1a * wn2 + w2a * wn1;
 w1a = tw;
 }
 }
 wn2 = sqrt((1.0 - wn1) / 2.0);
 wn2 = -wn2;
 wn1 = sqrt((1.0 + wn1) / 2.0);
 }

 for(ikl=0;ikl<=tam-1;ikl++){
 FloatToStr(dato[ikl],txt);
 UART1_Write_Text(txt);
 UART1_Write(44);
 }
 UART1_Write(13);
 UART1_Write(10);
 for(ikl=0;ikl<=tam-1;ikl++){
 FloatToStr(x[ikl],txt1);
 UART1_Write_Text(txt1);
 UART1_Write(43);
 FloatToStr(y[ikl],txt1);
 UART1_Write_Text(txt1);
 UART1_Write(105);
 UART1_Write(44);
 }
 UART1_Write(13);
 UART1_Write(10);
 }

}
