.model small
.stack 100h
.data
  path db "some.txt",0
 buf  db ?   
 buffer db 1024 dup('$')
 buffer2 db 1024 dup(' ') 
 handle dw ? 
 filelength db ?
.code
start:    

    mov ax,@data 
    mov ds,ax      
    call openFile   
    jc exit     
         
    call getFileLength       
     
    call readFromFile
    
    call toTheBegin  
    
    xor si, si 
    call processing  
                    
close:           
    mov ah,3eh
    int 21h
exit:           
    mov ah,4ch
    int 21h 
    
openFile proc
    mov ax,3d02h   
    lea dx,path  
    int 21h 
    ret
    openFile endp

getFileLength proc
    mov bx,ax
     
    mov ax,4202h
    mov cx, 0  
    mov dx, 0
    int 21h
    mov filelength, al   
   
    call toTheBegin
    ret
    getFileLength endp

readFromFile proc
    xor cx,cx
    xor dx,dx  
    xor ax, ax 
    mov ah,3fh      
    mov cl, filelength    
    lea dx,buffer     
    int 21h  
    
    call toTheBegin 
    
    mov ah, 40h
    mov cl, filelength   
    lea dx, buffer2
    int 21h 
    ret 
    readFromFile endp

toTheBegin proc 
    mov ax,4200h
    mov cx, 0  
    mov dx, 0
    int 21h
    ret 
    toTheBegin endp 

write proc 
    mov al, buffer[si]
    mov buf, al
    mov ah, 40h
    mov cx, 1    
    lea dx, buf
    int 21h  
    inc si
    ret 
    write endp

processing proc    
    cmp buffer[si], 0Dh
    je  here  
    cmp buffer[si], '$'
    je continue
    call write         
sycl:       
    cmp buffer[si], 0DH
    je one       
    cmp buffer[si], '$'
    je continue
    call write
    jmp sycl
here:
    add si,2      
one: 
    mov dx,si        
    inc si
    inc si
    cmp buffer[si], 0Dh
    je  one          
    cmp buffer[si], 20h
    je  space  
    cmp buffer[si], '$'
    je continue
two:      
    mov si,dx
    call write
    jmp sycl      
space:
    inc si
    cmp buffer[si], 0Dh
    je  one 
    cmp buffer[si], '$'
    je continue    
    cmp buffer[si], 20h
    jne  two         
    jmp space
continue:
    ret 
    processing endp
end start