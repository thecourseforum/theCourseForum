class Subdepartment < ActiveRecord::Base
  has_and_belongs_to_many :departments
  has_many :courses

  validates_presence_of :name, :mnemonic

  def professors_list
    profs = []
    self.courses.each do |course|
      profs += course.professors_list
    end

    return profs
  end
end
