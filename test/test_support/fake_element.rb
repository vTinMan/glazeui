# frozen_string_literal: true

module TestSupport
  class FakeElement
    def show
      # nothing
    end

    def add_child(element)
      children << element
    end

    def children
      @children ||= []
    end
  end
end
