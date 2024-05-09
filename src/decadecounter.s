.text
    li s1, 0
    li s2, 0
    li s3, 0
    li s4, 1
    li s5, 1
    li s4, 2024

setday:
    add s4, s4, 1
    li s3, 0
    j setsec

sethour:
    add s3, s3, 1
    li s2, 0
    beq s3, 24, setday
    j setsec

setmin:
    add s2, s2, 1
    li s1, 0
    beq s2, 60, sethour
    j setsec

setsec:
    add s1, s1, 1
    beq s1, 60, setmin
    j setsec
    