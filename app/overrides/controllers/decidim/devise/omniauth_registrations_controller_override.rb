Decidim::Devise::OmniauthRegistrationsController.class_eval do
  private

  def verified_email
    @verified_email ||= oauth_data.dig(:info, :email) || params.dig(:user, :email)
  end
end
