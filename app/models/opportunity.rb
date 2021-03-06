class Opportunity < ActiveRecord::Base
  attr_accessible :entrepreneur_id, :opportunity_type, :usertype, :tag_list, :text, :info
  acts_as_taggable
  belongs_to :entrepreneur
  has_many :applicants, as: :commentable, :dependent => :destroy
end
