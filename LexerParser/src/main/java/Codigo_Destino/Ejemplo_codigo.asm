# Este es para algo diferente del que se ocupaba

.data
    nl:     .asciiz "\n"
    # m1:     .asciiz "Hola"
    # m2:     .asciiz "***"
    msgInputInt: .asciiz "Ingres un numero entero: "
    msgInputFloat: .asciiz "Ingrese un numero flotante: "
    adios:  .asciiz "Saliendo del programa, Adios."

.text
    jal main

    # Salida del programa
    li $v0, 10
    syscall

main:
    add $sp, $sp, -8       # Reserva espacio en la pila
    sw $ra, 0($sp)         # Guarda dirección de retorno

    # Lectura de entero
    la $a0, msgInputInt
    jal printStr
    jal readInt
    move $t3, $v0          # Guardamos int1 en $t3

    # Lectura de flotante
    la $a0, msgInputFloat
    jal printStr
    jal readFloat
    mov.s $f2, $f0         # Guardamos float1 en $f2


    # ====== >> De aqui en adelante es para imprimir.

    # Salto de línea
    la $a0, nl
    jal printStr

    # Imprimir entero
    move $a0, $t3
    jal printInt

    la $a0, nl
    jal printStr

    # Imprimir flotante
    mov.s $f12, $f2
    jal printFloat

    la $a0, nl
    jal printStr

    # Imprimir el mensaje de despedida.
    la $a0, adios
    jal printStr

    # Restaurar, sacar de la pila la direccion de retorno y volver al text para cerrar.
    lw $ra, 0($sp)
    add $sp, $sp, 8
    jr $ra

#*******************************************SYSCALL*****************************************************

# Esta imprime un string.
printStr:
    li $v0, 4
    syscall
    jr $ra
.end printStr

# Esta imprime un entero
printInt:
    li $v0, 1
    syscall
    jr $ra
.end printInt

#  Esta imprime un flotante.
printFloat:
    li $v0, 2
    syscall
    jr $ra
.end printFloat

# Este lee un entero.
readInt:
    li $v0, 5
    syscall
    jr $ra
.end readInt

# Ente lee un flotante.
readFloat:
    li $v0, 6
    syscall
    jr $ra
.end readFloat
