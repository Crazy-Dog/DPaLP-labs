.MODEL small
.data
                    
mas  dw 3,3,51,40,3,5,6,12,3,26,8,3,11,12,44,3,34,57,71,25,84,55,6,47,74,12,3,17,13,5 
mas1 dw 3,3,7,3,3,3,3,3,3,3,3,3,3,3,3,8,7,8,8,8,8,8,8,8,8,8,8,8,8,8
str  db 'Average value: $' 
str2 db 'The most common: $'  
str3 db 'Attitude: $'   
str4 db 'Median: $'
str5 db 'Range:$' 
str6 db 'Median not found!$'
x    db 'xx,xx$'
bottom   dw 20
top   dw 55 
temp dw ?    
n = 30

.code
start:
    mov ax, @data       
    mov ds,ax    
      
    mov ah,9   
    mov dx,offset str
    int 21h  
    call average 
    
    call newLine
    mov ah,9   
    mov dx,offset str2
    int 21h 
    call theMostCommon 
    
    call newLine
    mov ah,9   
    mov dx,offset str3
    int 21h 
    call minMaxAttitude
    
    call newLine
    mov ah,9   
    mov dx,offset str4
    int 21h 
    call median   
    
    call newLine
    mov ah,9   
    mov dx,offset str5
    int 21h 
    call range
                 
quit: mov ah,4Ch           
    int 21h
      

newLine Proc
    mov ah,2  
    mov dx, 10
    int 21h  
    mov ah,2  
    mov dx, 13 
    int 21h 
    ret
    newLine ENDP 
    
average Proc
    xor dx,dx  
    mov cx,30           
    lea si,mas          
loop00: lodsw         
    add dx,ax         
    inc bx             
    loop loop00 
    mov ax,dx                        
    xor dx,dx   
    div bx 
    aam
    xchg ah,al       
    add ax,3030h
    mov word ptr x,ax
    mov ax,dx
    xor dx,dx 
    mov dx, 100
    mul dx 
    div bx
    aam
    xchg ah,al
    or ax,'00'
    mov word ptr x+3,ax  
    mov ah,9   
    mov dx,offset x
    int 21h
    ret
    average endp 

theMostCommon Proc
    xor bx,bx
    xor di,di 
    mov cx, 30
    lea si,mas           
loop10:
    lodsw
    push cx  
    push si
    mov dx,ax 
loop11:   
    lodsw
    cmp dx,ax 
    je increment
continue10:
    loop loop11   
    cmp bx,di
    ja change 
continue11:
    pop si  
    pop cx
    loop loop10 
    jmp endOfCommon      
increment:
    inc bx
    jmp continue10     
change:
    mov di,bx   
    mov temp,dx
    jmp continue11
endOfCommon:
    mov ax, temp
    aam 
    add ax,3030h 
    mov dl,ah 
    mov dh,al 
    mov ah,02 
    int 21h   
    mov dl,dh 
    int 21h              
    ret
    theMostCommon endp 

minMaxAttitude Proc
    call findMin
    call findMax
    mov ax,bx
    sub bx,dx
    xchg ax,bx
    xor dx,dx
    div bx    
    aam
    xchg ah,al       
    add ax,3030h
    mov word ptr x,ax
    mov ax,dx
    xor dx,dx 
    mov dx, 100
    mul dx 
    div bx
    aam
    xchg ah,al
    or ax,'00'
    mov word ptr x+3,ax  
    mov ah,9   
    mov dx,offset x
    int 21h  
      
    ret
    minMaxAttitude endp 

findMin Proc
    mov cx,30
    lea si,mas                   
    mov dx,[mas]
loop30:
    lodsw 
    cmp dx,ax
    ja remember1 
continue30:
    loop loop30
    jmp endOfFindMin
remember1:
    mov dx,ax
    jmp continue30 
endOfFindMin:
    ret 
    findMin endp 

findMax Proc
    mov cx,30
    lea si,mas                   
    xor bx,bx
loop40:
    lodsw 
    cmp bx,ax
    jb remember2 
continue40:
    loop loop40
    jmp endOfFindMax
remember2:
    mov bx,ax
    jmp continue40 
endOfFindMax:
    ret 
    findMax endp 

median Proc        
    mov cx,30
    lea si,mas1
loop50: 
    xor di,di
    xor bx,bx
    xor dx,dx
    lodsw
    mov di,ax
    push cx
    push si
    mov cx,30
    lea si,mas1
loop51:     
    lodsw   
    cmp di,ax
    ja less
    cmp di,ax 
    jb more
continue50:
    loop loop51
    cmp bx,dx
    je endOfMedian
    pop si
    pop cx
    loop loop50
    jmp notFound    
less:
    inc bx
    jmp continue50
more:
    inc dx 
    jmp continue50    
notFound: 
    mov ah,9   
    mov dx,offset str6
    int 21h 
    jmp here  
endOfMedian:
    pop si
    pop cx 
    mov ax,di
    aam 
    add ax,3030h 
    mov dl,ah 
    mov dh,al 
    mov ah,02 
    int 21h   
    mov dl,dh 
    int 21h
here:      
    ret 
    median endp

range Proc
    xor bx,bx 
    mov cx,30
    lea si,mas
loop60:
    lodsw
    cmp ax,bottom
    jb continue60
    cmp ax,top
    ja continue60
    inc bx
continue60:
    loop loop60
    mov ax,bx
    aam 
    add ax,3030h 
    mov dl,ah 
    mov dh,al 
    mov ah,02 
    int 21h   
    mov dl,dh 
    int 21h
    ret
    range endp

end start 