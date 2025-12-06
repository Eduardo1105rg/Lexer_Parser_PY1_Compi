.data
        contadorGlobal: .word 100
        pi: .float 3.14159
        activo: .word 1
        inicial: .byte 'A'
        mensaje: .asciiz "Hola Mundo"
.text
    jal FUNC_principal
    li $v0, 10
    syscall

.text
suma:
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    lw $t1, 4($sp)
    lw $t2, 8($sp)
    add $t0, $t1, $t2
    move $t0, $t0
    sw $t0, 12($sp)
    lw $v0, 12($sp)
    lw $ra, 0($sp)
    addi $sp, $sp, 20
    jr $ra
main:
    addi $sp, $sp, -52
    sw $ra, 0($sp)
    li $t0, 25
    sw $t0, 4($sp)
    li $t1, 5
    li $t2, 2
    mult $t1, $t2
    mflo $t0
    li $t1, 10
    move $t2, $t0
    add $t0, $t1, $t2
    move $t0, $t0
    sw $t0, 24($sp)
    div $t1, $t2
    mflo $t0
    move $t0, $t0
    sw $t0, 28($sp)
    # Potencia no implementada: usa rutina auxiliar o bucle
    li $t0, 10
    sw $t0, 40($sp)
    lw $t1, 40($sp)
    li $t2, 1
    add $t0, $t1, $t2
    li $t0, 5
    sw $t0, 44($sp)
    lw $t1, 44($sp)
    li $t2, 1
    sub $t0, $t1, $t2
    # main no retorna valor
    lw $ra, 0($sp)
    addi $sp, $sp, 52
    jr $ra