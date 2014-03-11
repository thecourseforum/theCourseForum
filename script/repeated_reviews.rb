#!/usr/bin/env ruby

def display_info(arr)
  if Review.exists?(arr[0]) && Review.exists?(arr[1])
    review1 = Review.find(arr[0])
    review2 = Review.find(arr[1])
    puts arr[0]
    puts review1.comment
    puts review1.overall
    puts "----"
    puts arr[1]
    puts review2.comment
    puts review2.overall

    print "ID of Review to delete: "
    id_to_delete = gets.chomp

    if id_to_delete.to_i != arr[0] && id_to_delete.to_i != arr[1]
      if id_to_delete == "combine"
        print "Which to delete: "
        id_to_delete = gets.chomp
        if id_to_delete.to_i != arr[0] && id_to_delete.to_i != arr[1]
          return "Invalid Input"
        else
          puts "Enter new comment:"
          new_comment = gets.chomp
          if id_to_delete.to_i == arr[0]
            Review.find(id_to_delete.to_i).destroy
            r = Review.find(arr[1])
            r.comment = new_comment
            if !(r.save)
              puts "Failed"
            end
          end
        end
      end
    else
      Review.find(id_to_delete.to_i).destroy
    end
  end
end

def remove_repeats

  r = Review.all
  pairs = []

  r.each do |review|
    r[r.index(review)+1..r.size].each do |review2|
      if (review.student_id == review2.student_id && review.course_id == review2.course_id && review.professor_id == review2.professor_id)
        pairs.push([review.id, review2.id])
      end
    end
  end

  comments = []

  pairs.each do |r1, r2|
    if Review.exists?(r1) && Review.exists?(r2)
      review1 = Review.find(r1)
      review2 = Review.find(r2)
      if (review1.comment != "" && review2.comment != "")
        if (review1.comment != review2.comment)
          comments.push([r1, r2])
          display_info([r1,r2])
        else
          if review1.overall != review2.overall
            if review1.overall > review2.overall
              review2.destroy
            else
              review1.destroy
            end
          else
            review2.destroy
          end
        end
      elsif (review1.comment == "" && review2.comment == "")
        if review1.overall != review2.overall
          if review1.overall > review2.overall
            review2.destroy
          else
            review1.destroy
          end
        else
          review2.destroy
        end
      elsif review1.comment == ""
        review1.destroy
      elsif review2.comment == ""
        review2.destroy
      end
    end
  end

  def display_info(arr)
    if Review.exists?(arr[0]) && Review.exists?(arr[1])
      review1 = Review.find(arr[0])
      review2 = Review.find(arr[1])
      puts arr[0]
      puts review1.comment
      puts review1.overall
      puts "----"
      puts arr[1]
      puts review2.comment
      puts review2.overall

      print "ID of Review to delete: "
      id_to_delete = gets.chomp

      if id_to_delete.to_i != arr[0] && id_to_delete.to_i != arr[1]
        if id_to_delete == "combine"
          print "Which to delete: "
          id_to_delete = gets.chomp
          if id_to_delete.to_i != arr[0] && id_to_delete.to_i != arr[1]
            return "Invalid Input"
          else
            puts "Enter new comment:"
            new_comment = gets.chomp
            if id_to_delete.to_i == arr[0]
              Review.find(id_to_delete.to_i).destroy
              r = Review.find(arr[1])
              r.comment = new_comment
              if !(r.save)
                puts "Failed"
              end
            end
          end
        end
      else
        Review.find(id_to_delete.to_i).destroy
      end
    end
  end

  puts comments
end

remove_repeats

