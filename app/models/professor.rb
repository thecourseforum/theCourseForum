class Professor < ActiveRecord::Base
  belongs_to :department

  has_many :section_professors, dependent: :destroy
  has_many :reviews

  has_many :sections, :through => :section_professors
  has_many :courses, :through => :sections
  has_many :subdepartments, :through => :courses

  validates_presence_of :first_name, :last_name

  def courses_list
    return self.courses.includes(:subdepartment).uniq{ |course| course.id }.sort_by{|course| course.subdepartment.mnemonic}
  end

  def full_name
    self.first_name + " " + self.last_name
  end

  def email
    if self.email_alias && self.email_alias.length != 0
      if self.email_alias.include?("@")
        self.email_alias
      else
        self.email_alias + "@virginia.edu"
      end
    else
      ""
    end
  end

  def self.find_by_name(name)
    if name.class == Array
      return name.map do |element|
        self.find_by_name(element)
      end.compact
    end
    first, last = *name.split(' ')
    self.where(:first_name => first).find do |professor|
      professor.last_name == last
    end
  end

  def separated_name
    
    if self.first_name == "Staff" || self.first_name == "staff"
      return "Staff"
    else
      return self.last_name + ", " + self.first_name
    end
  end
    
end
