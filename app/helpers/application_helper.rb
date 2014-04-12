module ApplicationHelper

	def get_words()
		if !File.exists?('lib/words.json')
			all_words = create_words_json
		else
			all_words = JSON.parse(File.read('lib/words.json'))
		end

		all_words
	end

	def create_words_json()
		all_words = {}
	  Review.all.each do |r|
	    r.comment.split(" ").each do |word|
	      if word.split("").last == "." || word.split("").last == ","
	        word = word[0..word.length-2]
	      end
	      word.downcase!
	      if all_words[word] != nil
	        all_words[word] += 1
	      else
	        all_words[word] = 1
	      end
	    end
	  end

	  File.open('lib/words.json', 'w') {|f| f.puts all_words.to_json}

	  all_words
	end

end
