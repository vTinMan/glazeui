module GlazeUI
  module ViewKit
    Position = Struct.new(:pos_method, :pos_args)

    class PositionError < StandardError; end
  end
end
