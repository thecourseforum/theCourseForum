class Professor < ActiveRecord::Base
  belongs_to :department
  has_many :section_professors
  has_many :sections, :through => :section_professors
  has_many :courses, :through => :sections

  validates_presence_of :first_name, :last_name

  def courses_list
    return self.courses.uniq{ |p| p.id }.sort_by{|p| p.subdepartment.mnemonic}
  end

  def full_name
    self.first_name + " " + self.last_name
  end

  def separated_name
    self.last_name + ", " + self.first_name
  end
end
