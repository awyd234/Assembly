assume cs:codesg
data segment
	db '1975','1976','1977','1978','1979','1980','1981','1982','1983','1984'
	db '1985','1986','1987','1988','1989','1990','1991','1992','1993','1994'
	db '1995'
	;�����Ǳ�ʾ21���21���ַ���

	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
	dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	;�����Ǳ�ʾ21�깫˾�������21��dword������

	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
	dw 11542,14430,15257,17800
	;�����Ǳ�ʾ21�깫˾��Ա������21��word������
data ends

table segment
	db 16 dup (0) ;�����ݴ�show_str�����ַ���
table ends

codesg segment
	start:	mov ax,data
		mov ds,ax
		mov ax,table
		mov es,ax
;		mov cx,21
;	     s:	mov al,[si+0]
		;
;		loop s
		mov ax,4240H
		mov bx,0FH
		mov dh,4
		mov dl,1
		mov cl,2
		call dtoc_ex
		mov ax,4c00h
		int 21h
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;��ֵ��ʾextend
;���ƣ�dtoc_ex
;���ܣ���dword������ת��Ϊ��ʾʮ���������ַ������ַ�����0λ��β����
;������(ax)=��16λ��(bx)=��16λ
;	  ds:siָ���ַ������׵�ַ
;���أ���
dtoc_ex:	push si
		push di
		push ax
		push bx
		push cx
		push dx
		mov di,0
dtocLoop:	mov cx,10
		call divdw
		add cx,30h   
		push cx	;�õ�������ѹջ
		inc di
		mov cx,ax
		jcxz dtocJudge
		mov bx,dx
		jmp short dtocLoop
dtocJudge:mov cx,dx
		jcxz dtocOk
		jmp short dtocLoop
dtocOk:	mov cx,di
dtocPoLo:pop ax 
		mov byte ptr es:[si],al
		inc si
		loop dtocPoLo
		mov byte ptr es:[si],cl
		pop dx
		pop cx
		pop bx
		pop ax
		pop di
		pop si
		call show_str
		push ax
		push bx
		push cx
		mov bx,0
		mov cx,8
clear0:	mov ax,table
		mov es,ax
		mov ax,0
		mov es:[bx],ax
		add bx,2
		loop clear0
		pop cx
		pop bx
		pop ax
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;����������������
;���ƣ�divdw
;���ܣ����в����������ĳ������㣬������Ϊdword�ͣ�����Ϊword�ͣ����Ϊdword�͡�
;������(bx)=dword�����ݸ�16λ��(ax)=dword�����ݵ�16λ��
;         (cx)=����
;���أ�(dx)=����ĸ�16λ��(ax)=����ĵ�16λ��
;         (cx)=����
divdw:	push si
		push ax
		mov ax,bx
		mov dx,0
		div cx
		mov si,ax;��16λ��
		pop ax
		div cx
		mov cx,dx
		mov dx,si
		pop si
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;��ʾ�ַ���
;���ƣ�show_str 
;���ܣ���ָ��λ����ָ����ɫ����ʾһ����0�����ַ��� 
;������(dh)=�к�(0~24)��(dl)=�к�(0~79)��(cl)=��ɫ��ds:siָ���ַ������׵�ַ 
;���أ��� 
show_str:	push si
		push di
		push dx
		push bx
		push ax
		push cx
		mov bx,0
		mov ax,0b800h
		mov es,ax
		mov di,0
		mov cl,dh
		mov ch,0
	s0:	add bx,160
		loop s0
		mov dh,0
		inc dl
		add bx,dx
		add bx,dx
	s1:	mov cl,table:[si]
		mov ch,0
		jcxz showStrOk
		mov al,table:[si]
		mov byte ptr es:[bx+di],al
		inc di
		pop cx
		mov byte ptr es:[bx+di],cl
		push cx
		inc di
		inc si
		loop s1
showStrOk:pop cx
		pop ax
		pop bx
		pop dx
		pop di
		pop si
		ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
codesg ends
end start