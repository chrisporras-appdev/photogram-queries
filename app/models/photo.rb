# == Schema Information
#
# Table name: photos
#
#  id             :integer          not null, primary key
#  caption        :string
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#

class Photo < ApplicationRecord
  def poster 
    return User.where({:id => self.owner_id}).at(0)
  end

  def comments
    return Comment.where({:photo_id => self.id})
  end

  def likes
    return Like.where({:photo_id => self.id})
  end

  def fans
    fan_ids = self.likes.pluck(:fan_id)
    return User.where({:id => fan_ids})
  end

  def fan_list
    return self.fans.pluck(:username).to_sentence
  end
end
