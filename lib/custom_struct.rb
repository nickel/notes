# frozen_string_literal: true

class CustomStruct < OpenStruct
  include ActiveModel::Serialization

  def read_attribute_for_serialization(attr)
    send(attr) if defined?(attr)
  end

  def attributes
    instance_variable_get("@table")
  end

  def respond_to_missing?(_method_name, _include_private = false)
    true
  end

  def method_missing(method_name, *_args)
    if method_name.end_with?("?") && attributes.keys.include?(method_name[0..-2].to_sym)
      value = attributes[method_name[0..-2].to_sym]

      if value.class.ancestors.include?(Numeric)
        !value.zero?
      elsif value.class.in?([TrueClass, FalseClass])
        value
      else
        value.present?
      end
    else
      super
    end
  end
end
