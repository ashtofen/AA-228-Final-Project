## Project 1
# Allan Shtofenmakher
# Kochenderfer
# AA 228
# 8 November 2019

# TODO:
# CHANGE THE ENTIRE CODE TO FOCUS ON RPS COUNTS
# for all codes:
    # add a way to count how many opponents the AI has beaten
    # figure out how to convert population alpha parameters to individual ones
    # add plots
    # clean up
# just for old code:
    # experiment with alternative search heuristics?



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

# initialize population-level prior
population_alpha_parameters = ones(9)



## Supplementary Functions
# define all supplementary functions internal to program

# function to determine player 1 action based on alpha_parameters
# similar to multi-armed bandit problem
function determine_player_1_action(alpha_parameters)

    # # epsilon-greedy [TEMP]
    # ϵ = rand()
    # if 0 <= ϵ <= 0.05
    #     return rock
    # elseif 0.05 < ϵ <= 0.1
    #     return paper
    # elseif 0.1 < ϵ <= 0.15
    #     return scissors
    # end

    # extract rock alpha values from alpha_parameters
    rock_win_alpha = alpha_parameters[1]
    rock_tie_alpha = alpha_parameters[2]
    rock_loss_alpha = alpha_parameters[3]

    # extract paper alpha values from alpha_parameters
    paper_win_alpha = alpha_parameters[4]
    paper_tie_alpha = alpha_parameters[5]
    paper_loss_alpha = alpha_parameters[6]

    # extract paper alpha values from alpha_parameters
    scissors_win_alpha = alpha_parameters[7]
    scissors_tie_alpha = alpha_parameters[8]
    scissors_loss_alpha = alpha_parameters[9]

    # determine normalization factor for multi-arm bandit problem
    normalization_factor = sum(alpha_parameters)

    # determine rock win/tie/loss probabilities
    rock_win_chance = rock_win_alpha / normalization_factor
    rock_tie_chance = rock_tie_alpha / normalization_factor
    rock_loss_chance = rock_loss_alpha / normalization_factor

    # determine paper win/tie/loss probabilities
    paper_win_chance = paper_win_alpha / normalization_factor
    paper_tie_chance = paper_tie_alpha / normalization_factor
    paper_loss_chance = paper_loss_alpha / normalization_factor

    # determine scissors win/tie/loss probabilities
    scissors_win_chance = scissors_win_alpha / normalization_factor
    scissors_tie_chance = scissors_tie_alpha / normalization_factor
    scissors_loss_chance = scissors_loss_alpha / normalization_factor

    # determine expected value for each action
    rock_expected_value = rock_win_chance * win_value + rock_tie_chance * tie_value + rock_loss_chance * loss_value
    paper_expected_value = paper_win_chance * win_value + paper_tie_chance * tie_value + paper_loss_chance * loss_value
    scissors_expected_value = scissors_win_chance * win_value + scissors_tie_chance * tie_value + scissors_loss_chance * loss_value

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
function print_results(alpha_parameters)

    # extract rock alpha values from alpha_parameters
    rock_win_alpha = alpha_parameters[1]
    rock_tie_alpha = alpha_parameters[2]
    rock_loss_alpha = alpha_parameters[3]

    # extract paper alpha values from alpha_parameters
    paper_win_alpha = alpha_parameters[4]
    paper_tie_alpha = alpha_parameters[5]
    paper_loss_alpha = alpha_parameters[6]

    # extract paper alpha values from alpha_parameters
    scissors_win_alpha = alpha_parameters[7]
    scissors_tie_alpha = alpha_parameters[8]
    scissors_loss_alpha = alpha_parameters[9]

    # compute total number of wins, ties, and losses
    total_wins = sum([rock_win_alpha, paper_win_alpha, scissors_win_alpha]) - 3  # subtract prior
    total_ties = sum([rock_tie_alpha, paper_tie_alpha, scissors_tie_alpha]) - 3  # subtract prior
    total_losses = sum([rock_loss_alpha, paper_loss_alpha, scissors_loss_alpha]) - 3  # subtract prior

    # compute final score
    final_score = win_value * total_wins + tie_value * total_ties + loss_value * total_losses

    # print results
    println("")
    println("")
    println(string("Rock Wins:       ", Int64(rock_win_alpha-1)))
    println(string("Rock Ties:       ", Int64(rock_tie_alpha-1)))
    println(string("Rock Losses:     ", Int64(rock_loss_alpha-1)))
    println("")
    println(string("Paper Wins:      ", Int64(paper_win_alpha-1)))
    println(string("Paper Ties:      ", Int64(paper_tie_alpha-1)))
    println(string("Paper Losses:    ", Int64(paper_loss_alpha-1)))
    println("")
    println(string("Scissors Wins:   ", Int64(scissors_win_alpha-1)))
    println(string("Scissors Ties:   ", Int64(scissors_tie_alpha-1)))
    println(string("Scissors Losses: ", Int64(scissors_loss_alpha-1)))
    println("")
    println(string("Total Wins:      ", Int64(total_wins)))
    println(string("Total Ties:      ", Int64(total_ties)))
    println(string("Total Losses:    ", Int64(total_losses)))
    println("")
    println(string("Final Score:     ", Int64(final_score)))
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

    battle_alpha_parameters = population_alpha_parameters./current_opponent # f(population_alpha_parameters)
    # things I've tried:
        # copy(population_alpha_parameters)  # high variability between rock & paper winning
        # population_alpha_parameters./current_opponent  # generally yields high score
        # ones(9)*10  # generally lower-scoring than others
        # ones(9)  # same as above
        # population_alpha_parameters./current_opponent^(some power)  # needs playing with power
        # population_alpha_parameters./sqrt(current_opponent)  # maybe
        # population_alpha_parameters./log(current_opponent)  # maybe

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

        # update battle and population alpha parameters based on battle_outcome
        if player_1_action == rock

            if battle_outcome == win
                # modify alpha_parameters corresponding to (rock, win)
                battle_alpha_parameters[1] = battle_alpha_parameters[1] + 1
                population_alpha_parameters[1] = population_alpha_parameters[1] + 1
            elseif battle_outcome == tie
                # modify alpha_parameters corresponding to (rock, tie)
                battle_alpha_parameters[2] = battle_alpha_parameters[2] + 1
                population_alpha_parameters[2] = population_alpha_parameters[2] + 1
            elseif battle_outcome == loss
                # modify alpha_parameters corresponding to (rock, loss)
                battle_alpha_parameters[3] = battle_alpha_parameters[3] + 1
                population_alpha_parameters[3] = population_alpha_parameters[3] + 1
            end

        elseif player_1_action == paper

            if battle_outcome == win
                # modify alpha_parameters corresponding to (paper, win)
                battle_alpha_parameters[4] = battle_alpha_parameters[4] + 1
                population_alpha_parameters[4] = population_alpha_parameters[4] + 1
            elseif battle_outcome == tie
                # modify alpha_parameters corresponding to (paper, tie)
                battle_alpha_parameters[5] = battle_alpha_parameters[5] + 1
                population_alpha_parameters[5] = population_alpha_parameters[5] + 1
            elseif battle_outcome == loss
                # modify alpha_parameters corresponding to (paper, loss)
                battle_alpha_parameters[6] = battle_alpha_parameters[6] + 1
                population_alpha_parameters[6] = population_alpha_parameters[6] + 1
            end

        elseif player_1_action == scissors

            if battle_outcome == win
                # modify alpha_parameters corresponding to (scissors, win)
                battle_alpha_parameters[7] = battle_alpha_parameters[7] + 1
                population_alpha_parameters[7] = population_alpha_parameters[7] + 1
            elseif battle_outcome == tie
                # modify alpha_parameters corresponding to (scissors, tie)
                battle_alpha_parameters[8] = battle_alpha_parameters[8] + 1
                population_alpha_parameters[8] = population_alpha_parameters[8] + 1
            elseif battle_outcome == loss
                # modify alpha_parameters corresponding to (scissors, loss)
                battle_alpha_parameters[9] = battle_alpha_parameters[9] + 1
                population_alpha_parameters[9] = population_alpha_parameters[9] + 1
            end

        else

            # catch unexpected errors
            error("Something is seriously wrong with your alpha parameter logic.")

        end

    end

end

# compute and output results
print_results(population_alpha_parameters)
