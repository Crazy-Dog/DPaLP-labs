data segment 
old_cs dw 0
old_ip dw 0    
path db "some.txt",0
buf  db ?   
handle dw ? 
filelength db ?
data ends
 
astack segment stack
dw 512 dup(?)
astack ends
 
code segment 
assume cs:code, ds:data, ss:astack 
 
new_int proc far
    push ax 
    mov ah,0
    int 16h
    pop ax
    mov al, 20h
    out 20h, al
    iret
    new_int endp   

    print_file proc
     
    call delay
 
    xor ax, ax
    xor cx, cx
    xor dx,dx
  
    mov ax,3d00h   
    lea dx,path  
    int 21h    
    jc exit   
    
    mov bx,ax 

    mov ax,4202h
    mov cx, 0  
    mov dx, 0
    int 21h
    mov filelength, al  
   
    mov ax,4200h
    mov cx, 0  
    mov dx, 0
    int 21h 
           
    xor cx,cx
    xor dx,dx  
    xor ax, ax 
out_str:
    push cx 
    xor cx,cx
    xor dx,dx  
    xor ax, ax 
    mov ah,3fh      
    mov cl, 1    
    lea dx,buf   
    int 21h  
    mov ah, 02h
    mov dl,  buf
    int 21h
    
    call delay
    
    pop cx
    inc cx
    cmp cl, filelength
    jne out_str
    ret 
    print_file endp

delay proc  
    mov cx, 20
    mov dx,20000
    mov ah,86h
    int 15h     
    ret 
    delay endp

main proc far
    push ds
    sub ax, ax
    push ax
    mov ax, data
    mov ds, ax
    sub ax, ax
 
    mov ah, 35h
    mov al, 23h 
    int 21h
    mov old_ip, bx 
    mov old_cs, es 
 
 
    push ds
    mov dx, offset new_int
    mov ax, seg new_int 
    mov ds, ax
    mov ah, 25H
    mov al, 23H 
    int 21H
    pop ds

call print_file  
 
    cli
    push ds 
    mov dx,old_ip 
    mov ax,old_cs 
    mov ds, ax
    mov ah, 25h 
    mov al, 23h 
    int 21h 
    pop ds
    sti 
    ret
main endp

close:           
   mov ah,3eh
   int 21h
exit:
   mov ax, 4c00h
   int 21h

code ends 
end main    