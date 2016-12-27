# Preview all emails at http://localhost:3000/rails/mailers/admin_mailer
class AdminMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin_mailer/password_confirmation
  def password_confirmation
    admin = FactoryGirl.build(:admin)
    AdminMailer.password_confirmation(admin)
  end

end
