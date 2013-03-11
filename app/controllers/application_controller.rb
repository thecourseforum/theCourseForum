class ApplicationController < ActionController::Base
  protect_from_forgery

  def columnize(arr)
    [arr.shift((arr.length / 2).ceil), arr]
  end
end
