require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end


  def score
    input = params[:score]
    initial_word = params[:letters]
    current_word_size = 0
    if included?(input.upcase, initial_word)
      if english_word?(input)
        if session[:current_word_size].nil?
          session[:current_word_size] = input.size
        else
          session[:current_word_size] += input.size
        end
      @score = "well Done you have got #{session[:current_word_size]} points"
      else
      @score = "sorry but #{input}does not seem to be a valid english_word..."
      end
    else
      @score = "sorry but TEST can't be built out of #{initial_word}"
    end
  end
end

