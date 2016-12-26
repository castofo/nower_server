require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  describe "password_confirmation" do
    let(:admin) { create(:admin) }
    let(:mail) { AdminMailer.password_confirmation(admin) }

    it "renders the headers"# do
      # expect(mail.subject).to eq("Password confirmation")
      # expect(mail.to).to eq(admin.email)
      # expect(mail.from).to eq(["nower@example.com"])
    # end

    it "renders the body"# do
      # expect(mail.body.encoded).to match("Hi")
    # end
  end
end
