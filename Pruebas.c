#define M 16
#define L 8
#define N L*M
#define PI 3.141592654
typedef struct
{
 float R, I;
}Complejo;
//Declaración de varíales inicializadas.
unsigned short i, OK=0;
unsigned short Fi=0, Co=0;
//Declaración de la función de interrupciones.
Complejo X[L][M];
Complejo Y[L][M];
//Función para realizar una multiplicación compleja.
Complejo Producto( Complejo A, Complejo B )
{
 Complejo Res;
 Res.R = A.R*B.R - A.I*B.I;
 Res.I = A.R*B.I + A.I*B.R;
 return Res;
}
//Función para realizar una suma compleja.
Complejo Adicion( Complejo A, Complejo B )
{
 Complejo Res;
 Res.R = A.R + B.R;
 Res.I = A.I + B.I;
 return Res;
}
//Función para determinar la magnitud de un número complejo.
float Magnitud( Complejo A )
{
 return sqrt( A.R*A.R + A.I*A.I );
}
//Cálculo rápido de Fourier, de N muestras.
void FFT( void )
{
 unsigned short l,q,m,p;
 Complejo WW;

 //Trío de bucles for, para ejecutar la
 //ecuación (15.26), la matriz Y[][], representa F(l,q).
 for( l=0; l<L; l++ )
 {
 for( q=0; q<M; q++ )
 {
 Y[l][q].R = 0.0;
 Y[l][q].I = 0.0;
 for( m=0; m<M; m++ )
 {
 WW.R = cos( 2*PI*m*q / M );
 WW.I = -sin( 2*PI*m*q / M );
 WW = Producto( X[l][m], WW );
 Y[l][q] = Adicion( Y[l][q], WW );
 }
 }
 }


 //Dupla se bucles for, para realizar la multiplicación
 //de factores Wn (15.27), Y[][] representa la matriz F(l,q), y
 //X[][] representa la matriz G(l,q).
 for( l=0; l<L; l++ )
 {
 for( q=0; q<M; q++ )
 {
 WW.R = cos( 2*PI*l*q / N );
 WW.I = -sin( 2*PI*l*q / N );
 X[l][q] = Producto( Y[l][q], WW );
 }
 }

 //Trío de bucles for, para ejecutar la
 //ecuación (15.28), la matriz Y[][], representa X(p,q),
 //y X[][] representa la matriz G(l,q).
 for( p=0; p<L; p++ )
 {
 for( q=0; q<M; q++ )
 {
 Y[p][q].R=0.0;
 Y[p][q].I=0.0;
 for( l=0; l<L; l++ )
 {WW.R = cos( 2*PI*l*p / L );
 WW.I = -sin( 2*PI*l*p / L );
 WW = Producto( X[l][q], WW );
 Y[p][q] = Adicion( Y[p][q], WW );
 }
 }
 }

 //Doble for anidado para determinar,
 //la magnitud de la transformada,
 //Este resultado queda en los términos reales de X[][]
 for( l=0; l<L; l++ )
 for( m=0; m<M; m++ )
 {
 X[l][m].R = Magnitud( Y[l][m] );
 X[l][m].I = 0.0;
 }
}
void interrupt ( void )
{
 if( INTCON.F2 )
 {
 TMR0L=135;
 //Timer0 con periodo de 774,4u segundo.
 // Fs = 1291,32 Hz.
 if( OK ) //Se evalúa la adquisición de muestras.
 {
 //Se hace la adquisición de las muestras,
 //y se archivan por columnas.
 X[Fi][Co].R = ((float)ADC_Read(0)-127.0);
 X[Fi][Co].I = 0.0;
 Fi++;
 if( Fi==L )
 {
 Fi = 0;
 Co++;
 if( Co==M )
 {
 Co=0;
 OK=0;
 }
 }
 }
 INTCON.F2=0;
 }
}
void main( void )
{
 char Text[30];
 unsigned short ff, cc, cont;
 //Inicio del puerto B como salida.
 TRISB = 0;
 PORTB = 0;
 //Se configura el TIMER 0, su interrupción.
 INTCON = 0b10100000;
 T0CON = 0b11000101;
 UART1_Init(9600);
 while(1)//Bucle infinito.
 {
 OK = 1; //Se habilita la lectura de muestras.
 UART1_Write_Text("// Adquisicion y FFT de:");
 IntToStr( N, Text );
 UART1_Write_Text(Text);
 UART1_Write_Text(" Muestras //");
 UART1_Write(13); UART1_Write(10);
 while( OK ); //Se espera la adquisicion de las muestras.
 FFT(); //Cálculo de la FFT.
 UART1_Write_Text("// Inicio de las muestras //");
 UART1_Write(13); UART1_Write(10);
 //La primera componente espectral se ignora y se hace igual a cero.
 X[0][0].R = 0.0;
 cont = 0;
 //Se envían la magnitud de la FFT, hasta N/2
 //por medio del puerto serial.
 for( ff=0; ff<L; ff++ )
 {
 for( cc=0; cc<M; cc++ )
 {
 FloatToStr( X[ff][cc].R, Text );
 UART1_Write_Text(Text);
 UART1_Write(13); UART1_Write(10);
 cont++;
 if( cont==N )
 {
 cc = M;
 ff = L;
 }
 }
 }
 UART1_Write_Text("// Fin de las muestras //");
 UART1_Write(13); UART1_Write(10);
 }
}