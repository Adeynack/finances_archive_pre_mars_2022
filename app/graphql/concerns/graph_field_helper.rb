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
        begin
          @model ||= name.split("::").last.delete_suffix("Type").constantize
        rescue NameError => e
          raise NameError, "#{e.message}\nThis name is inferred from the name of the GraphQL object class '#{name}'. You probably need to call 'model MyModel' at the beginning of your GraphQL object class to specify the model this GraphQL object is representing."
        end
      else
        raise ArgumentError, "Cannot set the model once it has been set once." unless @model.nil?
        raise ArgumentError, "Expecting the model class." unless model_class.is_a?(Class)

        @model = model_class
      end
    end

    # Creates an array field resolved by an AssociationLoader.
    # The field is not null, unless the `null` option is provided.
    # By default, loads the association with the same name than the field, unless 3rd parameter (`association`) is provided.
    def has_many(name, element_type, association = name, **options, &block) # rubocop:disable Naming/PredicateName
      define_method name do
        AssociationLoader.for(self.class.model, association).load(object)
      end
      options[:null] = false unless options.key?(:null)
      field name, [element_type], **options, &block
    end

    # Creates a field resolved by an AssociationLoader.
    # The field is as null as the association is optional, unless the `null` option is provided.
    # Loads the association with the same name than the field, unless 3rd parameter (`association`) is provided.
    def belongs_to(name, element_type, association = name, **options, &block)
      define_method name do
        AssociationLoader.for(self.class.model, association).load(object)
      end
      options[:null] = model.reflect_on_association(name).options[:optional] || false unless options.key?(:null)
      field name, element_type, **options, &block
    end
  end
end
