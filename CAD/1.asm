.data
screen:      .space 80       # Screen buffer (1D)
ball_pos:    .word 40        # Ball position
prompt_msg:  .asciiz "Press 'a' to move left, 'd' to move right, 'q' to quit:\n"
ball_icon:   .asciiz "O"     # ASCII football icon
newline:     .asciiz "\n"
exit_msg:    .asciiz "Game Over! Thanks for playing.\n"

.text
.globl main

main:
    # Print prompt message
    ori $v0, $zero, 4
    lui $a0, %hi(prompt_msg)
    ori $a0, $a0, %lo(prompt_msg)
    syscall

game_loop:
    # Print newline (clear screen)
    ori $v0, $zero, 4
    lui $a0, %hi(newline)
    ori $a0, $a0, %lo(newline)
    syscall

    # Draw the game screen
    jal draw_screen

    # Get user input
    ori $v0, $zero, 12      # Read a character
    syscall
    move $t1, $v0          # Store input

    # Check for 'q' (quit)
    ori $t2, $zero, 113     # ASCII for 'q'
    beq $t1, $t2, exit_game

    # Check for 'a' (move left)
    ori $t2, $zero, 97      # ASCII for 'a'
    beq $t1, $t2, move_left

    # Check for 'd' (move right)
    ori $t2, $zero, 100     # ASCII for 'd'
    beq $t1, $t2, move_right

    j game_loop

move_left:
    lui $t3, %hi(ball_pos)
    ori $t3, $t3, %lo(ball_pos)
    lw $t4, 0($t3)
    blez $t4, game_loop  # Prevent moving off-screen
    addi $t4, $t4, -1    # Move ball left
    sw $t4, 0($t3)
    j game_loop

move_right:
    lui $t3, %hi(ball_pos)
    ori $t3, $t3, %lo(ball_pos)
    lw $t4, 0($t3)
    ori $t5, $zero, 78   # Right boundary
    bge $t4, $t5, game_loop
    addi $t4, $t4, 1     # Move ball right
    sw $t4, 0($t3)
    j game_loop

draw_screen:
    lui $t3, %hi(ball_pos)
    ori $t3, $t3, %lo(ball_pos)
    lw $t3, 0($t3)
    ori $t4, $zero, 0    # Counter (x position)

draw_loop:
    bge $t4, $t3, print_ball
    ori $v0, $zero, 11   # Print character syscall
    ori $a0, $zero, 32   # Print space (' ')
    syscall
    addi $t4, $t4, 1     # Increment counter
    j draw_loop

print_ball:
    # Print ball
    ori $v0, $zero, 4
    lui $a0, %hi(ball_icon)
    ori $a0, $a0, %lo(ball_icon)
    syscall

    # Print new line
    ori $v0, $zero, 4
    lui $a0, %hi(newline)
    ori $a0, $a0, %lo(newline)
    syscall

    jr $ra              # Return

exit_game:
    # Print exit message
    ori $v0, $zero, 4
    lui $a0, %hi(exit_msg)
    ori $a0, $a0, %lo(exit_msg)
    syscall

    ori $v0, $zero, 10  # Exit program
    syscall
