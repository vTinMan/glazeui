# frozen_string_literal: true

module GlazeUI
  class BaseController
    attr_reader :view

    def initialize(view)
      @view = view
    end

    def form
      view.form
    end
  end
end
