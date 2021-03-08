# frozen_string_literal: true

module Registerable
  extend ActiveSupport::Concern

  included do
    has_one :register, as: :registerable, touch: true, dependent: :destroy
  end
end
