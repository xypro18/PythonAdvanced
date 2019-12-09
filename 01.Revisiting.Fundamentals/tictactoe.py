# we'll use this builtin package to easily cycle between players and switch them
from itertools import cycle

# the win function
def win(current_game):
    outcome = ''
    # horizontal
    for row in game:
        if row.count(row[0]) == len(row) and row[0] != 0:
            outcome = f"Player {row[0]} is the winner horizontally!"
    # vertical
    for col in range(len(game[0])):
        check = []
        for row in game:
            check.append(row[col])
        if check.count(check[0]) == len(check) and check[0] != 0:
            outcome = f"Player {check[0]} is the winner vertically!"

    # / diagonal
    diags = []
    cols = list(reversed(range(len(game))))
    rows = range(len(game))

    for idx in rows:
        diags.append(game[idx][cols[idx]])
    
    if diags.count(diags[0]) == len(diags) and diags[0] != 0:
        outcome = f"Player {diags[0]} has won Diagonally (/)"

    # \ diagonal
    diags = []
    for ix in range(len(game)):
        diags.append(game[ix][ix])

    if diags.count(diags[0]) == len(diags) and diags[0] != 0:
        outcome = f"Player {diags[0]} has won Diagonally (\\)"
    
    return outcome


# the custom exception for the cheating error
class CheatingError(Exception):
    pass

# our board and game manager
def game_board(game_map, player=0, row=0, column=0, just_display=False):
    try:
        if not just_display:
            if game_map[row][column] == 0:
                game_map[row][column] = player
            else:
                raise CheatingError
        print("   0  1  2")
        for count, row in enumerate(game_map):
            print(count, row)
    except IndexError:
        print("Did you attempt to play a row or column outside the range of 0, 1 or 2?")
        return False
    except CheatingError:
        print("That spot is already taken. Focus!")
        return False
    except:
        print("Something went terribly wrong.")
        return False
    return True

# the main loop of the game
play = True
players = [1, 2]
while play:
    game = [[0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]]

    game_won = False
    player_cycle = cycle([1, 2])
    game_board(game, just_display=True)
    while not game_won:
        current_player = next(player_cycle)
        played = False
        while not played:
            print(f"Player: {current_player}")
            column_choice = int(input("Which column? "))
            row_choice = int(input("Which row? "))
            played = game_board(game, player=current_player, row=row_choice, column=column_choice)
            has_won = win(game)
        if has_won != '':
            game_won = True
            print(has_won)
            again = input("The game is over, would you like to play again? (y/n) ")
            if again.lower() == "y":
                print("Restarting!")
            elif again.lower() == "n":
                print("Byeeeee!!!")
                play = False
            else:
                print("Not a valid answer, but... c ya!")
                play = False