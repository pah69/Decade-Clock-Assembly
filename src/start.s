.text
main:
    # initialize value
    li s1, 50    # second
    li s2, 59    # minute
    li s3, 23    # hour
    li s4, 28    # day
    li s5, 2    # month
    li s6, 2024 # year
main_loop:
    jal display
    main_loop_cont:
    jal setsec
    j main_loop

# DELAY TAGS
delay:
    li  t2, 1100             # Load n value to t2
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
    # to set position through display_sort > n_x use:
    # la t6, <position>

    jal clear_display 

    # second
    li t3, 10
    div t1, s1, t3
    la t6, position_s1
    jal display_sort

    li t3, 10
    mul t1, t1, t3
    sub t1, s1, t1
    la t6, position_s0
    jal display_sort

    # minutes
    li t3, 10
    div t1, s2, t3
    la t6, position_m1
    jal display_sort

    li t3, 10 
    mul t1, t1, t3
    sub t1, s2, t1
    la t6, position_m0
    jal display_sort

    # hour
    li t3, 10
    div t1, s3, t3
    la t6, position_h1
    jal display_sort

    li t3, 10 
    mul t1, t1, t3
    sub t1, s3, t1
    la t6, position_h0
    jal display_sort

    # day
    li t3, 10
    div t1, s4, t3
    la t6, position_d1
    jal display_sort

    li t3, 10 
    mul t1, t1, t3
    sub t1, s4, t1
    la t6, position_d0
    jal display_sort

    # month
    li t3, 10
    div t1, s5, t3
    la t6, position_mo1
    jal display_sort

    li t3, 10 
    mul t1, t1, t3
    sub t1, s5, t1
    la t6, position_mo0
    jal display_sort

    # year
    li t3, 10
    addi t0, s6, 0
    rem t1, t0, t3
    div t0, t0, t3
    la t6, position_y0
    jal display_sort

    li t3, 10
    rem t1, t0, t3
    div t0, t0, t3
    la t6, position_y1
    jal display_sort

    li t3, 10
    rem t1, t0, t3
    div t0, t0, t3
    la t6, position_y2
    jal display_sort

    li t3, 10
    rem t1, t0, t3
    div t0, t0, t3
    la t6, position_y3
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

position_d1:
    # row 0
    .word 0x0000000C
    .word 0x0001000C
    .word 0x0002000C
    # row 1
    .word 0x0000000D
    .word 0x0001000D
    .word 0x0002000D
    # row 2
    .word 0x0000000E
    .word 0x0001000E
    .word 0x0002000E
    # row 3
    .word 0x0000000F
    .word 0x0001000F
    .word 0x0002000F
    # row 4
    .word 0x00000010
    .word 0x00010010
    .word 0x00020010
    # row 5
    .word 0x00000011
    .word 0x00010011
    .word 0x00020011
    # row 6
    .word 0x00000012
    .word 0x00010012
    .word 0x00020012
    # row 7
    .word 0x00000013
    .word 0x00010013
    .word 0x00020013
    # row 8
    .word 0x00000014
    .word 0x00010014
    .word 0x00020014

position_d0:
    # row 0
    .word 0x0004000C
    .word 0x0005000C
    .word 0x0006000C
    # row 1
    .word 0x0004000D
    .word 0x0005000D
    .word 0x0006000D
    # row 2
    .word 0x0004000E
    .word 0x0005000E
    .word 0x0006000E
    # row 3
    .word 0x0004000F
    .word 0x0005000F
    .word 0x0006000F
    # row 4
    .word 0x00040010
    .word 0x00050010
    .word 0x00060010
    # row 5
    .word 0x00040011
    .word 0x00050011
    .word 0x00060011
    # row 6
    .word 0x00040012
    .word 0x00050012
    .word 0x00060012
    # row 7
    .word 0x00040013
    .word 0x00050013
    .word 0x00060013
    # row 8
    .word 0x00040014
    .word 0x00050014
    .word 0x00060014

position_mo1:
    # row 0
    .word 0x000A000C
    .word 0x000B000C
    .word 0x000C000C
    # row 1
    .word 0x000A000D
    .word 0x000B000D
    .word 0x000C000D
    # row 2
    .word 0x000A000E
    .word 0x000B000E
    .word 0x000C000E
    # row 3
    .word 0x000A000F
    .word 0x000B000F
    .word 0x000C000F
    # row 4
    .word 0x000A0010
    .word 0x000B0010
    .word 0x000C0010
    # row 5
    .word 0x000A0011
    .word 0x000B0011
    .word 0x000C0011
    # row 6
    .word 0x000A0012
    .word 0x000B0012
    .word 0x000C0012
    # row 7
    .word 0x000A0013
    .word 0x000B0013
    .word 0x000C0013
    # row 8
    .word 0x000A0014
    .word 0x000B0014
    .word 0x000C0014

position_mo0:
    # row 0
    .word 0x000E000C
    .word 0x000F000C
    .word 0x0010000C
    # row 1
    .word 0x000E000D
    .word 0x000F000D
    .word 0x0010000D
    # row 2
    .word 0x000E000E
    .word 0x000F000E
    .word 0x0010000E
    # row 3
    .word 0x000E000F
    .word 0x000F000F
    .word 0x0010000F
    # row 4
    .word 0x000E0010
    .word 0x000F0010
    .word 0x00100010
    # row 5
    .word 0x000E0011
    .word 0x000F0011
    .word 0x00100011
    # row 6
    .word 0x000E0012
    .word 0x000F0012
    .word 0x00100012
    # row 7
    .word 0x000E0013
    .word 0x000F0013
    .word 0x00100013
    # row 8
    .word 0x000E0014
    .word 0x000F0014
    .word 0x00100014

position_y3:
    # row 0
    .word 0x0014000C
    .word 0x0015000C
    .word 0x0016000C
    # row 1
    .word 0x0014000D
    .word 0x0015000D
    .word 0x0016000D
    # row 2
    .word 0x0014000E
    .word 0x0015000E
    .word 0x0016000E
    # row 3
    .word 0x0014000F
    .word 0x0015000F
    .word 0x0016000F
    # row 4
    .word 0x00140010
    .word 0x00150010
    .word 0x00160010
    # row 5
    .word 0x00140011
    .word 0x00150011
    .word 0x00160011
    # row 6
    .word 0x00140012
    .word 0x00150012
    .word 0x00160012
    # row 7
    .word 0x00140013
    .word 0x00150013
    .word 0x00160013
    # row 8
    .word 0x00140014
    .word 0x00150014
    .word 0x00160014

position_y2:
    # row 0
    .word 0x0018000C
    .word 0x0019000C
    .word 0x001A000C
    # row 1
    .word 0x0018000D
    .word 0x0019000D
    .word 0x001A000D
    # row 2
    .word 0x0018000E
    .word 0x0019000E
    .word 0x001A000E
    # row 3
    .word 0x0018000F
    .word 0x0019000F
    .word 0x001A000F
    # row 4
    .word 0x00180010
    .word 0x00190010
    .word 0x001A0010
    # row 5
    .word 0x00180011
    .word 0x00190011
    .word 0x001A0011
    # row 6
    .word 0x00180012
    .word 0x00190012
    .word 0x001A0012
    # row 7
    .word 0x00180013
    .word 0x00190013
    .word 0x001A0013
    # row 8
    .word 0x00180014
    .word 0x00190014
    .word 0x001A0014

position_y1:
    # row 0
    .word 0x001C000C
    .word 0x001D000C
    .word 0x001E000C
    # row 1
    .word 0x001C000D
    .word 0x001D000D
    .word 0x001E000D
    # row 2
    .word 0x001C000E
    .word 0x001D000E
    .word 0x001E000E
    # row 3
    .word 0x001C000F
    .word 0x001D000F
    .word 0x001E000F
    # row 4
    .word 0x001C0010
    .word 0x001D0010
    .word 0x001E0010
    # row 5
    .word 0x001C0011
    .word 0x001D0011
    .word 0x001E0011
    # row 6
    .word 0x001C0012
    .word 0x001D0012
    .word 0x001E0012
    # row 7
    .word 0x001C0013
    .word 0x001D0013
    .word 0x001E0013
    # row 8
    .word 0x001C0014
    .word 0x001D0014
    .word 0x001E0014

position_y0:
    # row 0
    .word 0x0020000C
    .word 0x0021000C
    .word 0x0022000C
    # row 1
    .word 0x0020000D
    .word 0x0021000D
    .word 0x0022000D
    # row 2
    .word 0x0020000E
    .word 0x0021000E
    .word 0x0022000E
    # row 3
    .word 0x0020000F
    .word 0x0021000F
    .word 0x0022000F
    # row 4
    .word 0x00200010
    .word 0x00210010
    .word 0x00220010
    # row 5
    .word 0x00200011
    .word 0x00210011
    .word 0x00220011
    # row 6
    .word 0x00200012
    .word 0x00210012
    .word 0x00220012
    # row 7
    .word 0x00200013
    .word 0x00210013
    .word 0x00220013
    # row 8
    .word 0x00200014
    .word 0x00210014
    .word 0x00220014

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
