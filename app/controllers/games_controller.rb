# frozen_string_literal: true

require 'json'
require 'open-uri'

# it controls the scores etc
class GamesController < ApplicationController

  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def result
    attempt = params[:guess]
    grid = params[:grid]
    run_game(attempt, grid)
  end

  def in_grid?(grid, attempt)

    grid_array = grid.split("")
    grid_hash = grid_array.uniq.each_with_object({}) { |letter, hash| hash[letter.downcase] = grid.count(letter) }

    attempt.chars.each do |char|
      return false unless grid_hash[char]

      if grid_hash[char].positive?
        grid_hash[char] -= 1
      else
        return false
      end
    end
    return true
  end

  def valid_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    user_serialized = open(url).read
    JSON.parse(user_serialized)["found"]
  end

  def score(grid, attempt)
    if in_grid?(grid, attempt) && valid_word?(attempt)
      return attempt.length.to_i
    else
      return 0
    end
  end

  def create_message(grid, attempt)
    if valid_word?(attempt)
      if in_grid?(grid, attempt)
        return "Well done"
      else
        return "Not in the grid"
      end
    else
      return "Not an english word"
    end
  end

  def run_game(attempt, grid)
    @result = {
      score: score(grid, attempt),
      message: create_message(grid, attempt)
    }
  end
end










