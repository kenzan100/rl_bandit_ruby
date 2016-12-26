require 'distribution'

module Bandit
  class Machine
    def initialize(seed:, arm_num:)
      @arm_num = arm_num
      actions
    end

    def receive(action)
      actions[action].reward
    end

    private

    def actions
      @actions ||= arm_num.times.reduce({}) { |acc, num|
        acc[num] = Action.new
        acc
      }
    end

    class Action
      def initialize
        @true_reward = Distribution::Normal.rng.call
      end

      def reward
        Distribution::Normal.rng(mean: @true_reward).call
      end
    end
  end
end
