.data
mem: .space 4
.text 
	# cargo la direccion de memoria inical
	# (que usaremos para vincular los leds 1 y 2)
	la a0, mem
	
	# inicializamos los registro csr
	la t0,handler	 	# cargo direccion de la rutina manejadora de excepciones
	csrrwi zero,0,1  	# activo las excepciones
	csrrw zero,5,t0  	# cargo mtvec
	csrrwi zero,68,1 	# activar la interrupciones
	
	# activamos el LED1 (29 << 2)
	addi t0,zero,1 		# encendemos el LED
	sw t0, 120(a0)
	
	# variables del loop
	addi a1,zero,10		# punto de control para lanzar except
	add t1,zero,zero 	# iniciamos el contador
	# bucle infinito	
loop:	
	addi t1,t1,1
	beq t1,a1,then
	j loop 			# es como un continue
then:   # aca gestionamos cuando llegamos al loop 50
	add t1,zero,zero 	# reiniciamos el valor de t1
	ecall 			# EBREAK 
	j loop
	
	addi a7,zero,10		# return 0
	ecall
	
handler:
	sw t1, (a0)      	# guardamos en memoria el valor del contador actual
	sw a1, 4(a0)	 	# guardo el valor del punto de control
	sw t0, 8(a0)	 	# guardo el valor del punto de control
	sw zero, 120(a0) 	# apagamos el LED_1
	addi t1,zero,1
	sw t1, 124(a0)  	# activamos el LED_2
	
	addi t2,zero,12  	# el MCAUSE de excepcion mas grande que tenemos es 11
	csrrw t3,66,zero 	# cargo el mcause
	slt t4,t3,zero     	# guardamos si MCAUSE < 0 (porque el procesador hace esta validacion con signo)
	beq t4,t1,interrupt # t4 = 1
	
	# interrup
	addi a1,zero,6		# se repetira un loop 6 veces
	add t4,zero,zero 	# iniciamos contador
loop1: 	beq a1,t4,endexcept
	addi t4,t4,1
	j loop1

interrupt:
	addi a1,zero,3
	add t4,zero,zero
loop2:	beq a1,t4,endexcept
	addi t4,t4,1
	j loop2
	
endexcept:
	sw zero, 124(a0) 	# apagamos   LED_2
	sw t1, 120(a0)   	# encendemos LED_1
	lw t1, (a0)      	# recuperamos el valor del contador
	lw a1, 4(a0)     	# recupero el valor del punto de control

	# volveremos a la ruta normal pero con la MEPC+4
	csrrw t0,65,zero
	addi t0,t0,4
	csrrw zero,65,t0
	lw t0, 8(a0)
	uret
	