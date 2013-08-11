class Photo < ActiveRecord::Base
  attr_accessible :name, :post_id, :url
end
