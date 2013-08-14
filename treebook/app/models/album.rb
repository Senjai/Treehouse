class Album < ActiveRecord::Base
  belongs_to :user
  attr_accessible :title

  has_many :pictures
end
