class Status < ActiveRecord::Base
  attr_accessible :content, :user_id, :document_attributes
  belongs_to :user
  belongs_to :document

  accepts_nested_attributes_for :document

  validates :content, presence: true,
                      length: { minimum: 2 }

  validates :user_id, presence: true
end
