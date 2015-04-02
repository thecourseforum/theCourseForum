class Professor < ActiveRecord::Base
  belongs_to :department

  has_many :section_professors, dependent: :destroy
  has_many :reviews

  has_many :sections, :through => :section_professors
  has_many :courses, :through => :sections
  has_many :subdepartments, :through => :courses

  validates_presence_of :first_name, :last_name

  def courses_list
    return self.courses.uniq{ |p| p.id }.sort_by{|p| p.subdepartment.mnemonic}
  end

  def full_name
    self.first_name + " " + self.last_name
  end

  def separated_name
    
    if self.first_name == "Staff" || self.first_name == "staff"
      return "Staff"
    else
      return self.last_name + ", " + self.first_name
    end
  end
    

end
