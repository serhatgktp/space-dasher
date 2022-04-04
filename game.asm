#####################################################################
#
# CSCB58 Winter 2022 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Efkan Serhat Goktepe, 1005939166, goktepee, serhat.goktepe@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

###############
## REGISTERS ##
###############
# $s0 -> BASE_ADDRESS
# $s1 -> CHARACTER_START_ADDRESS
# $s2 -> 
# $s3 -> 
# $s4 -> 
# $s5 -> 
# $s6 -> Has the character double-jumped since it last landed? (Boolean to prevent jumping more than twice)
# $s7 -> Loop counter


.eqv BASE_ADDRESS 0x10008000    # Base address of the screen for 4x4 Unit 256x256 display
.eqv MS_PER_FRAME 33            # Miliseconds to sleep after each loop
# .eqv MS_PER_FRAME 250
.eqv ROW_LENGTH   256           # Row length
.eqv CHARACTER_START_ADDRESS 0x10008f0c
.eqv PLATFORM_ADDRESS_1_1 0x1000a00c    # 32 rows below base address
.eqv PLATFORM_ADDRESS_1_2 0x1000ab3c    # 32 rows below base address
.eqv PLATFORM_ADDRESS_1_3 0x1000ac74    # 32 rows below base address
.eqv PLATFORM_ADDRESS_1_4 0x1000a8b0    # 32 rows below base address
.eqv GRAVITY_TIMER 3           # How many seconds should pass between each gravity tick
.eqv BACKGROUND_COLOR 0x000000  # Black

.data
    padding:	.space	36000   #Empty space to prevent game data from being overwritten due to large bitmap size
    newline:    .asciiz "\n"

.text

.globl main

main:
    li $s0, BASE_ADDRESS # $s0 stores the base address for display
    li $s1, CHARACTER_START_ADDRESS # $s1 stores the top-left pixel of the character

    #Initial 2 second wait to allow user to prepare by selecting keyboard simulator 
    li $v0 32
    li $a0 2000
    syscall

###############
## MAIN LOOP ##
###############

# Pre-loop code
jal clear_screen

li $s7, 0   # Loop counter
li $s6 0    # Player jump counter
jal draw_character

li $t1, PLATFORM_ADDRESS_1_1
addi $sp, $sp, -4
sw $t1, 0($sp)      # Push platform base address to $sp
jal draw_platform_short

li $t1, PLATFORM_ADDRESS_1_2
addi $sp, $sp, -4
sw $t1, 0($sp)      # Push platform base address to $sp
jal draw_platform_short

li $t1, PLATFORM_ADDRESS_1_3
addi $sp, $sp, -4
sw $t1, 0($sp)      # Push platform base address to $sp
jal draw_platform_short

li $t1, PLATFORM_ADDRESS_1_4
addi $sp, $sp, -4
sw $t1, 0($sp)      # Push platform base address to $sp
jal draw_platform_short

# Main Loop
main_game_loop:

    li $v0, 1
    add $a0, $s7, $zero
    syscall
    addi $s7, $s7, 1

    li $v0, 4
    la $a0, newline
    syscall

    jal check_keypress  # Check if key was pressed and execute respective functions

    jal frame_sleep

    li $t0, GRAVITY_TIMER  # Repetition timer for gravity
    div $s7, $t0
    mfhi $t0    # Store remainder of loop ctr / GRAVITY_TIMER in $t0
    bne $t0, $zero, main_game_loop  # If $s7 (loop ctr) is a multiple of GRAVITY_TIMER, apply gravity. Otherwise, ignore gravity
    jal gravity

    j main_game_loop


#-------------------------------------------#
#---------------- FUNCTIONS ----------------#
#-------------------------------------------#

####################
## DRAW CHARACTER ##
####################
draw_character:
    li $t1, 0xad5745 # rose gold
    li $t2, 0xad9296 # gray-pink

    # Draw character
    sw $t2, 0($s1)
    sw $t1, 4($s1)
    sw $t1, 8($s1)
    sw $t1, 12($s1)
    sw $t2, 16($s1)
    sw $t1, 256($s1) # paint the first unit on the second row blue. Why +256?
    sw $t1, 272($s1)
    sw $t2, 512($s1)
    sw $t1, 516($s1)
    sw $t1, 520($s1)
    sw $t1, 524($s1)
    sw $t2, 528($s1)
    sw $t2, 776($s1)
    sw $t2, 1028($s1)
    sw $t2, 1036($s1)
    sw $t2, 1028($s1)
    sw $t2, 1280($s1)
    sw $t2, 1296($s1)

    jr $ra

delete_character:
    li $t0, BACKGROUND_COLOR
    sw $t0, 0($s1)
    sw $t0, 4($s1)
    sw $t0, 8($s1)
    sw $t0, 12($s1)
    sw $t0, 16($s1)
    sw $t0, 256($s1)
    sw $t0, 272($s1)
    sw $t0, 512($s1)
    sw $t0, 516($s1)
    sw $t0, 520($s1)
    sw $t0, 524($s1)
    sw $t0, 528($s1)
    sw $t0, 776($s1)
    sw $t0, 1028($s1)
    sw $t0, 1036($s1)
    sw $t0, 1028($s1)
    sw $t0, 1280($s1)
    sw $t0, 1296($s1)
    jr $ra

####################
## DRAW PLATFORMS ##
####################

draw_platform_short:
    li $t0 0x6bad00 # lime
    
    lw $t1, 0($sp)      # Pop platform address from $sp
    addi $sp, $sp, 4

    sw $t0, 0($t1)
    sw $t0, 4($t1)
    sw $t0, 8($t1)
    sw $t0, 12($t1)
    sw $t0, 16($t1)
    sw $t0, 20($t1)
    sw $t0, 24($t1)
    sw $t0, 256($t1)
    sw $t0, 260($t1)
    sw $t0, 264($t1)
    sw $t0, 268($t1)
    sw $t0, 272($t1)
    sw $t0, 276($t1)
    sw $t0, 280($t1)
    jr $ra

#############
## GRAVITY ##
#############

gravity:
    addi $sp, $sp, -4
    sw $ra, 0($sp)  # Store current $ra
    jal respond_to_s
    lw $ra, 0($sp)  # Load current $ra
    addi $sp, $sp, 4
    jr $ra

###########################
##  KEYBOARD CONTROLLER  ##
###########################

# Check for keypress
check_keypress:
    li $t9, 0xffff0000
    lw $t8, 0($t9)
    beq $t8, 1, keypress_happened
    jr $ra
    
keypress_happened:
    li $t9, 0xffff0000
    lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before
    beq $t2, 0x77, respond_to_w # ASCII code of 'w' is 0x77 or 97 in decimal
    beq $t2, 0x61, respond_to_a # ASCII code of 'a' is 0x61
    beq $t2, 0x73, respond_to_s # ASCII code of 'a' is 0x73
    beq $t2, 0x64, respond_to_d # ASCII code of 'd' is 0x64
    
    beq $t2, 0x57, respond_to_w # ASCII code of 'W' is 0x57 or 97 in decimal
    beq $t2, 0x41, respond_to_a # ASCII code of 'A' is 0x41
    beq $t2, 0x53, respond_to_s # ASCII code of 'S' is 0x53
    beq $t2, 0x44, respond_to_d # ASCII code of 'D' is 0x44

    # Use 'p' to restart game
    beq $t2, 0x70, main # ASCII code of 'p' is 0x70
    beq $t2, 0x50, main # ASCII code of 'P' is 0x50

    # Use 'z' to exit game
    beq $t2, 0x7A, end_program # ASCII code of 'z' is 0x7A
    beq $t2, 0x5A, end_program # ASCII code of 'Z' is 0x5A

    jr $ra

respond_to_w:
    li $t1, ROW_LENGTH
    add $t0, $s0, $t1 # Points to the first pixel of the second row
    # bge $s1, $t0, move_up   # Check that the character is not currently at the top row
    blt $s1, $t0, return_func   # If the character is currently at the top row, return without moving up

    li $t0 0x6bad00 # lime      # Check if this color is stored above the character. Return without moving if it is
    lw $t1, -256($s1)
    beq $t0, $t1, return_func
    lw $t1, -240($s1)
    beq $t0, $t1, return_func

    li $t2, 2           
    blt $s6, $t2, jump  # If the character has not jumped twice since landing, jump. Otherwise, do nothing

    # j move_up
    # j jump

    jr $ra

respond_to_a:
    li $t1, ROW_LENGTH
    div $s1, $t1    # Divide address of top-left pixel of the character by ROW_LENGTH
    mfhi $t0               # Store remainder in $t0
    # bge $t0, 3, move_left   # If the character is at least 4 pixels far from the very left of the screen, move left
    blt $t0, 3, return_func   # If the character is touching the left of the screen, return without moving left

    li $t1 0x6bad00 # lime      # Check if this color is stored on the left of the character. Return without moving if it is
    lw $t0, -4($s1)
    beq $t0, $t1, return_func
    lw $t0, 252($s1)
    beq $t0, $t1, return_func
    lw $t0, 508($s1)
    beq $t0, $t1, return_func
    lw $t0, 764($s1)
    beq $t0, $t1, return_func
    lw $t0, 1020($s1)
    beq $t0, $t1, return_func
    lw $t0, 1276($s1)
    beq $t0, $t1, return_func

    j move_left

    jr $ra

respond_to_s:
    # Check if character at bottom of screen
    li $t1, ROW_LENGTH
    li $t9 4
    div $t8, $t1, $t9
    sub $t0, $t8, 1
    mult $t0, $t1
    mflo $t0    # Store 256*63 in $t0
    addi $t0, $t0, BASE_ADDRESS # $t0 contains the address of the bottom-left pixel of the screen

    add $t2, $s1, 1280  # Store address bottom-left pixel of the character in $t2
    # blt $t2, $t0, move_down
    bge $t2, $t0, return_func   # If character is at bottom row, return without moving down
    
    # Check if character touching platform from above
    lw $t0, 256($t2)
    lw $t1, 272($t2)
    li $t2 0x6bad00 # lime
    beq $t0, $t2, touching_platform   # If unit below character is green, set jump counter ($s6) to 0 and return without moving down
    beq $t1, $t2, touching_platform
    
    j move_down # Move down

    jr $ra

respond_to_d:
    li $t1, ROW_LENGTH
    addi $t2, $s1, 16   # Set $t2 to address of top-right pixel 
    div $t2, $t1    # Divide address of top-right pixel of the character by ROW_LENGTH
    mfhi $t0               # Store remainder in $t0
    addi $t1, $t1, -4
    # blt $t0, $t1, move_right  # If the character is at least 4 pixels far from the very right of the screen, move right
    bge $t0, $t1, return_func   # If the character is touching the right side of the screen, return without moving right

    li $t9 0x6bad00 # lime      # Check that none of the pixels touching the right side of our character are green (platform color)
    lw $t0, 4($t2)
    beq $t0, $t9, return_func
    lw $t0, 260($t2)
    beq $t0, $t9, return_func
    lw $t0, 516($t2)
    beq $t0, $t9, return_func
    lw $t0, 772($t2)
    beq $t0, $t9, return_func
    lw $t0, 1028($t2)
    beq $t0, $t9, return_func
    lw $t0, 1284($t2)
    beq $t0, $t9, return_func

    j move_right

    jr $ra

################
##  MOVEMENT  ##
################

move_up:
    # delete old character
    addi $sp, $sp, -4
    sw $ra, 0($sp)  # Store current $ra
    jal delete_character
    lw $ra, 0($sp)  # Load current $ra
    addi $sp, $sp, 4

    # draw new character
    sub $s1, $s1, ROW_LENGTH
    j draw_character
    jr $ra

move_left:
    # delete old character
    addi $sp, $sp, -4
    sw $ra, 0($sp)  # Store current $ra
    jal delete_character
    lw $ra, 0($sp)  # Load current $ra
    addi $sp, $sp, 4

    # draw new character
    sub $s1, $s1, 4
    j draw_character
    jr $ra

move_down:
    # delete old character
    addi $sp, $sp, -4
    sw $ra, 0($sp)  # Store current $ra
    jal delete_character
    lw $ra, 0($sp)  # Load current $ra
    addi $sp, $sp, 4

    # draw new character
    addi $s1, $s1, ROW_LENGTH
    j draw_character
    jr $ra

move_right:
    # delete old character
    addi $sp, $sp, -4
    sw $ra, 0($sp)  # Store current $ra
    jal delete_character
    lw $ra, 0($sp)  # Load current $ra
    addi $sp, $sp, 4

    # draw new character
    addi $s1, $s1, 4
    j draw_character
    jr $ra

jump:
    addi $sp, $sp, -4
    sw $ra, 0($sp)  # Store current $ra
    
    addi $s6, $s6, 1    # Increment the jump counter

    jal move_up             # One jump takes the player up 7 pixels
    jal animation_sleep
    jal move_up
    jal animation_sleep
    jal move_up
    jal animation_sleep
    jal move_up
    jal animation_sleep
    jal move_up
    jal animation_sleep
    jal move_up
    jal animation_sleep
    
    lw $ra, 0($sp)  # Load current $ra
    addi $sp, $sp, 4
    jr $ra


############
##  MISC  ##
############

# Sleep for duration MS_PER_FRAME
frame_sleep:
    li $a0 MS_PER_FRAME
    li $v0, 32
    syscall
    jr $ra
    # j main_game_loop

animation_sleep:
    li $a0 10    # Sleep for 5 seconds between each animation frame
    li $v0, 32
    syscall
    jr $ra

# Clear screen
clear_screen:
    li $t0, BACKGROUND_COLOR
    li $t2, BASE_ADDRESS
    addi $t1, $t2, 16380    # $t1 = 256*64 - 4  ($t1 holds address of bottom-right pixel)
    sw $t0, 0($t2)  # paint initial pixel
    clear_screen_loop:
        addi $t2, $t2, 4    # increment pixel
        sw $t0, 0($t2)  # paint the pixel black
        beq $t2, $t1, return_func
        j clear_screen_loop

touching_platform:
    li $s6, 0
    jr $ra

return_func:    # Return any function. Assumes function was called with jal.
    jr $ra

###################
##  END PROGRAM  ##
###################
end_program:
    li $v0, 10 # terminate the program gracefully
    syscall





