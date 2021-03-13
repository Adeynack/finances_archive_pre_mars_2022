# frozen_string_literal: true

module HashRefinements
  refine Hash do
    def minimize_presence!
      each_key do |key|
        value = self[key]
        value.minimize_presence! if value.is_a?(Hash)
        delete(key) unless value.is_a?(TrueClass) || value.is_a?(FalseClass) || value.present?
      end
    end
  end
end
