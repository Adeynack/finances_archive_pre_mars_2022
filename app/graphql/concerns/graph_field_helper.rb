# frozen_string_literal: true

module GraphFieldHelper
  extend ActiveSupport::Concern

  class_methods do
    # Gets and sets the model represented by this GraphQL Type
    #
    # If no parameter (or `nil`) is specified, returns the actual value.
    #
    # If no value set, infers the model from the GraphQL Type name.
    #
    #   Types::BookType --> Book
    #   Types::Foo::Bar::UserType --> User
    #
    # In case the GraphQL Type name does not reflects the model to serve,
    # specify one at the top of the GraphQL.
    #
    #   class BookType < Types::BaseObject
    #     model Livre
    #     field ...
    #     ...
    #   end
    #
    def model(model_class = nil)
      if model_class.nil?
        @model ||= name.split("::").last.delete_suffix("Type").constantize
      else
        raise ArgumentError, "Cannot set the model once it has been set once." unless @model.nil?
        raise ArgumentError, "Expecting the model class." unless model_class.is_a?(Class)

        @model = model_class
      end
    end

    # Additional automation over the existing `field` method.
    def field(*args, **options, &block)
      load_association = options.delete :load_association
      unless load_association.nil?
        field_name = args.first.to_sym
        case load_association
        when true
          model_class = model
          association = field_name
        when Symbol || String
          model_class = model
          association = load_association.to_sym
        when Hash
          model_class = load_association.delete(:model) || model
          association = load_association.delete(:association).to_sym || field_name
          raise ArgumentError, "Unexpected keys #{load_association.keys} in 'load_association' hash." if load_association.present?
        end
        define_method field_name do
          AssociationLoader.for(model_class, association).load(object)
        end
      end

      super(*args, **options, &block)
    end
  end
end
