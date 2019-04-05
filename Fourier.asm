
_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68
	LNK	#14

;Fourier.c,9 :: 		void main() {
;Fourier.c,10 :: 		for(ikl=0;ikl<=tam-1;ikl++){
	PUSH	W10
	PUSH	W11
	PUSH	W12
	CLR	W0
	MOV	W0, _ikl
L_main0:
	MOV	_tam, W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_ikl), W0
	CP	W1, [W0]
	BRA GE	L__main36
	GOTO	L_main1
L__main36:
;Fourier.c,11 :: 		dato[ikl] = 0;
	MOV	_ikl, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_dato), W0
	ADD	W0, W1, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Fourier.c,10 :: 		for(ikl=0;ikl<=tam-1;ikl++){
	MOV	#1, W1
	MOV	#lo_addr(_ikl), W0
	ADD	W1, [W0], [W0]
;Fourier.c,12 :: 		}
	GOTO	L_main0
L_main1:
;Fourier.c,13 :: 		PORTB = 0x0000;
	CLR	PORTB
;Fourier.c,14 :: 		TRISB.F1 = 1;
	BSET	TRISB, #1
;Fourier.c,15 :: 		TRISB.F0 = 1;
	BSET	TRISB, #0
;Fourier.c,16 :: 		UART1_Init(115200);
	MOV	#49664, W10
	MOV	#1, W11
	CALL	_UART1_Init
;Fourier.c,17 :: 		Delay_ms(100);
	MOV	#16, W8
	MOV	#297, W7
L_main3:
	DEC	W7
	BRA NZ	L_main3
	DEC	W8
	BRA NZ	L_main3
	NOP
;Fourier.c,18 :: 		ADC1_Init();
	CALL	_ADC1_Init
;Fourier.c,19 :: 		while (1) {
L_main5:
;Fourier.c,21 :: 		for(ikl=0;ikl<=tam-1;ikl++){
	CLR	W0
	MOV	W0, _ikl
L_main7:
	MOV	_tam, W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_ikl), W0
	CP	W1, [W0]
	BRA GE	L__main37
	GOTO	L_main8
L__main37:
;Fourier.c,22 :: 		dato[ikl] = ADC1_Read(1)*(5.0)/4095.0;
	MOV	_ikl, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_dato), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+0]
	MOV	#1, W10
	CALL	_ADC1_Read
	CLR	W1
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16544, W3
	CALL	__Mul_FP
	MOV	#61440, W2
	MOV	#17791, W3
	CALL	__Div_FP
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Fourier.c,23 :: 		x[ikl]=dato[ikl];
	MOV	_ikl, W0
	SL	W0, #2, W2
	MOV	#lo_addr(_x), W0
	ADD	W0, W2, W1
	MOV	#lo_addr(_dato), W0
	ADD	W0, W2, W0
	MOV	[W0++], [W1++]
	MOV	[W0--], [W1--]
;Fourier.c,24 :: 		y[ikl]=0.0;
	MOV	_ikl, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_y), W0
	ADD	W0, W1, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;Fourier.c,21 :: 		for(ikl=0;ikl<=tam-1;ikl++){
	MOV	#1, W1
	MOV	#lo_addr(_ikl), W0
	ADD	W1, [W0], [W0]
;Fourier.c,25 :: 		}
	GOTO	L_main7
L_main8:
;Fourier.c,28 :: 		for (k=0,num=1; k<m; k++){
	CLR	W0
	MOV	W0, _k
	MOV	#1, W0
	MOV	W0, _num
L_main10:
	MOV	_k, W1
	MOV	#lo_addr(_m), W0
	CP	W1, [W0]
	BRA LT	L__main38
	GOTO	L_main11
L__main38:
;Fourier.c,29 :: 		num *= 2;}
	MOV	_num, W0
	SL	W0, #1, W0
	MOV	W0, _num
;Fourier.c,28 :: 		for (k=0,num=1; k<m; k++){
	MOV	#1, W1
	MOV	#lo_addr(_k), W0
	ADD	W1, [W0], [W0]
;Fourier.c,29 :: 		num *= 2;}
	GOTO	L_main10
L_main11:
;Fourier.c,30 :: 		nmedios=num>>1;
	MOV	_num, W0
	ASR	W0, #1, W1
	MOV	W1, _nmedios
;Fourier.c,31 :: 		for (i=1, j=nmedios; i<num-2; i++)
	MOV	#1, W0
	MOV	W0, _i
	MOV	W1, _j
L_main13:
	MOV	_num, W0
	SUB	W0, #2, W1
	MOV	#lo_addr(_i), W0
	CP	W1, [W0]
	BRA GT	L__main39
	GOTO	L_main14
L__main39:
;Fourier.c,33 :: 		if (i < j) {
	MOV	_i, W1
	MOV	#lo_addr(_j), W0
	CP	W1, [W0]
	BRA LT	L__main40
	GOTO	L_main16
L__main40:
;Fourier.c,34 :: 		tx = x[i];
	MOV	_i, W0
	SL	W0, #2, W2
	MOV	#lo_addr(_x), W0
	ADD	W0, W2, W3
	MOV.D	[W3], W0
	MOV	W0, _tx
	MOV	W1, _tx+2
;Fourier.c,35 :: 		ty = y[i];
	MOV	#lo_addr(_y), W0
	ADD	W0, W2, W2
	MOV.D	[W2], W0
	MOV	W0, _ty
	MOV	W1, _ty+2
;Fourier.c,36 :: 		x[i] = x[j];
	MOV	_j, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_x), W0
	ADD	W0, W1, W0
	MOV	[W0++], [W3++]
	MOV	[W0--], [W3--]
;Fourier.c,37 :: 		y[i] = y[j];
	MOV	_i, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_y), W0
	ADD	W0, W1, W2
	MOV	_j, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_y), W0
	ADD	W0, W1, W0
	MOV	[W0++], [W2++]
	MOV	[W0--], [W2--]
;Fourier.c,38 :: 		x[j] = tx;
	MOV	_j, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_x), W0
	ADD	W0, W1, W2
	MOV	_tx, W0
	MOV	_tx+2, W1
	MOV.D	W0, [W2]
;Fourier.c,39 :: 		y[j] = ty;
	MOV	_j, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_y), W0
	ADD	W0, W1, W2
	MOV	_ty, W0
	MOV	_ty+2, W1
	MOV.D	W0, [W2]
;Fourier.c,40 :: 		}
L_main16:
;Fourier.c,41 :: 		for(k=nmedios; k <= j; k >>= 1)
	MOV	_nmedios, W0
	MOV	W0, _k
L_main17:
	MOV	_k, W1
	MOV	#lo_addr(_j), W0
	CP	W1, [W0]
	BRA LE	L__main41
	GOTO	L_main18
L__main41:
;Fourier.c,42 :: 		{j -= k;}
	MOV	_k, W1
	MOV	#lo_addr(_j), W0
	SUBR	W1, [W0], [W0]
;Fourier.c,41 :: 		for(k=nmedios; k <= j; k >>= 1)
	MOV	_k, W0
	ASR	W0, #1, W0
	MOV	W0, _k
;Fourier.c,42 :: 		{j -= k;}
	GOTO	L_main17
L_main18:
;Fourier.c,43 :: 		j+=k;
	MOV	_k, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Fourier.c,31 :: 		for (i=1, j=nmedios; i<num-2; i++)
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Fourier.c,44 :: 		}
	GOTO	L_main13
L_main14:
;Fourier.c,46 :: 		nn=1;
	MOV	#1, W0
	MOV	W0, _nn
;Fourier.c,47 :: 		wn1 = -1.0;
	MOV	#0, W0
	MOV	#49024, W1
	MOV	W0, _wn1
	MOV	W1, _wn1+2
;Fourier.c,48 :: 		wn2 = 0.0;
	CLR	W0
	CLR	W1
	MOV	W0, _wn2
	MOV	W1, _wn2+2
;Fourier.c,49 :: 		for (nivel=0; nivel<m; nivel++)
	CLR	W0
	MOV	W0, _nivel
L_main20:
	MOV	_nivel, W1
	MOV	#lo_addr(_m), W0
	CP	W1, [W0]
	BRA LT	L__main42
	GOTO	L_main21
L__main42:
;Fourier.c,50 :: 		{ nn=2*nn;
	MOV	_nn, W0
	SL	W0, #1, W0
	MOV	W0, _nn
;Fourier.c,51 :: 		for(j=0; j<num; j=j+nn)
	CLR	W0
	MOV	W0, _j
L_main23:
	MOV	_j, W1
	MOV	#lo_addr(_num), W0
	CP	W1, [W0]
	BRA LT	L__main43
	GOTO	L_main24
L__main43:
;Fourier.c,53 :: 		w1a = 1.0; w2a = 0.0;
	MOV	#0, W0
	MOV	#16256, W1
	MOV	W0, _w1a
	MOV	W1, _w1a+2
	CLR	W0
	CLR	W1
	MOV	W0, _w2a
	MOV	W1, _w2a+2
;Fourier.c,54 :: 		for (k=0; k< nn/2; k++)//Se aplica mariposa a los pares (k+j, k+j+nn/2)
	CLR	W0
	MOV	W0, _k
L_main26:
	MOV	_nn, W0
	ASR	W0, #1, W1
	MOV	#lo_addr(_k), W0
	CP	W1, [W0]
	BRA GT	L__main44
	GOTO	L_main27
L__main44:
;Fourier.c,56 :: 		i=k+j;
	MOV	_k, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W1
	MOV	W1, _i
;Fourier.c,57 :: 		i1=i+nn/2;
	MOV	_nn, W0
	ASR	W0, #1, W0
	ADD	W1, W0, W0
	MOV	W0, _i1
;Fourier.c,58 :: 		t1 = w1a * x[i1] - w2a * y[i1];
	SL	W0, #2, W1
	MOV	#lo_addr(_x), W0
	ADD	W0, W1, W2
	MOV.D	[W2], W0
	MOV	_w1a, W2
	MOV	_w1a+2, W3
	CALL	__Mul_FP
	MOV	W0, [W14+10]
	MOV	W1, [W14+12]
	MOV	_i1, W0
	SL	W0, #2, W1
	MOV	W1, [W14+8]
	MOV	#lo_addr(_y), W0
	ADD	W0, W1, W2
	MOV	W2, [W14+4]
	MOV.D	[W2], W0
	MOV	_w2a, W2
	MOV	_w2a+2, W3
	CALL	__Mul_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	PUSH.D	W2
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Sub_FP
	POP.D	W2
	MOV	W0, _t1
	MOV	W1, _t1+2
;Fourier.c,59 :: 		t2 = w1a * y[i1] + w2a * x[i1];
	MOV	[W14+4], W2
	MOV.D	[W2], W0
	MOV	_w1a, W2
	MOV	_w1a+2, W3
	CALL	__Mul_FP
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	MOV	#lo_addr(_x), W1
	MOV	[W14+8], W0
	ADD	W1, W0, W2
	MOV	W2, [W14+0]
	MOV.D	[W2], W0
	MOV	_w2a, W2
	MOV	_w2a+2, W3
	CALL	__Mul_FP
	MOV	[W14+4], W2
	MOV	[W14+6], W3
	CALL	__AddSub_FP
	MOV	W0, _t2
	MOV	W1, _t2+2
;Fourier.c,60 :: 		x[i1] = x[i] - t1;
	MOV	_i, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_x), W0
	ADD	W0, W1, W0
	MOV.D	[W0], W4
	MOV	_t1, W2
	MOV	_t1+2, W3
	MOV.D	W4, W0
	CALL	__Sub_FP
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Fourier.c,61 :: 		y[i1] = y[i] - t2;
	MOV	_i1, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_y), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+0]
	MOV	_i, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_y), W0
	ADD	W0, W1, W0
	MOV.D	[W0], W4
	MOV	_t2, W2
	MOV	_t2+2, W3
	MOV.D	W4, W0
	CALL	__Sub_FP
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Fourier.c,63 :: 		x[i] += t1;
	MOV	_i, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_x), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+0]
	MOV.D	[W0], W2
	MOV	_t1, W0
	MOV	_t1+2, W1
	CALL	__AddSub_FP
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Fourier.c,64 :: 		y[i] += t2;
	MOV	_i, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_y), W0
	ADD	W0, W1, W0
	MOV	W0, [W14+0]
	MOV.D	[W0], W2
	MOV	_t2, W0
	MOV	_t2+2, W1
	CALL	__AddSub_FP
	MOV	[W14+0], W2
	MOV.D	W0, [W2]
;Fourier.c,65 :: 		tw = w1a * wn1 - w2a * wn2;
	MOV	_w1a, W0
	MOV	_w1a+2, W1
	MOV	_wn1, W2
	MOV	_wn1+2, W3
	CALL	__Mul_FP
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
	MOV	_w2a, W0
	MOV	_w2a+2, W1
	MOV	_wn2, W2
	MOV	_wn2+2, W3
	CALL	__Mul_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	[W14+4], W0
	MOV	[W14+6], W1
	PUSH.D	W2
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__Sub_FP
	POP.D	W2
	MOV	W0, _tw
	MOV	W1, _tw+2
;Fourier.c,66 :: 		w2a = w1a * wn2 + w2a * wn1;
	MOV	_w1a, W0
	MOV	_w1a+2, W1
	MOV	_wn2, W2
	MOV	_wn2+2, W3
	CALL	__Mul_FP
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	_w2a, W0
	MOV	_w2a+2, W1
	MOV	_wn1, W2
	MOV	_wn1+2, W3
	CALL	__Mul_FP
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	CALL	__AddSub_FP
	MOV	W0, _w2a
	MOV	W1, _w2a+2
;Fourier.c,67 :: 		w1a = tw;
	MOV	_tw, W0
	MOV	_tw+2, W1
	MOV	W0, _w1a
	MOV	W1, _w1a+2
;Fourier.c,54 :: 		for (k=0; k< nn/2; k++)//Se aplica mariposa a los pares (k+j, k+j+nn/2)
	MOV	#1, W1
	MOV	#lo_addr(_k), W0
	ADD	W1, [W0], [W0]
;Fourier.c,68 :: 		}
	GOTO	L_main26
L_main27:
;Fourier.c,51 :: 		for(j=0; j<num; j=j+nn)
	MOV	_nn, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Fourier.c,69 :: 		}
	GOTO	L_main23
L_main24:
;Fourier.c,70 :: 		wn2 = sqrt((1.0 - wn1) / 2.0);
	MOV	#0, W0
	MOV	#16256, W1
	MOV	_wn1, W2
	MOV	_wn1+2, W3
	CALL	__Sub_FP
	MOV	#0, W2
	MOV	#16384, W3
	CALL	__Div_FP
	MOV.D	W0, W10
	CALL	_sqrt
	MOV	W0, _wn2
	MOV	W1, _wn2+2
;Fourier.c,71 :: 		wn2 = -wn2;
	MOV	#0, W3
	MOV	#32768, W4
	MOV	#lo_addr(_wn2), W2
	XOR	W0, W3, [W2++]
	XOR	W1, W4, [W2--]
;Fourier.c,72 :: 		wn1 = sqrt((1.0 + wn1) / 2.0);
	MOV	#0, W2
	MOV	#16256, W3
	MOV	_wn1, W0
	MOV	_wn1+2, W1
	CALL	__AddSub_FP
	MOV	#0, W2
	MOV	#16384, W3
	CALL	__Div_FP
	MOV.D	W0, W10
	CALL	_sqrt
	MOV	W0, _wn1
	MOV	W1, _wn1+2
;Fourier.c,49 :: 		for (nivel=0; nivel<m; nivel++)
	MOV	#1, W1
	MOV	#lo_addr(_nivel), W0
	ADD	W1, [W0], [W0]
;Fourier.c,73 :: 		}
	GOTO	L_main20
L_main21:
;Fourier.c,75 :: 		for(ikl=0;ikl<=tam-1;ikl++){
	CLR	W0
	MOV	W0, _ikl
L_main29:
	MOV	_tam, W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_ikl), W0
	CP	W1, [W0]
	BRA GE	L__main45
	GOTO	L_main30
L__main45:
;Fourier.c,76 :: 		FloatToStr(dato[ikl],txt);
	MOV	_ikl, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_dato), W0
	ADD	W0, W1, W0
	MOV	#lo_addr(_txt), W12
	MOV.D	[W0], W10
	CALL	_FloatToStr
;Fourier.c,77 :: 		UART1_Write_Text(txt);
	MOV	#lo_addr(_txt), W10
	CALL	_UART1_Write_Text
;Fourier.c,78 :: 		UART1_Write(44);
	MOV	#44, W10
	CALL	_UART1_Write
;Fourier.c,75 :: 		for(ikl=0;ikl<=tam-1;ikl++){
	MOV	#1, W1
	MOV	#lo_addr(_ikl), W0
	ADD	W1, [W0], [W0]
;Fourier.c,79 :: 		}
	GOTO	L_main29
L_main30:
;Fourier.c,80 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;Fourier.c,81 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;Fourier.c,82 :: 		for(ikl=0;ikl<=tam-1;ikl++){
	CLR	W0
	MOV	W0, _ikl
L_main32:
	MOV	_tam, W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_ikl), W0
	CP	W1, [W0]
	BRA GE	L__main46
	GOTO	L_main33
L__main46:
;Fourier.c,83 :: 		FloatToStr(x[ikl],txt1);
	MOV	_ikl, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_x), W0
	ADD	W0, W1, W0
	MOV	#lo_addr(_txt1), W12
	MOV.D	[W0], W10
	CALL	_FloatToStr
;Fourier.c,84 :: 		UART1_Write_Text(txt1);
	MOV	#lo_addr(_txt1), W10
	CALL	_UART1_Write_Text
;Fourier.c,85 :: 		UART1_Write(43);
	MOV	#43, W10
	CALL	_UART1_Write
;Fourier.c,86 :: 		FloatToStr(y[ikl],txt1);
	MOV	_ikl, W0
	SL	W0, #2, W1
	MOV	#lo_addr(_y), W0
	ADD	W0, W1, W0
	MOV	#lo_addr(_txt1), W12
	MOV.D	[W0], W10
	CALL	_FloatToStr
;Fourier.c,87 :: 		UART1_Write_Text(txt1);
	MOV	#lo_addr(_txt1), W10
	CALL	_UART1_Write_Text
;Fourier.c,88 :: 		UART1_Write(105);
	MOV	#105, W10
	CALL	_UART1_Write
;Fourier.c,89 :: 		UART1_Write(44);
	MOV	#44, W10
	CALL	_UART1_Write
;Fourier.c,82 :: 		for(ikl=0;ikl<=tam-1;ikl++){
	MOV	#1, W1
	MOV	#lo_addr(_ikl), W0
	ADD	W1, [W0], [W0]
;Fourier.c,90 :: 		}
	GOTO	L_main32
L_main33:
;Fourier.c,91 :: 		UART1_Write(13);
	MOV	#13, W10
	CALL	_UART1_Write
;Fourier.c,92 :: 		UART1_Write(10);
	MOV	#10, W10
	CALL	_UART1_Write
;Fourier.c,93 :: 		}
	GOTO	L_main5
;Fourier.c,95 :: 		}
L_end_main:
	POP	W12
	POP	W11
	POP	W10
	ULNK
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
