module Seeds
  module Organization
    def self.call
      Decidim::Organization.find_or_create_by!(name: "Decidim Monterrey") do |org|
        org.update!(
          reference_prefix: "Instituto",
          time_zone: "Central Time (US & Canada)",
          host: "localhost:3000",
          description: {"es" => "Lorem Ipsum..."},
          default_locale: Decidim.default_locale,
          available_locales: Decidim.available_locales,
          users_registration_mode: :enabled,
          official_url: "localhost:3000",
          highlighted_content_banner_enabled: false,
          enable_omnipresent_banner: false,
          badges_enabled: false,
          user_groups_enabled: true,
          send_welcome_notification: true,
          comments_max_length: 1000,
          admin_terms_of_use_body: {"es" => "Admin terms of use"},
          force_users_to_authenticate_before_access_organization: false,
          machine_translation_display_priority: "original",
          external_domain_whitelist: ["twitter.com", "facebook.com", "youtube.com", "github.com"],
          smtp_settings: {
            "from" => "test@example.org",
            "user_name" => "test",
            "encrypted_password" => Decidim::AttributeEncryptor.encrypt("demo"),
            "port" => "25",
            "address" => "smtp.example.org"
          },
          file_upload_settings: Decidim::OrganizationSettings.default(:upload),
          enable_participatory_space_filters: true
        )
      end
    end
  end
end
