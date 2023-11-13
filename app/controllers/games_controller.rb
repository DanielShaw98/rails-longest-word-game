class GamesController < ApplicationController
  require "json"
  require "open-uri"

  def new
    @letters = Array.new(10) { ('a'..'z').to_a.sample }
  end

  def score
    word = params[:word]
    letters = params[:letters]
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    response_serialized = URI.open(url).read
    response = JSON.parse(response_serialized)
    @total_score = session[:user_score] ||= 0
    if word.split('').all? { |l| (letters).include?(l) } && response["found"] == true
      @total_score = session[:user_score] += word.length
      @message = "Congratulations! #{word.upcase} is a valid English word!"
    elsif word.split('').all? { |l| (letters).include?(l) }
      @message = "Sorry but #{word.upcase} does not seem to be a valid English word..."
    else
      @message = "Sorry but #{word.upcase} can't be built out of #{letters}"
    end
  end
end
