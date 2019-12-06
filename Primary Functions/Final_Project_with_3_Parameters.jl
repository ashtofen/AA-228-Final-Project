## Project 1
# Allan Shtofenmakher
# Kochenderfer
# AA 228
# 8 November 2019

# TODO:
# for all codes:
    # add a way to count how many opponents the AI has beaten
    # figure out how to convert population alpha parameters to individual ones
    # add plots
    # clean up



## Packages
# define list of packages being used

using DataFrames
using CSV
using Distributions
using Plots



## Constants
# define values that do not change throughout the code

# define list of possible actions
rock = "rock"
paper = "paper"
scissors = "scissors"

# define list of possible outcomes
win = "win"
tie = "tie"
loss = "loss"



## Manipulable Parameters
# define values that the user can change

# define population means and standard deviation (chosen semi-arbitrarily)
rock_population_mean = 0.50
rock_population_std = 0.10
paper_population_mean = 0.20
paper_population_std = 0.05
scissors_population_mean = 0.30
scissors_population_std = 0.08

# define corresponding value for each outcome
win_value =  +1
tie_value =   0
loss_value = -1

# define competition properties
number_of_opponents = 1000
number_of_battles = 10

# initialize number_of_defeated_opponents
number_of_defeated_opponents = 0

# initialize win_tie_loss_count
win_tie_loss_count = zeros(3)

# initialize competition-level prior
competition_alpha_parameters = ones(3)



## Supplementary Functions
# define all supplementary functions internal to program

# function to determine player 1 action based on alpha_parameters
# similar to multi-armed bandit problem
function determine_player_1_action(opponent_alpha_parameters)

    # # epsilon-greedy [TEMP]
    # ϵ = rand()
    # if 0 <= ϵ <= 0.05
    #     return rock
    # elseif 0.05 < ϵ <= 0.1
    #     return paper
    # elseif 0.1 < ϵ <= 0.15
    #     return scissors
    # end

    # extract individual alpha values from alpha_parameters
    opponent_rock_alpha = opponent_alpha_parameters[1]
    opponent_paper_alpha = opponent_alpha_parameters[2]
    opponent_scissors_alpha = opponent_alpha_parameters[3]

    # determine normalization factor for multi-arm bandit problem
    normalization_factor = sum(opponent_alpha_parameters)

    # determine rock win/tie/loss probabilities
    opponent_rock_chance = opponent_rock_alpha / normalization_factor
    opponent_paper_chance = opponent_paper_alpha / normalization_factor
    opponent_scissors_chance = opponent_scissors_alpha / normalization_factor

    # determine expected value for each action
    rock_expected_value = opponent_scissors_chance * win_value + opponent_rock_chance * tie_value + opponent_paper_chance * loss_value
    paper_expected_value = opponent_rock_chance * win_value + opponent_paper_chance * tie_value + opponent_scissors_chance * loss_value
    scissors_expected_value = opponent_paper_chance * win_value + opponent_scissors_chance * tie_value + opponent_rock_chance * loss_value

    # determine maximum_expected_value of the three actions
    maximum_expected_value = maximum([rock_expected_value; paper_expected_value; scissors_expected_value])

    # determine player_1_action based on maximum_expected_value
    if rock_expected_value == maximum_expected_value
        return rock
    elseif paper_expected_value == maximum_expected_value
        return paper
    elseif scissors_expected_value == maximum_expected_value
        return scissors
    else
        # catch unexpected errors
        error("Something is seriously wrong with your determine_player_1_action() function.")
    end

end  # end determine_player_1_action() function


# function to determine player 2 action using maximum likelihood methods
function determine_player_2_action(rock_chance, paper_chance, scissors_chance)

    # change negative rock_chances to positive, if necessary
    rock_chance = abs(rock_chance)
    paper_chance = abs(paper_chance)
    scissors_chance = abs(scissors_chance)

    # normalize all probabilities
    normalization_factor = sum([rock_chance; paper_chance; scissors_chance])
    rock_chance = rock_chance / normalization_factor
    paper_chance = paper_chance / normalization_factor
    scissors_chance = scissors_chance / normalization_factor

    # generate some number between 0 and 1, inclusive
    determination_factor = rand()

    # determine player_2_action using random number generator
    if 0 <= determination_factor <= rock_chance
        return rock
    elseif rock_chance < determination_factor <= (rock_chance + paper_chance)
        return paper
    elseif (rock_chance + paper_chance) < determination_factor <= 1
        return scissors
    else
        # catch unexpected errors
        error("Something is seriously wrong with your determine_player_2_action() function.")
    end

end  # end determine_player_2_action() function


# function to determine win, tie, or loss for player 1 given both player actions
function battle(player_1_action, player_2_action)

    # ensure that inputs are valid and throw error if they're not
    @assert (player_1_action==rock) | (player_1_action=="paper") | (player_1_action=="scissors") "Invalid Input: Player 1 must use rock, paper, or scissors"
    @assert (player_1_action==rock) | (player_1_action=="paper") | (player_1_action=="scissors") "Invalid Input: Player 2 must use rock, paper, or scissors"

    # cycle through possible player_1_action values
    if player_1_action == rock

        # cycle through possible player_2_action values
        if player_2_action == rock
            return tie
        elseif player_2_action == paper
            return loss
        elseif player_2_action == scissors
            return win
        end

    elseif player_1_action == paper

        # cycle through possible player_2_action values
        if player_2_action == rock
            return win
        elseif player_2_action == paper
            return tie
        elseif player_2_action == scissors
            return loss
        end

    elseif player_1_action == scissors

        # cycle through possible player_2_action values
        if player_2_action == rock
            return loss
        elseif player_2_action == paper
            return win
        elseif player_2_action == scissors
            return tie
        end

    else

        # catch unexpected errors
        error("Something is seriously wrong with your battle function.")

    end

end  # end function battle()


# function to compute and output competition results to terminal
function print_results(opponent_alpha_parameters, win_tie_loss_count)

    # extract individual alpha values from alpha_parameters
    opponent_rock_alpha = opponent_alpha_parameters[1]
    opponent_paper_alpha = opponent_alpha_parameters[2]
    opponent_scissors_alpha = opponent_alpha_parameters[3]

    # compute total number of wins, ties, and losses
    total_wins = win_tie_loss_count[1]
    total_ties = win_tie_loss_count[2]
    total_losses = win_tie_loss_count[3]

    # compute final score
    final_score = win_value * total_wins + tie_value * total_ties + loss_value * total_losses

    # print results
    println("")
    println("")
    println(string("Opponent Rock Count:     ", Int64(opponent_rock_alpha-1)))
    println(string("Opponent Paper Count:    ", Int64(opponent_paper_alpha-1)))
    println(string("Opponent Scissors Count: ", Int64(opponent_scissors_alpha-1)))
    println("")
    println(string("Total Wins:              ", Int64(total_wins)))
    println(string("Total Ties:              ", Int64(total_ties)))
    println(string("Total Losses:            ", Int64(total_losses)))
    println("")
    println(string("Final Score:             ", Int64(final_score)))
    println("")
    println("")

end  # end print_results() function



## Main Script
# represent the competition as a for loop

# cycle through opponents
for current_opponent = 1:number_of_opponents

    # determine opponent's raw, un-normalized individual action probabilities
    opponent_raw_rock_chance = rand(  Normal(rock_population_mean, rock_population_std)  )
    opponent_raw_paper_chance = rand(  Normal(paper_population_mean, paper_population_std)  )
    opponent_raw_scissors_chance = rand(  Normal(scissors_population_mean, scissors_population_std)  )

    battle_alpha_parameters = 1*competition_alpha_parameters#./current_opponent./number_of_battles # f(competition_alpha_parameters)
    # things I've tried:
        # change the multiplier—the higher it is, the better
        # copy(competition_alpha_parameters)  # high variability between rock & paper winning
        # competition_alpha_parameters./current_opponent  # generally yields high score
        # ones(9)*10  # generally lower-scoring than others
        # ones(9)  # same as above
        # competition_alpha_parameters./current_opponent^(some power)  # needs playing with power
        # competition_alpha_parameters./sqrt(current_opponent)  # maybe
        # competition_alpha_parameters./log(current_opponent)  # maybe
        # competition_alpha_parameters./current_opponent./number_of_battles

    # explore further:
        # battle_alpha_parameters = battle_alpha_parameters./sum(battle_alpha_parameters) * sqrt(current_opponent)

    # battle current opponent
    for current_battle = 1:number_of_battles

        # determine action of player 1 based on current battle alpha parameters
        player_1_action = determine_player_1_action(battle_alpha_parameters)

        # determine action of player 2 based on individual action chances
        player_2_action = determine_player_2_action(opponent_raw_rock_chance, opponent_raw_paper_chance, opponent_raw_scissors_chance)

        # determine outcome of rock, paper, scissors game
        battle_outcome = battle(player_1_action, player_2_action)

        # update battle & competition alpha parameters based on player_2_action
        if player_2_action == rock
            # modify alpha_parameters corresponding to rock
            battle_alpha_parameters[1] = battle_alpha_parameters[1] + 1
            competition_alpha_parameters[1] = competition_alpha_parameters[1] + 1
        elseif player_2_action == paper
            # modify alpha_parameters corresponding to paper
            battle_alpha_parameters[2] = battle_alpha_parameters[2] + 1
            competition_alpha_parameters[2] = competition_alpha_parameters[2] + 1
        elseif player_2_action == scissors
            # modify alpha_parameters corresponding to scissors
            battle_alpha_parameters[3] = battle_alpha_parameters[3] + 1
            competition_alpha_parameters[3] = competition_alpha_parameters[3] + 1
        else
            # catch unexpected errors
            error("Something is seriously wrong with your player_2_action logic.")
        end

        # update win-tie-loss metrics based on battle_outcome
        if battle_outcome == win
            win_tie_loss_count[1] = win_tie_loss_count[1] + 1
        elseif battle_outcome == tie
            win_tie_loss_count[2] = win_tie_loss_count[2] + 1
        elseif battle_outcome == loss
            win_tie_loss_count[3] = win_tie_loss_count[3] + 1
        else
            # catch unexpected errors
            error("Something is seriously wrong with your battle_outcome logic.")
        end

    end

end

# compute and output results
print_results(competition_alpha_parameters, win_tie_loss_count)
