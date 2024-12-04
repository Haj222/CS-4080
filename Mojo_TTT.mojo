from python import Python
from collections.vector import InlinedFixedVector

var size: Int = 9

fn initialize_board(inout board: InlinedFixedVector[Int, 9]):
    for i in range(9):
        board.append(0)

fn display_board(borrowed board: InlinedFixedVector[Int, 9]):
    for row in range(3):
        for col in range(3):
            if board[row * 3 + col] == 1:
                print("O", end=" ") 
            elif board[row * 3 + col] == 2:
                print("X", end=" ")  
            else:
                print(".", end=" ")  
        print()

fn is_valid_input(borrowed input: Int) -> Bool:
    return input > 0 and input <= 9

fn board_is_full(borrowed board: InlinedFixedVector[Int, 9]) -> Bool:
    for i in range(9):
        if board[i] == 0:
            return False
    return True

fn computer_move(inout board: InlinedFixedVector[Int, 9]) raises:
    var random_module = Python().import_module("random")
    if board_is_full(board):
        print("It's a tie!")
        return
    var move = atol(random_module.randint(0, 8))
    while board[move] != 0:
        move = atol(random_module.randint(0, 8))
    board[move] = 2  # Computer move represented by 2

fn determine_winner(borrowed board: InlinedFixedVector[Int, 9]) -> Int:
    for i in range(3):
        if board[i * 3] == board[i * 3 + 1] and board[i * 3 + 1] == board[i * 3 + 2]:
            return board[i * 3]
        if board[i] == board[i + 3] and board[i + 3] == board[i + 6]:
            return board[i]
    if board[0] == board[4] and board[4] == board[8]:
        return board[0]
    if board[2] == board[4] and board[4] == board[6]:
        return board[2]
    return 0

fn main() raises:
    var board = InlinedFixedVector[Int, 9](9)
    display_board(board)

    var builtins = Python().import_module("builtins")
    while True:
        if board_is_full(board):
            display_board(board)  
            print("It's a tie!")
            break
        var user_input = atol(builtins.input("Select a number between 1 and 9: "))
        if is_valid_input(user_input):
            var index = user_input - 1  
            if board[index] != 0:  
                print("The spot is already taken! Please select a different number.")
                continue  # Prompt for input again
            board[index] = 1  
            computer_move(board)
            var winner = determine_winner(board)
            if winner == 1:
                display_board(board) 
                print("You won!")
                break
            elif winner == 2:
                display_board(board)  
                print("You lost!")
                break
            display_board(board)
        else:
            print("Invalid input! Please enter a number between 1 and 9.")
