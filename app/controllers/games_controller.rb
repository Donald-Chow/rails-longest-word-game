require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @letters = params[:letters].split
    @word = params[:word]
    @score = cal_score(@word, @letters)
  end

  private

  def cal_score(word, letters)
    if valid?(word, letters) && isword?(word)
      "Congratulations! #{word} is a valid English word!"
    elsif !isword?(word)
      "Sorry but #{word} is not a valid English word..."
    elsif !valid?(word, letters)
      "Sorry but #{word} cannot be build out of #{letters.join(', ')}"
    else
      'Something went wrong'
    end
  end

  def valid?(word, letters)
    word.upcase.chars.all? do |letter|
      word.count(letter) <= letters.count(letter)
    end
  end

  def isword?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    result_serialized = URI.open(url).read
    result = JSON.parse(result_serialized)
    result['found']
  end
end

# The word can’t be built out of the original grid
# The word is valid according to the grid, but is not a valid English word
# The word is valid according to the grid and is an English word
