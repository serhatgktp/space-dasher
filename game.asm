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

.eqv BASE_ADDRESS 0x10008000
.text
li $t0, BASE_ADDRESS # $t0 stores the base address for display

####################
## DRAW CHARACTER ##
####################
li $t1, 0xad5745 # $t1 stores the blue colour code
li $t2, 0xad9296 # gray-pink



sw $t2, 0($t0)
sw $t1, 4($t0)
sw $t1, 8($t0)
sw $t1, 12($t0)
sw $t2, 16($t0)
sw $t1, 256($t0) # paint the first unit on the second row blue. Why +256?
sw $t1, 272($t0)
sw $t2, 512($t0)
sw $t1, 516($t0)
sw $t1, 520($t0)
sw $t1, 524($t0)
sw $t2, 528($t0)
sw $t2, 776($t0)
sw $t2, 1028($t0)
sw $t2, 1036($t0)
sw $t2, 1028($t0)
sw $t2, 1280($t0)
sw $t2, 1296($t0)

li $v0, 10 # terminate the program gracefully
syscall

#li $t9, 0xffff0000
#lw $t8, 0($t9)
#beq $t8, 1, keypress_happened

#lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before
#beq $t2, 0x61, respond_to_a # ASCII code of 'a' is 0x61 or 97 in decimal

