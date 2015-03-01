class RecsController < ApplicationController

  def courselist

    courses = current_user.reviews.map(&:course)
    all_reviews = courses.map do | course |
      course.reviews.sample(20)
    end
    all_reviews.flatten!()
    sim_users = all_reviews.map(&:user).uniq()

    userValue = []
    index = 1

    # Loop for all similar users and store course reviewed and recommendation
    for sim_user in sim_users
      userValue << {}
      for sim_review in sim_user.reviews
      puts '--------------------------'
        puts userValue[-1]
        puts '--------------------------'
        userValue[-1][sim_review.course.id.to_s.to_sym]=sim_review.recommend
      end
      index += 1
    end

    # get courses reviewed
    coursesid_reviewed = userValue.map(&:keys).uniq()

    courses_reviewed = Course.find(coursesid_reviewed)
    @courses = courses_reviewed.sample(10)
    #@courses = Course.all.sample(10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end
end
