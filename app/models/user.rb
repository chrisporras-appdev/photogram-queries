# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  comments_count :integer
#  likes_count    :integer
#  private        :boolean
#  username       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class User < ApplicationRecord
  def comments
    return Comment.where({:author_id => self.id})
  end

  def own_photos
    return Photo.where({:owner_id => self.id})
  end 

  def likes 
    return Like.where({:fan_id => self.id})
  end

  def liked_photos
    photo_ids = self.likes.pluck(:photo_id)
    return Photo.where({:id => photo_ids})
  end

  def commented_photos
    photo_ids = self.comments.pluck(:photo_id)
    return Photo.where({:id => photo_ids})
  end

  def sent_follow_requests
    return FollowRequest.where({:sender_id => self.id})
  end

  def received_follow_requests
    return FollowRequest.where({:recipient_id => self.id})
  end

  def accepted_sent_follow_requests
    return self.sent_follow_requests.where({:status => "accepted"})
  end

  def accepted_received_follow_requests
    return self.received_follow_requests.where({:status => "accepted"})
  end

  def followers 
    follower_ids = self.accepted_received_follow_requests.pluck(:sender_id)
    return User.where({:id => follower_ids})
  end

  def following 
    following_ids = self.accepted_sent_follow_requests.pluck(:recipient_id)
    return User.where({:id => following_ids})
  end

  def feed
    following_ids = self.accepted_sent_follow_requests.pluck(:recipient_id)
    return Photo.where({:owner_id => following_ids})
  end

  def discover
    following_ids = self.accepted_sent_follow_requests.pluck(:recipient_id)
    photo_ids = Like.where({:fan_id => following_ids}).pluck(:photo_id)
    return Photo.where({:id => photo_ids})
  end
end
