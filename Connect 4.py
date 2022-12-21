#this is the board, a 6x7, with column numbers, and a phantom row to aid with adding tokens
board = [["O"]*7 for i in range(6)]
board.append(["0","1","2","3","4","5","6"])
board.append([-3,-3,-3,-3,-3,-3,-3])
#this indicates whose turn it is.
turn = "Y"
winner = ""

#this function switches turns, easy enough.
def flop_turns(turn):
    if turn == "X":
        return "Y"
    else:
        return "X"
#this function gets the input from the user - it either being a column number, or the number 99 to signal the game ending.
def user_in(turn, board):
    while True:
        try:
            inputted = int(input("Hey user " + turn + ", please either enter a column number to put your token in \n or the number 99 to end the game: "))
            #== 99 then true, out of bounds, too full
            if inputted == 99:
                return 42069
            elif inputted < 0 or inputted > 6:
                print("Not a valid column number! Please try again.")
                continue
            elif board[7][inputted] == -9:
                print("That row is full! Please try again.")
                continue
            else:
                return inputted
        except ValueError:
            print("That's not a column number or the number 99! Try again please.")
            continue
#this function places the token according to what the user wants.
def place_token(turn,col,board):
    place_row = int(board[7][col])
    board[place_row][col]= turn
    board[7][col] -= 1
#this function formats the board to print properly because having it in one row wont be helpful inniy
def print_board(board,troubleshoot = False):
    for i in range(0,7):
        print(board[i])
    if troubleshoot:
        print(board[7])
print_board(board)
#this function checks for wins. oh dearie me...
def check_win(board):
    #horizontal wins first
    for j in range(-3,-9,-1):
        for i in range(0,4,1):
            if (board[j][i] == board [j][i+1] == board[j][i+2] == board[j][i+3]) and board[j][i] != "O":
                return board[j][i]
    #vertical wins next
    for j in range(-3,-6,-1):
        for i in range(0, 7, 1):
            if (board[j][i] == board[j-1][i] == board[j-2][i] == board[j-3][i]) and board[j][i] != "O":
                return board[j][i]
    #diagonal: bottom - >top
    for j in range(-3,-6,-1):
        for i in range(0, 4, 1):
            if (board[j][i] == board[j-1][i+1] == board[j-2][i+2] == board[j-3][i+3]) and board[j][i] != "O":
                return board[j][i]
    #diagonal : top -> bottom
    for j in range(-8, -5, 1):
        for i in range(0, 4, 1):
            if (board[j][i] == board[j+1][i+1] == board[j+2][i+2] == board[j+3][i+3]) and board[j][i] != "O":
                return board[j][i]
#only needs to run 42 times you know
for i in range(42):
    turn = flop_turns(turn)
    a = user_in(turn,board)
    #input processing
    if a == 42069:
        break
    else:
        place_token(turn, a, board)
    winner = check_win(board)
    print_board(board)
    if winner == "X" or winner == "Y":
        break
if winner == "X" or winner == "Y":
    print("The winner was: " + winner)
else:
    print("It's a DRAW!")