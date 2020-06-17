.model small
.stack  100h
.data
string db 212 dup(?)
range db 16 dup(?)
message1 db "Enter an array",0Dh,0Ah,'$'
message2 db 0Dh,0Ah,"Enter a range of values",0Dh,0Ah,'$'
error_message1 db 0Dh,0Ah,"The input string has incorrect symbols",0Dh,0Ah,'$'   
error_message2 db 0Dh,0Ah,"There are extra spaces in the line",0Dh,0Ah,'$'
error_message3 db 0Dh,0Ah,"There was an overflow in the number",0Dh,0Ah,'$' 
error_message4 db 0Dh,0Ah,"No more than 30 items per line",0Dh,0Ah,'$'
error_message5 db 0Dh,0Ah,"No more than 2 items per line",0Dh,0Ah,'$'         
error_message6 db 0Dh,0Ah,"The numbers in the range string are not correctly placed",0Dh,0Ah,'$' 
endl db 0Dh,0Ah,'$'
.code 

output macro str  
    mov dx,offset str
    mov ah,9
    int 21h    
endm 

input proc
    mov ah,0Ah
    int 21h
    ret         ;vvod  
input endp  

check_string proc  
mov si,2       ; index current symbol
xor ax,ax      ;cyrrent symbol
xor cx,cx      ;number
dec bx
mov cx,bx                               ; bh=1 esli sympol=-
xor bx,bx    ; flags
xor dx,dx    ;peremennay dlay obrazovania chisla
mov bl,1   
xor di,di
mov bp,0     ;kolichestvo chisel
                                       ;  bl=1 nachalo slova
cicle1:                                 ; bl=0 ne nachalo slova
mov al,string[si]
inc si
cmp ax,'$'
je check_end
jne check_minus

check_end:
cmp bl,1
je error2
jne check_pred_minus

check_pred_minus:
cmp bh,1
je check_word
jne free

check_word:
cmp dx,0
je error1
jne mul_1

check_minus:
cmp ax,'-'                   
je check_znak
jne check_probel

check_znak:
cmp bl,1
je set_znak
jne error1

set_znak:
mov bh,1
mov bl,0
jmp next

check_probel:
cmp ax,' '
je this_is_probel
jne check_number1  

this_is_probel:
cmp bl,1
je error2
jne set_probel

set_probel:
mov bl,1 
jmp check_negative_number     

check_negative_number:    
cmp bh,1              
jne free
je mul_1

free:
inc bp
xor bh,bh 
push dx
xor dx,dx
xor ax,ax 
jmp next 

mul_1:      
mov ax,-1
mul dx
mov dx,ax 
jmp free

check_number1:
cmp ax,'0'
jae check_number2
jb error1

check_number2:
cmp ax,'9'
jbe this_is_number
ja error1

error1:
output error_message1  
jmp input_first_string

error2:
output error_message2  
jmp input_first_string                

error3:
output error_message3  
jmp input_first_string 

error4:
output error_message4  
jmp input_first_string

this_is_number:
cmp dx,0        
je initialize
jne add_in_count

initialize:
mov bl,0
sub ax,'0'
add dx,ax  
jmp next

add_in_count:
sub ax,'0' 
push cx
mov cx,ax
mov ax,10 
mul dx
push dx
mov dx,ax 
add dx,cx
pop di
pop cx
cmp di,1
je error3 ;overflow
jne next_compare  

next_compare: 
cmp bh,1
je compare_for_negative_number
jne compare_for_positive_number

compare_for_negative_number:  
cmp dx,32768
ja error3 ;overflow
jbe not_overflow

compare_for_positive_number:
cmp dx,32767
ja error3 ;overflow
jbe not_overflow

not_overflow: 
xor ax,ax
jmp next 

next:
loop cicle1 

check_count:
cmp bp,5
jne error4 
jmp input_second_string                                            
check_string endp


check_range proc 
pop si ;;;;
mov si,2       ; index current symbol
xor ax,ax      ;cyrrent symbol
xor cx,cx      ;number
dec bx
mov cx,bx                               ; bh=1 esli sympol=-
xor bx,bx    ; flags
xor dx,dx    ;peremennay dlay obrazovania chisla
mov bl,1   
xor di,di
mov bp,0     ;kolichestvo chisel
                                       ;  bl=1 nachalo slova
cicle2:                                 ; bl=0 ne nachalo slova
mov al,range[si]
inc si
cmp ax,'$'
je check_end1
jne check_minus1

check_end1:
cmp bl,1
je error21
jne check_pred_minus1

check_pred_minus1:
cmp bh,1
je check_word1   
jne free1

check_word1:   
cmp dx,0
je error11
jne mul_11

check_minus1:
cmp ax,'-'                   
je check_znak1
jne check_probel1

check_znak1:
cmp bl,1
je set_znak1
jne error11

set_znak1:
mov bh,1
mov bl,0
jmp next1

check_probel1:
cmp ax,' '
je this_is_probel1
jne check_number11  

this_is_probel1:
cmp bl,1
je error21
jne set_probel1

set_probel1:
mov bl,1 
jmp check_negative_number1     

check_negative_number1:    
cmp bh,1              
jne free1
je mul_11

free1:
inc bp
xor bh,bh 
push dx
xor dx,dx
xor ax,ax 
jmp next1 

mul_11:      
mov ax,-1
mul dx
mov dx,ax 
jmp free1

check_number11:
cmp ax,'0'
jae check_number21
jb error11

check_number21:
cmp ax,'9'
jbe this_is_number1
ja error11

error11:
output error_message1  
jmp input_second_string

error21:
output error_message2  
jmp input_second_string               

error31:
output error_message3  
jmp input_second_string 

error5:
output error_message5  
jmp input_second_string

this_is_number1:
cmp dx,0        
je initialize1
jne add_in_count1

initialize1:
mov bl,0
sub ax,'0'
add dx,ax  
jmp next1

add_in_count1:
sub ax,'0' 
push cx
mov cx,ax
mov ax,10 
mul dx
push dx
mov dx,ax 
add dx,cx
pop di
pop cx
cmp di,1
je error31 ;overflow
jne next_compare1  

next_compare1: 
cmp bh,1
je compare_for_negative_number1
jne compare_for_positive_number1

compare_for_negative_number1:  
cmp dx,32768
ja error31 ;overflow
jbe not_overflow1

compare_for_positive_number1:
cmp dx,32767
ja error31 ;overflow
jbe not_overflow1

not_overflow1: 
xor ax,ax
jmp next1
 
next1:
loop cicle2

check_count1:
cmp bp,2
jne error5  
je check_range_ax

check_range_ax:              ;dx>=ax
pop ax                       ;bh=1 ax-negative
pop dx                       ;bl=1 dx-negative
cmp ax,32767
ja  set_ax_negative
jbe check_range_dx

set_ax_negative:
mov bh,1
jmp check_range_dx

check_range_dx:
cmp dx,32767
ja set_dx_negative
jb compare_range

set_dx_negative:
mov bl,1
jmp compare_range

compare_range:
cmp bl,bh
je sign_equal
jne sign_not_equal

sign_equal: 
cmp ax,dx
jae find_numbers
jb error6

sign_not_equal:
cmp bl,1
je compare_range1 
jne error6              

compare_range1:
cmp dx,ax
jae find_numbers             
jb error6                   

error6:
output error_message6  
jmp input_second_string

jmp find_numbers_range                                         
check_range endp                                      
 
  
find_numbers_for_range proc  
find_numbers:
xor cx,cx

mov cl,string[1] 
mov string[1],' '
mov string[0],cl
mov si,cx
inc si

cicle3:
cmp si,0
je next_step
jne cicle4

cicle4:
mov cl,string[si]
dec si
cmp cx,' '
je matching_with_a_range 
jne cicle4  

matching_with_a_range:
pop bp
cmp bl,bh
je compare_dx_bp
jne find_sign_bp

find_sign_bp:
cmp bp,32767
ja compare_dx_bp1
jbe compare_bp_ax

compare_dx_bp1:
cmp dx,bp
jbe edit_byte1
ja edit_byte0

compare_dx_bp:
cmp dx,bp
jbe compare_bp_ax
ja edit_byte0

compare_bp_ax:
cmp bp,ax
jbe edit_byte1 
ja edit_byte0

edit_byte0:
mov string[si+1],0
jmp cicle3

edit_byte1:
mov string[si+1],1 
jmp cicle3
find_numbers_for_range endp    


unique_element proc 
xor ax,ax
xor dx,dx
xor cx,cx 
xor bx,bx
mov cl,string[0]
add cx,2
mov si,0
push si

set_si:
pop si 
jmp find_start_si


find_start_si:
inc si
mov al,string[si]
cmp al,'-'
jae find_start_si
jb check_si1

check_si1:
cmp al,'$'
je next_steps
jne check_si2

check_si2:
cmp al,0
je find_start_si
jne save_si

save_si:
push si
mov di,si
jmp find_start_di

find_start_di:
inc di
mov dl,string[di]
cmp dl,'-'
jae find_start_di
jb check_di1

check_di1:
cmp dx,'$'
je set_si
jne check_di2

check_di2:
cmp dx,0
je find_start_di
jne save_di

save_di:
mov bp,di
cicle5:     
inc si
inc di
mov al,string[si]
mov dl,string[di]
cmp ax,dx
je check_equals_symbols
jne check_notequals_symbols

check_equals_symbols:
cmp dx,'-'
jb add_flag_si
jae cicle5

add_flag_si: 
push di
mov di,bp
mov string[di],0
pop di  
dec di
pop si
mov al,string[si]
inc al
mov string[si],al
push si
jmp find_start_di

check_notequals_symbols:             ; ax-number-> bl=1
cmp dx,'-'                           ; dx-number->bh=1
jb check_ax_number
jae dx_is_number

dx_is_number:
mov bh,1
jmp check_ax_number

check_ax_number:
cmp ax,'-'
jae ax_is_number
jb check_numbers_flags

ax_is_number:
mov bl,1
jmp check_numbers_flags

check_numbers_flags:
cmp bl,bh
je flags_equals
jne flags_notequals 

flags_notequals:
cmp bh,1
je is_numbers      
jne dx_isn_number

dx_isn_number:
dec di
pop si
push si 
xor bx,bx
jmp find_start_di

flags_equals:
cmp bl,0
je isn_numbers
jne is_numbers

is_numbers:
pop si
push si  
xor bx,bx
jmp find_start_di   

isn_numbers: 
xor bx,bx
jmp add_flag_si 

unique_element endp 


print_histogramm proc 
output endl
output endl
mov si,0
xor ax,ax
xor dx,dx 
mov cx,6

find_si:
inc si
mov al,string[si]
cmp al,'-'
jae find_si
jb check_si11

check_si11:
cmp al,'$'
je finish
jne check_si21

check_si21:
cmp al,0
je find_si

push ax
data_for_print:
inc si
mov dl,string[si]
cmp dx,'-'
jae print
jbe dec_si

dec_si:
cicle6:
mov dl,' '
mov ah,6
int 21h 
loop cicle6 

pop ax
mov cl,al
cicle7:
mov dl,221
mov ah,6
int 21h
loop cicle7 

output endl
dec si 
mov cx,6 
xor ax,ax
xor dx,dx 
jmp find_si

print:
dec cx
mov ah,6
int 21h
jmp data_for_print     
print_histogramm endp    

start:
mov ax,@data
mov ds,ax
mov es,ax 

input_first_string:
output message1 

mov dx,offset string
mov string[0],209 
call input

xor bx,bx
mov bl,string[1]  
add bl,2 
mov string[bx],'$'  
call check_string 
    
input_second_string:
 
output message2

mov dx,offset range
mov range[0],13
call input

xor bx,bx
mov bl,range[1]  
add bl,2 
mov range[bx],'$'
call check_range
find_numbers_range:    
call find_numbers_for_range
next_step:
call unique_element
 
next_steps:
call print_histogramm

finish:
mov ah,4ch
int 21h
end start