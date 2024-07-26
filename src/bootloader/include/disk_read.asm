	; Args:
	; al -> number of sectors to read
	; dl -> drive number
	; es:bx -> mem location

MSG_DISK_ERROR: db "Error reading disk...",0
MSG_SECTOR_ERROR: db "Error: wrong number or sectors [reading disk]...",0

disk_read:
	pusha
	mov ah, 0x2; Disk read
	mov cl, 0x2; Sector to read
	mov ch, 0x0; Cylinder
	;dl is set by qemu
	mov dh, 0x0; head number

	int 0x13
	jc  .disk_error

	cmp al, 0x1
	jne .sector_error
	popa
	ret

.disk_error:
	mov  bx, MSG_DISK_ERROR
	call print
	jmp  $

.sector_error:
	mov  bx, MSG_SECTOR_ERROR
	call print
	jmp  $

