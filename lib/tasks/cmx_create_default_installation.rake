namespace :cmx do
  desc "Create Organization"
  task create_organization: [:environment] do
    puts "\nCMX >> Creando Organización"
    unless Rails.env.production?

      organization = Decidim::Organization.first || Decidim::Organization.create!(
        name: "Organización",
        twitter_handler: "",
        facebook_handler: "",
        instagram_handler: "",
        youtube_handler: "",
        github_handler: "",
        smtp_settings: {},
        host: ENV["DECIDIM_HOST"] || "localhost",
        external_domain_whitelist: [],
        description: {"es": "Descipción"},
        default_locale: Decidim.default_locale,
        available_locales: [Decidim.default_locale],
        reference_prefix: "prefijo",
        available_authorizations: Decidim.authorization_workflows.map(&:name),
        users_registration_mode: :enabled,
        tos_version: Time.current,
        badges_enabled: false,
        user_groups_enabled: false,
        send_welcome_notification: true,
        file_upload_settings: Decidim::OrganizationSettings.default(:upload)
      )

      Decidim::System::CreateDefaultContentBlocks.call(organization)
      terms_and_conditions_page = Decidim::StaticPage.new
      terms_and_conditions_page.organization = organization
      terms_and_conditions_page.slug = "terms-and-conditions"
      terms_and_conditions_page.title = {"es": "Términos y Condiciones"}
      terms_and_conditions_page.content = {"es": "..."}
      terms_and_conditions_page.save!

      puts("Organización creada con éxito")
    end
  end

  desc "Create a new system admin"
  task create_system_admin_user: [:environment, :create_organization] do
    puts "\nCMX >> Usuario administrador de sistema"
    email = ENV["SYSTEM_USER_EMAIL"] || prompt("Correo electrónico", hidden: false)
    password = ENV["SYSTEM_USER_PASSWORD"] || prompt("Contraseña")
    password_confirmation = ENV["SYSTEM_USER_PASSWORD"] || prompt("Confirmar contraseña")

    admin = Decidim::System::Admin.new(email: email, password: password, password_confirmation: password_confirmation)

    if admin.valid?
      admin.save!
      puts("Administrador del sistema creado con éxito")
    else
      puts("Algunos errores impidieron la creación de administrador:")
      admin.errors.full_messages.uniq.each do |message|
        puts "  * #{message}"
      end
    end
  end

  desc "Create a new admin user"
  task create_admin_user: [:environment, :create_system_admin_user] do
    puts "\nCMX >> Usuario administrador de aplicación"
    name = ENV["ADMIN_USER_NAME"] || prompt("Nombre completo", hidden: false)
    nickname = ENV["ADMIN_USER_NICKNAME"] || prompt("Nickname", hidden: false)
    email = ENV["ADMIN_USER_EMAIL"] || prompt("Correo electrónico", hidden: false)
    password = ENV["ADMIN_USER_PASSWORD"] || prompt("Contraseña")
    password_confirmation = ENV["ADMIN_USER_PASSWORD"] || prompt("Confirmar contraseña")

    organization = Decidim::Organization.first

    admin = Decidim::User.find_or_initialize_by(email: email)

    admin.update!(
      name: name,
      nickname: nickname,
      password: password,
      password_confirmation: password_confirmation,
      organization: organization,
      confirmed_at: Time.current,
      locale: I18n.default_locale,
      admin: true,
      tos_agreement: true,
      personal_url: "",
      about: "",
      accepted_tos_version: organization.tos_version,
      admin_terms_accepted_at: Time.current
    )
    puts("Administrador de aplicación creado con éxito")
  end

  desc "Create default installation"
  task create_default_installation: [:environment, :create_admin_user] do
  end

  def prompt(attribute, hidden: true)
    print("#{attribute}: ")
    input = if hidden
      $stdin.noecho(&:gets).chomp
    else
      $stdin.gets.chomp
    end
    print("\n") if hidden
    input
  end
end
