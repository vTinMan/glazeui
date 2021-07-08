# RSpec.describe GlazeUI::BaseActivator do
#   let(:some_controller) do
#     class SomeView
#     end
#
#     module SomeActivator
#       extend GlazeUI::BaseActivator
#       activate_view SomeView
#     end
#
#     class SomeController
#       include SomeActivator
#     end
#
#     SomeController.new
#   end
#
#   it do
#     expect(some_controller.send(:activator)).to eq(SomeActivator)
#     expect(some_controller.send(:activator).activated_view).to eq(SomeView)
#     expect(some_controller.send(:current_view)).to be_a(SomeView)
#   end
# end
