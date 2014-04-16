class UsersController < ApplicationController

  def settings
    @user = current_user
    @word_cloud = @user.settings(:word_cloud).on
    @doge = @user.settings(:word_cloud).doge
  end

  def word_cloud_on
    current_user.settings(:word_cloud).on = true
    current_user.save!

    render :nothing => true
  end

  def word_cloud_off
    current_user.settings(:word_cloud).on = false
    current_user.settings(:word_cloud).doge = false
    current_user.save!

    render :nothing => true
  end

  def doge_on
    if current_user.settings(:word_cloud).on
      current_user.settings(:word_cloud).doge = true
      current_user.save!
    end

    render :nothing => true
  end

  def doge_off
    current_user.settings(:word_cloud).doge = false
    current_user.save!

    render :nothing => true
  end

end