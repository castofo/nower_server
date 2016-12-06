class AdminMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.password_confirmation.subject
  #
  def password_confirmation(admin)
    @admin = admin
    return if @admin.activated?
    mail to: @admin.email
  end
end
