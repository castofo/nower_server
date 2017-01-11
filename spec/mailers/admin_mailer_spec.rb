require "rails_helper"

RSpec.describe AdminMailer, type: :mailer do
  describe "password_confirmation" do
    let(:admin) { build(:admin) }
    let(:mail) { AdminMailer.password_confirmation(admin) }

    it "renders the headers" do
      expect(mail.subject).to eq("Account activation")
      expect(mail.to).to eq([admin.email])
      expect(mail.from).to eq("Nower Support")
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi #{admin.email}")
    end
  end
end
