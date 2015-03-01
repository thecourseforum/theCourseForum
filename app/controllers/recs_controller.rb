include Math

class RecsController < ApplicationController

  def courselist
    prefs = load_pref

    # get courses reviewed
    coursesid_reviewed = prefs.values.map(&:keys).uniq()
    # puts sim_pearson(prefs,prefs.keys[1],prefs.keys[2])
    # puts topMatches(prefs,17786)
    bestCourses = getRecommendations(prefs,17786)

    courses_reviewed = []
    for i in bestCourses
      courses_reviewed = courses_reviewed << Course.find(i[1])
    end

    # courses_reviewed = Course.find(coursesid_reviewed)
    @courses = courses_reviewed.uniq().sample(10)
    #@courses = Course.all.sample(10)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reviews }
    end
  end

  def load_pref()
    courses = current_user.reviews.map(&:course)
    all_reviews = courses.map do | course |
      course.reviews[1..20]
    end
    all_reviews.flatten!()
    sim_users = all_reviews.map(&:user).uniq()

    sim_users = sim_users << current_user
    prefs = {}
    #[user][courses]

    # Loop for all similar users and store course reviewed and recommendation
    for sim_user in sim_users
      prefs[sim_user.id.to_s.to_sym] = {}
      for sim_review in sim_user.reviews
        prefs[sim_user.id.to_s.to_sym][sim_review.course.id.to_s.to_sym] = sim_review.recommend
      end
    end
    return prefs
  end

  #Returns the Pearson correlation coefficient for user 1 and 2
  def sim_pearson(prefs,user_id1,user_id2)
    #Get the list of mutually rated items
    mutual = {}
    for course_id in prefs[user_id1]
      if prefs[user_id2].has_key?(course_id[0].to_s.to_sym)
        mutual[course_id[0].to_s.to_sym] = 1
      end
    end

    if mutual.length == 0
      return 0
    end

    #sum calculations
    n = mutual.length

    #sum of all preferences
    sum1 = 0
    for course in mutual.keys
      sum1 += prefs[user_id1][course]
    end
    sum2 = 0
    for course in mutual.keys
      sum2 += prefs[user_id2][course]
    end



    #Sum of the squares
    sum1_sq = 0
    for course in mutual.keys
      sum1_sq += prefs[user_id1][course]**2
    end
    sum2_sq = 0
    for course in mutual.keys
      sum2_sq += prefs[user_id2][course]**2
    end

    #Sum of the products
    pSum = 0
    for course in mutual.keys
      pSum += prefs[user_id1][course] * prefs[user_id2][course]
    end

    #Calculate r (Pearson score)
    num = pSum - (sum1 * sum2/n)
    den = sqrt((sum1_sq - sum1**2/n) * (sum2_sq - sum2**2/n))
    if den == 0
      return 0
    end

    r = num/den

    return r
  end

  #Returns the best matches for person from the prefs dictionary
  #Number of the results and similiraty function are optional params.
  def topMatches(prefs,targetId,n=5)
    scores = []
    for other in prefs.keys
      if other != targetId
        scores << [sim_pearson(prefs,targetId.to_s.to_sym,other),other]
      end
    end
    scores.sort do |first, second|
      first[0] <=> second[0]
    end
    return scores[0..n]
  end

  #Gets recommendations for a person by using a weighted average
  #of every other user's rankings
  def getRecommendations(prefs,targetId)
    totals = {}
    simSums = {}

    for other in prefs.keys

      if other == targetId
        next
      end
      # puts sum1.to_s + " " + sum2.to_s
      sim = sim_pearson(prefs,targetId.to_s.to_sym,other.to_s.to_sym)
      #ignore scores of zero or lower
      if sim <= 0
        next
      end

      for item in prefs[other].keys
        #only score books i haven't seen yet
        if !prefs[targetId.to_s.to_sym].has_key?(item) or prefs[targetId.to_s.to_sym][item] == 0
            #Similarity * score
            # totals.setdefault(item,0)
            if !totals.has_key?(item)
              totals[item] = 0
            end
            totals[item] += prefs[other][item] * sim
            #Sum of similarities
            # simSums.setdefault(item,0)
            if !simSums.has_key?(item)
              simSums[item] = 0
            end
            simSums[item] += sim
        end
      end
    end
    #Create the normalized list
    rankings = []
    totals.each do |key,value|
      rankings = rankings << [value/simSums[key],key]
    end

    #Return the sorted list
    rankings = rankings.sort do |first, second|
      second[0] <=> first[0]
    end
    return rankings
  end
end
