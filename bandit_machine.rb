require 'rubystats'

module Bandit
  class Machine
    def initialize(arm_num:, name:)
      @arm_num = arm_num
      @name = name
      actions
    end

    def receive(action)
      actions[action].reward
    end

    def id
      @name
    end

    def action_values
      actions.keys
    end

    private

    def actions
      @actions ||= @arm_num.times.reduce({}) { |acc, num|
        acc[num] = Action.new
        acc
      }
    end

    class Action
      def initialize
        @true_reward = Rubystats::NormalDistribution.new(0, 1).rng
      end

      def reward
        Rubystats::NormalDistribution.new(@true_reward, 1).rng
      end
    end
  end
end
