.text
main:
    # initialize value
    li s1, 0    # second
    li s2, 0    # minute
    li s3, 0    # hour
    li s4, 1    # day
    li s5, 1    # month
    li s6, 2024 # year
main_loop:
    jal display
    main_loop_cont:
    jal setsec
    j main_loop

# DELAY TAGS
delay:
    li  t2, 1200             # Load n value to t2
    #li  t2, 5             # low delay for debug
    #li  t3, 0x01
loop_delay:
    addi t2, t2, -1    # t2 = t2 - t3
    bnez t2, loop_delay      # Loop until t2 = 0
    jr ra    

# TIME TAGS
setsec:
    addi s1, s1, 0x01
    jal delay
    li t3, 60              # limit for sec 0x3C
    beq s1, t3, setmin
    j main_loop

setmin:
    li s1, 0                # reset second
    addi s2, s2, 0x01
    li t3, 60               # limit for min
    beq s2, t3, sethour
    j main_loop

sethour:
    li s2, 0                # reset minute
    addi s3, s3, 0x01
    li t3, 24               #limit for hour
    beq s3, t3, setday
    j main_loop

# DATE TAGS
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
    j main_loop

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
    j main_loop

setyear:
    addi s6, s6, 1
    li s5, 1
    j main_loop

# DISPLAY TAGS:
# contain: based number from 0 to 9, colon
# cointain tag: clear_display, display

display:
    # la t6, <position>

    jal clear_display

    li t3, 10
    div t1, s1, t3
    la t6, position_s1
    jal display_sort

    li t3, 10
    mul t1, t1, t3
    sub t1, s1, t1
    la t6, position_s0
    jal display_sort

    li t3, 10
    div t1, s2, t3
    la t6, position_m1
    jal display_sort

    li t3, 10 
    mul t1, t1, t3
    sub t1, s2, t1
    la t6, position_m0
    jal display_sort

    li t3, 10
    div t1, s3, t3
    la t6, position_h1
    jal display_sort

    li t3, 10 
    mul t1, t1, t3
    sub t1, s3, t1
    la t6, position_h0
    jal display_sort

    j main_loop_cont

display_sort:
    li t3, 1
    beq t1, t3, n_1

    li t3, 2
    beq t1, t3, n_2

    li t3, 3
    beq t1, t3, n_3

    li t3, 4
    beq t1, t3, n_4

    li t3, 5
    beq t1, t3, n_5

    li t3, 6
    beq t1, t3, n_6

    li t3, 7
    beq t1, t3, n_7
   
    li t3, 8
    beq t1, t3, n_8
    
    li t3, 9
    beq t1, t3, n_9

    li t3, 0
    beq t1, t3, n_0
    
    jr ra

clear_display:
    li  a0, 0x101        
    li  a1, 0x00000000
    ecall   # ecall 0x102 is for set pixel at (2;4) to red 
    jr ra   

#colon ":"
colon:
    li a0, 0x100 # set indivisual dot
    li a1, 0x00010003 # a1[31:16] is x, [15:0] is y
    li a2, 0x00FF0000 #red
    ecall
    li a1, 0x00010005 # a1[31:16] is x, [15:0] is y
    li a2, 0x00FF0000 #red
    ecall

# 01
n_1:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_1_array
    #la t6, position
n_1_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_1_loop
    jr ra

# 02
n_2:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_2_array
    #la t6, position
n_2_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_2_loop
    jr ra

# 03
n_3:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_3_array
    #la t6, position
n_3_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_3_loop
    jr ra

# 04
n_4:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_4_array
    #la t6, position
n_4_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_4_loop
    jr ra

# 05
n_5:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_5_array
    #la t6, position
n_5_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_5_loop
    jr ra

# 06
n_6:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_6_array
    #la t6, position
n_6_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_6_loop
    jr ra    

# 07
n_7:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_7_array
    #la t6, position
n_7_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_7_loop
    jr ra

# 08
n_8:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_8_array
    #la t6, position
n_8_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_8_loop
    jr ra

# 07
n_9:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_9_array
    #la t6, position
n_9_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_9_loop
    jr ra

# 00
n_0:
    li a0, 0x100 # set indivisual dot
    li t4, 26
    la t5, num_0_array
    #la t6, position
n_0_loop:
    addi t4, t4, -1
    lw a1, 0(t6)
    lw a2, 0(t5)
    ecall
    addi t5, t5, 4
    addi t6, t6, 4
    bnez t4, n_0_loop
    jr ra

####################################################
            ##########################
            # ____    _  _____  _    #
            #|  _ \  / \|_   _|/ \   #
            #| | | |/ _ \ | | / _ \  #
            #| |_| / ___ \| |/ ___ \ #
            #|____/_/   \_\_/_/   \_\#
            ##########################
####################################################
.data
day_in_month: .byte 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31

position_h1:   # x,y
    # row 0
    .word 0x00000000
    .word 0x00010000
    .word 0x00020000
    # row 1
    .word 0x00000001
    .word 0x00010001
    .word 0x00020001
    # row 2
    .word 0x00000002
    .word 0x00010002
    .word 0x00020002
    # row 3
    .word 0x00000003
    .word 0x00010003
    .word 0x00020003
    # row 4
    .word 0x00000004
    .word 0x00010004
    .word 0x00020004
    # row 5
    .word 0x00000005
    .word 0x00010005
    .word 0x00020005
    # row 6
    .word 0x00000006
    .word 0x00010006
    .word 0x00020006
    # row 7
    .word 0x00000007
    .word 0x00010007
    .word 0x00020007
    # row 8
    .word 0x00000008
    .word 0x00010008
    .word 0x00020008

position_h0:   # x,y
    # row 0
    .word 0x00040000
    .word 0x00050000
    .word 0x00060000
    # row 1
    .word 0x00040001
    .word 0x00050001
    .word 0x00060001
    # row 2
    .word 0x00040002
    .word 0x00050002
    .word 0x00060002
    # row 3
    .word 0x00040003
    .word 0x00050003
    .word 0x00060003
    # row 4
    .word 0x00040004
    .word 0x00050004
    .word 0x00060004
    # row 5
    .word 0x00040005
    .word 0x00050005
    .word 0x00060005
    # row 6
    .word 0x00040006
    .word 0x00050006
    .word 0x00060006
    # row 7
    .word 0x00040007
    .word 0x00050007
    .word 0x00060007
    # row 8
    .word 0x00040008
    .word 0x00050008
    .word 0x00060008
    
position_m1:   # x,y
    # row 0
    .word 0x000A0000
    .word 0x000B0000
    .word 0x000C0000
    # row 1
    .word 0x000A0001
    .word 0x000B0001
    .word 0x000C0001
    # row 2
    .word 0x000A0002
    .word 0x000B0002
    .word 0x000C0002
    # row 3
    .word 0x000A0003
    .word 0x000B0003
    .word 0x000C0003
    # row 4
    .word 0x000A0004
    .word 0x000B0004
    .word 0x000C0004
    # row 5
    .word 0x000A0005
    .word 0x000B0005
    .word 0x000C0005
    # row 6
    .word 0x000A0006
    .word 0x000B0006
    .word 0x000C0006
    # row 7
    .word 0x000A0007
    .word 0x000B0007
    .word 0x000C0007
    # row 8
    .word 0x000A0008
    .word 0x000B0008
    .word 0x000C0008

position_m0:   # x,y
    # row 0
    .word 0x000E0000
    .word 0x000F0000
    .word 0x00100000
    # row 1
    .word 0x000E0001
    .word 0x000F0001
    .word 0x00100001
    # row 2
    .word 0x000E0002
    .word 0x000F0002
    .word 0x00100002
    # row 3
    .word 0x000E0003
    .word 0x000F0003
    .word 0x00100003
    # row 4
    .word 0x000E0004
    .word 0x000F0004
    .word 0x00100004
    # row 5
    .word 0x000E0005
    .word 0x000F0005
    .word 0x00100005
    # row 6
    .word 0x000E0006
    .word 0x000F0006
    .word 0x00100006
    # row 7
    .word 0x000E0007
    .word 0x000F0007
    .word 0x00100007
    # row 8
    .word 0x000E0008
    .word 0x000F0008
    .word 0x00100008

position_s1:   # x,y
    # row 0
    .word 0x00140000
    .word 0x00150000
    .word 0x00160000
    # row 1
    .word 0x00140001
    .word 0x00150001
    .word 0x00160001
    # row 2
    .word 0x00140002
    .word 0x00150002
    .word 0x00160002
    # row 3
    .word 0x00140003
    .word 0x00150003
    .word 0x00160003
    # row 4
    .word 0x00140004
    .word 0x00150004
    .word 0x00160004
    # row 5
    .word 0x00140005
    .word 0x00150005
    .word 0x00160005
    # row 6
    .word 0x00140006
    .word 0x00150006
    .word 0x00160006
    # row 7
    .word 0x00140007
    .word 0x00150007
    .word 0x00160007
    # row 8
    .word 0x00140008
    .word 0x00150008
    .word 0x00160008

position_s0:   # x,y
    # row 0
    .word 0x00180000
    .word 0x00190000
    .word 0x001A0000
    # row 1
    .word 0x00180001
    .word 0x00190001
    .word 0x001A0001
    # row 2
    .word 0x00180002
    .word 0x00190002
    .word 0x001A0002
    # row 3
    .word 0x00180003
    .word 0x00190003
    .word 0x001A0003
    # row 4
    .word 0x00180004
    .word 0x00190004
    .word 0x001A0004
    # row 5
    .word 0x00180005
    .word 0x00190005
    .word 0x001A0005
    # row 6
    .word 0x00180006
    .word 0x00190006
    .word 0x001A0006
    # row 7
    .word 0x00180007
    .word 0x00190007
    .word 0x001A0007
    # row 8
    .word 0x00180008
    .word 0x00190008
    .word 0x001A0008

num_1_array:    # Color only
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00000000
    # row 2
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00000000
    # row 3
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00000000
    # row 4
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00000000
    # row 5
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00000000
    # row 6
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00000000
    # row 7
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00000000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

num_2_array:    # Color only
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 2
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 3
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 4
    .word 0x00000000
    .word 0x00000000
    .word 0x00FF0000
    # row 5
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 6
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00000000
    # row 7
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

num_3_array:    # Color only
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 2
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 3
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 4
    .word 0x00000000
    .word 0x00000000
    .word 0x00FF0000
    # row 5
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 6
    .word 0x00000000
    .word 0x00000000
    .word 0x00FF0000
    # row 7
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

num_4_array:
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 2
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 3
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 4
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 5
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 6
    .word 0x00000000
    .word 0x00000000
    .word 0x00FF0000
    # row 7
    .word 0x00000000
    .word 0x00000000
    .word 0x00FF0000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

num_5_array:
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 2
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00000000
    # row 3
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00000000
    # row 4
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00000000
    # row 5
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 6
    .word 0x00000000
    .word 0x00000000
    .word 0x00FF0000
    # row 7
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

num_6_array:
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 2
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 3
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 4
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00000000
    # row 5
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 6
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 7
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

num_7_array:
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 2
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 3
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 4
    .word 0x00000000
    .word 0x00000000
    .word 0x00FF0000
    # row 5
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 6
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00000000
    # row 7
    .word 0x00000000
    .word 0x00FF0000
    .word 0x00000000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

num_8_array:
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 2
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 3
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 4
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 5
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 6
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 7
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

num_9_array:
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 2
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 3
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 4
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 5
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 6
    .word 0x00000000
    .word 0x00000000
    .word 0x00FF0000
    # row 7
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000

num_0_array:
    # row 0
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
    # row 1
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 2
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 3
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 4
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 5
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 6
    .word 0x00FF0000
    .word 0x00000000
    .word 0x00FF0000
    # row 7
    .word 0x00FF0000
    .word 0x00FF0000
    .word 0x00FF0000
    # row 8
    .word 0x00000000
    .word 0x00000000
    .word 0x00000000
