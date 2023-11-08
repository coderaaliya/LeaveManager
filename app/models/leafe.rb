class Leafe < ApplicationRecord
  belongs_to :user
  after_save :update_leave
  enum status: { pending: 0, approved: 1, rejected: 2 }
  enum leave_type: { sick: 0, personal: 1, casual: 2 }

 def update_leave
    if status_changed? && approved?
    user.increment!(:leaves_taken)
    user.decrement!(:total_leaves_allowed)
  elsif status_changed? && rejected?
    user.decrement!(:leaves_taken)
    user.increment!(:total_leaves_allowed)
  end
  end
  
end
