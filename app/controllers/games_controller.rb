require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)

    @letters = params[:letters].downcase.split(' ')
    @input = params[:word].downcase.chars
    @include_all_letters = true
    @input.each do |letter|
      if @input.count(letter) <= @letters.count(letter)
        # @include_all_letters = false unless @letters.include?(letter)
      else
        @include_all_letters = false
      end
    end

    @result = if @include_all_letters == false
                "Sorry but #{params[:word]} can't be built out of #{@letters}"
              elsif word['found'] == false
                "Sorry but #{params[:word]} does not seem to be a valid English word..."
              elsif word['found'] == true
                "Congraturations! #{params[:word]} is a valid English word!"
              end
  end
end

# 1. if all of the characters of the word are in the letter list?
# 2. if the word doesn't exist in the API dictionary or it's not the longest?
# 3. if the word exists in the API dictionary and it's the longest one?
