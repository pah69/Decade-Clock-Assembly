.text
    li s1, 0
    li s2, 0
    li s3, 0
    li s4, 1
    li s5, 1
    li s6, 2024

setsec:
    addi s1, s1, 1
    li t1, 60
    beq s1, t1, setmin
    j setsec

setday:
    addi s4, s4, 1
    li s3, 0
    j setsec

sethour:
    addi s3, s3, 1
    li s2, 0
    li t1, 24
    beq s3, t1, setday
    j setsec

setmin:
    addi s2, s2, 1
    li s1, 0
    li t1, 60
    beq s2, t1, sethour
    j setsec
    