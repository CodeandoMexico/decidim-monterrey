Decidim::Verifications::AuthorizationsController.class_eval do
  protected

  def unauthorized_methods
    @unauthorized_methods ||= available_verification_workflows.reject { |handler|
      active_authorization_methods.include?(handler.key) || handler.key == "managed_user_authorization_handler"
    }
  end
end
