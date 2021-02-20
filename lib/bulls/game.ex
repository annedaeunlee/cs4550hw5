defmodule BullsWeb.Game do
    # sets up the state of a new game
    def new do
        %{
            tries: 7,
            guess: "",
            guesses: [],
            results: [],
            answer: makeSecret(MapSet.new([1, 2, 3, 4, 5, 6, 7, 8, 9, 0]), ""),
            status: false,
            error: ""
        }
    end

    # generates the random unique four digit number that will be the answer
    def makeSecret(set, acc) do
        cond do
            String.length(acc) == 4 ->
                acc
            true ->
                rand = Enum.random(set)
                set = MapSet.delete(set, rand)
                acc = acc <> Integer.to_string(rand)
                makeSecret(set, acc)
        end
    end

    # updates current tries, guess, guesses, results, and error to the state.
    def view(state) do
        %{
            tries: state.tries,
            guess: state.guess,
            guesses: state.guesses,
            results: state.results,
            error: state.error,
        }
    end

    # checks for a valid guess
    def checkGuess(state, guess) do
        guessSplit = String.split(guess, "", trim: true)
        cond do
            length(guessSplit) > 4 ->
                %{state | error: "Four digits only"}
            String.match?(guess, ~r/[^\d]/) ->
                %{state | error: "Four numbers only"}
            MapSet.size(MapSet.new(guessSplit)) != length(guessSplit) ->
                %{state | error: "Digits must be unique"}
            true ->
                %{state | guess: guess}
        end
    end

    # updates game state with user input
    def updateState(stateOld, guess) do
        if String.length(guess) == 4 do
            result = getResult(stateOld.answer, stateOld.guess, 0, 0, 0)
            stateNew = %{ stateOld | 
                guess: "",
                tries: stateOld.tries - 1,
                guesses: stateOld.guesses ++ [guess],
                results: stateOld.results ++ [result]
            }
            cond do
                stateOld.answer == guess -> %{stateNew | error: "You won", status: true}
                stateOld.tries == 0 -> %{stateNew | error: "You lost", status: true}
                true ->
                    stateNew
            end
        else
            stateOld
        end
    end

    # returns the cows and bulls result from given guess
    def getResult(answer, guess, index, bulls, cows) do
        guesses = String.split(guess, "")
        answers = String.split(answer, "")
        if (index < 4) do
            cond do
                Enum.at(guesses, index) == Enum.at(answers, index) ->
                    getResult(answer, guess, index+1, bulls+1, cows)
                Enum.member?(answers, Enum.at(guesses, index)) ->
                    getResult(answer, guess, index+1, bulls, cows+1)
                true ->
                    getResult(answer, guess, index+1, bulls, cows)
            end
        else
            Integer.to_string(bulls) <> "B" <> Integer.to_string(cows) <> "C"            
        end
    end

    # returns the status of a game
    def status(state) do
        state.status
    end
end