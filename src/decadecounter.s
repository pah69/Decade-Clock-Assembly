.data
    day_in_month: .byte 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

.text
    li s1, 56    # second register
    li s2, 59    # minute register
    li s3, 23    # hour register
    li s4, 28    # day register
    li s5, 2    # month register
    li s6, 2024 # year register

setsec: # need to add a clock in here somehow
    addi s1, s1, 1
    li t1, 60
    beq s1, t1, setmin 
    j setsec

setmin: # minute count increments by 1 everytime second count reaches 60
    addi s2, s2, 1
    li s1, 0
    li t1, 60
    beq s2, t1, sethour
    j setsec

sethour: # hour count increments by 1 everytime minute count reaches 60
    addi s3, s3, 1
    li s2, 0
    li t1, 24
    beq s3, t1, setday
    j setsec

setday:
    addi s4, s4, 1
    li s3, 0
    j checkmonth 

checkmonth:
    la t2, day_in_month
    add t2, t2, s5
    addi t2, t2, -1
    lb t3, 0(t2) # load address of t2 position of day_in_month (checking no. of day in the month)
    li t1, 2
    beq s5, t1, leapyear 
skip:
    bgt s4, t3, setmonth
    j setsec
leapyear:   
    li t1, 4
    rem t4, s6, t1
    bnez t4, skip
    li t1 , 100
    rem t4, s6, t1
    beqz t4, skip 
    addi t3, t3, 1 # check leap year
    j skip

setmonth:
    addi s5, s5, 1
    li s4, 1
    li t1, 13
    beq s5, t1, setyear
    j setsec

setyear:
    addi s6, s6, 1
    li s5, 1
    j setsec
