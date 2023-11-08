class UserMailer < ApplicationMailer
  def leave_approval_email(user, leafe)
    @user = user
    @leafe = leafe
    mail(to: @user.email, subject: 'Leave Approved')
  end

  def leave_rejection_email(user, leafe)
    @user = user
    @leafe = leafe
    mail(to: @user.email, subject: 'Leave Rejected')
  end
end
