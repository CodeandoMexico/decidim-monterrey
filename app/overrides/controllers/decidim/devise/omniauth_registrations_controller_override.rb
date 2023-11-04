Decidim::Devise::OmniauthRegistrationsController.class_eval do
  private

  def user_params_from_oauth_hash
    return nil if oauth_data.empty?

    email = oauth_data.dig(:info, :email)
    user = Decidim::User.find_by(email: email, organization: current_organization)

    {
      provider: oauth_data[:provider],
      uid: oauth_data[:uid],
      name: oauth_data[:info][:name] || user&.name,
      nickname: oauth_data[:info][:nickname] || user&.nickname,
      oauth_signature: Decidim::OmniauthRegistrationForm.create_signature(oauth_data[:provider], oauth_data[:uid]),
      avatar_url: oauth_data[:info][:image],
      raw_data: oauth_hash
    }
  end

  def verified_email
    @verified_email ||= oauth_data.dig(:info, :email) || params.dig(:user, :email)
  end
end
