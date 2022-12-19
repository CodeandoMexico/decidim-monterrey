# Applied patch from https://github.com/decidim/decidim/pull/8795
TranslatablePresenceValidator.class_eval do
  def validate_each(record, attribute, _value)
    translated_attr = "#{attribute}_#{default_locale_for(record)}".gsub("-", "__")
    record.errors.add(translated_attr, :blank) if record.send(translated_attr).blank?
  end

  private

  def default_locale_for(record)
    return record.default_locale if record.respond_to?(:default_locale)

    if record.current_organization
      record.current_organization.default_locale
    else
      record.errors.add(:current_organization, :blank)
      Decidim.default_locale
    end
  end
end
