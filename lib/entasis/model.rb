module Entasis
  module Model
    extend ActiveSupport::Concern

    included do
      include Entasis::Relations
      include ActiveModel::Validations
      class_attribute :attribute_names, :attributes_config, :belongings, instance_writer: false

      self.belongings ||= {}
      self.attribute_names ||= []
      self.class_eval 'class UnknownAttributeError < StandardError; end'
    end

    module ClassMethods
      ##
      #
      # Takes a list of attribute names.
      #
      # Last argument can be an options hash:
      #
      #   strict: true - Raise UnknownAttributeError when given an unknown attribute.
      #
      def attributes(*attrs)
        self.attributes_config = attrs.last.is_a?(Hash) ? attrs.pop : {}

        self.attribute_names += attrs.map(&:to_s).sort

        attr_accessor *attrs
      end
    end

    ##
    #
    # Takes a hash and assigns keys and values to it's attributes members
    #
    def initialize(hash={})
      self.attributes = hash
    end

    ##
    #
    # Takes a hash of attribute names and values and set each attribute.
    #
    # If passwed an unkown attribute it will raise +class::UnknownAttributeError+
    #
    def attributes=(hash)
      hash.each do |name, value|
        if attribute_names.include?(name.to_s) || self.respond_to?("#{name}=")
          self.send("#{name}=", value)
        else
          if attributes_config[:strict] == true
            raise self.class::UnknownAttributeError, "unknown attribute: #{name}"
          end
        end
      end
    end

    ##
    #
    # Returns all attributes serialized as hash
    #
    def attributes
      attribute_names.inject({}) { |h, name| h[name] = send(name); h }
    end
  end
end
