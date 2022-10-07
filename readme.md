# Space Dasher 👾

A fun little platformer game written in MIPS assembly language! This is a modest piece of work and leaves much to be desired! However, if you are playing this game you are likely either a comp-sci student or a recruiter, and you seek technicality within the game rather than enticing gameplay experience!

## SETUP

Run `game.asm` with your assembly interpreter and connect it to a bitmap display that matches the specifications in the assembly code. Then, forward your keyboard inputs to be stored at address `0xffff0000` and voila! You are now running the game.

For an all-in-one package, you may install [MARS MIPS Simulator](http://courses.missouristate.edu/kenvollmar/mars/) and simply import game.asm. Then on the top bar navigate to 'Tools > Keyboard and Display MMIO Simulator' and 'Tools > Bitmap Display'.
Configure your bitmap display settings to match the specifications mentioned in the comments at the top of `game.asm`, and then hit 'Connect to MIPS' on both the keyboard simulator and bitmap display.

The game will launch when you assemble and run the program!

## OBJECTIVE

The objective of the game is to beat all three levels by jumping from one platform to another and reaching the cyan "end-platform".
Beware! If you fall to the bottom of the level, you lose!

You may also gather golden coins that are scattered across each level to increase your score! If you complete the game, your final score will be displayed on the victory screen.

## ABILITIES

In addition to being able to move in all directions, our character Steve is able to double-jump, and even dash towards the left or right!
However, Steve may only jump twice and dash once before landing on a platform.

## CONTROLS

Jump - **W**

Descend (faster) - **S**

Move left - **A**

Move right - **D**

Dash left - **Q**

Dash right - **E**

Restart - **P**

Quit - **Z**

## IMPLEMENTED FEATURES

- Milestone 1
- Milestone 2
- 3A) Score
- 3B) Fail Condition
- 3C) Win Condition
- 3G) Different Levels
- 3K) Double Jump
- 3L) Mid-air dash
