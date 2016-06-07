# Sudoku-Solver
This is a MIPS program that can solve sudoku puzzles.

In the dot data section, you can enter in your sudoku puzzle under the "BOARD" label.
ZEROS are used to represent empty board entries. 
There is already a predefined board in the program, use this as a reference on how to construct future boards that need to be solved.

This program solves the sudoku puzzle by recurrsion. Thus, the output of this program is all the backtracks between the cells that were called in order to solve the puzzle. At the end, the program will output the solution board for the provided puzzle. 
