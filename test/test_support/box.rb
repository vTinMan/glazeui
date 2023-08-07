# frozen_string_literal: true

module TestSupport
  class Box < FakeElement
    def initialize(_mode)
      super()
    end

    def pack_start(element)
      add_child(element)
    end
  end
end
