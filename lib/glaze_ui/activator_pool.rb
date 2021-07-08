module GlazeUI
  class ActivatorPool
    def initialize
      @activators = {}
    end

    def add_activator(activated_view, controller)
      # TODO: rescue by inheritance

      @activators[activated_view] = controller
    end

    def [](view)
      @activators[view]
    end
  end

  ACTIVATORS = ActivatorPool.new
end
