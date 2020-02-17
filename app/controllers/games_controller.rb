require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = generate_grid
  end

  def score
    @answer = params[:word]
    @grid = params[:letters]
    # @grid = params[:answer]
    @end_time = Time.now + 2
    @start_time = Time.now
      # params[:start_time].to_datetime
    # @generategrid = params[:generategrid]
    @lr = gen_array(params[:letters])


    @result = run_game(@answer, @lr, @start_time, @end_time)
  end

  def generate_grid
    # TODO: generate random grid of letters
    counter = 0
    arr = ('A'..'Z').to_a
    grid = []
    until counter == 10
      grid << arr.sample
      counter += 1
    end
    return grid
  end

  def gen_array(string)
    array = string.split(" ")
    return array
  end

  def letter_frequency(array)
    hash = {}
    array.each do |value|
      hash.key?(value.to_s) ? hash[value.to_s] = hash[value.to_s] += 1 : hash[value.to_s] = 1
    end
    return hash
  end

  def frequency_check(answer_array, grid_hash)
    answer_array.each do |value|
      return false if answer_array.count(value) > grid_hash[value]
    end
  end

  def value_check(answer_array, grid_hash)
    result = true
    answer_array.each do |value|
      unless grid_hash.key?(value)
        result = false
        return result
        break
      end
    end

    return result
  end




  def overused_letters_score(answer, elapsed_time)
    not_enough_letters = {
      word: answer,
      time: elapsed_time,
      score: 0,
      message: "You overused letters from the grid."
    }

    puts "Your word: #{not_enough_letters[:word]}"
    puts "Time taken to answer: #{not_enough_letters[:time]}"
    puts "Your score: #{not_enough_letters[:score]}"
    puts "Message: #{not_enough_letters[:message]}"
    return not_enough_letters
  end

  def not_english(answer, elapsed_time)
    not_english = {
      word: answer,
      time: elapsed_time,
      score: 0,
      message: "Sorry, but #{answer.upcase} does not seem to be a valid English word..."
    }

    puts "Your word: #{not_english[:word]}"
    puts "Time taken to answer: #{not_english[:time]}"
    puts "Your score: #{not_english[:score]}"
    puts "Message: #{not_english[:message]}"
    return not_english
  end

  def not_in_grid(answer, elapsed_time)
    not_in_grid = {
      word: answer,
      time: elapsed_time,
      score: 0,
      message: "Congratulations!  #{answer.upcase} is a valid English word but not in grid."
    }

    puts "Your word: #{not_in_grid[:word]}"
    puts "Time taken to answer: #{not_in_grid[:time]}"
    puts "Your score: #{not_in_grid[:score]}"
    puts "Message: #{not_in_grid[:message]}"
    return not_in_grid
  end



  def perfect_response_score(answer, elapsed_time)
    perfect = {
      word: answer,
      time: elapsed_time,
      score: 1000 + answer.length - elapsed_time,
      message: "Well Done! #{answer.upcase} is a valid English word AND in the grid!"
    }

    puts "Your word: #{perfect[:word]}"
    puts "Time taken to answer: #{perfect[:time]}"
    puts "Your score: #{perfect[:score]}"
    puts "Message: #{perfect[:message]}"
    return perfect
  end



  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    json = open(url).read
    json_hash = JSON.parse(json)
    elapsed_time = end_time - start_time

    answer_up = attempt.upcase.gsub(/\s+|!/, '').split('')

    hash1 = letter_frequency(grid)

    if value_check(answer_up, hash1) == false
      not_in_grid(attempt, elapsed_time)
    elsif frequency_check(answer_up, hash1) == false
      overused_letters_score(attempt, elapsed_time)
    elsif json_hash["found"] == false
      not_english(attempt, elapsed_time)
    else json_hash["found"] == true
      perfect_response_score(attempt, elapsed_time)
    end
  end


end
