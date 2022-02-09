module Decidim
  module TranslatableAttributes
    extend ActiveSupport::Concern

    class_methods do
      def translatable_attribute(name, type, *options)
        attribute name, Hash, default: {}

        locales.each do |locale|
          attribute_name = "#{name}_#{locale}".gsub("-", "__").underscore
          attribute attribute_name, type, *options

          define_method attribute_name do
            field = public_send(name) || {}
            value = field[locale.to_s] || field[locale.to_sym]
            attribute_set[attribute_name].coerce(value)
          end

          define_method "#{attribute_name}=" do |value|
            field = public_send(name) || {}
            public_send("#{name}=", field.merge(locale => super(value)))
          end

          yield(attribute_name, locale) if block_given?
        end
      end
    end
  end

  module FormBuilderPatch
    def translated_one_locale(type, name, locale, options = {})
      return hashtaggable_text_field(type, name, locale, options) if options.delete(:hashtaggable)

      send(
        type,
        "#{name}_#{locale.to_s.gsub("-", "__")}".underscore,
        options.merge(label: options[:label] || label_for(name))
      )
    end

    def name_with_locale(name, locale)
      "#{name}_#{locale.to_s.gsub("-", "__")}".underscore
    end


    FormBuilder.prepend self
  end
end

class TranslatablePresenceValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, _value)
    translated_attr = "#{attribute}_#{default_locale_for(record)}".gsub("-","__").underscore
    record.errors.add(translated_attr, :blank) if record.send(translated_attr).blank?
  end

  private

  def default_locale_for(record)
    return record.default_locale if record.respond_to?(:default_locale)

    if record.current_organization
      record.current_organization.default_locale
    else
      record.errors.add(:current_organization, :blank)
      []
    end
  end
end
