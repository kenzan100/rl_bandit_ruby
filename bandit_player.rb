module Bandit
  class Player
    def initialize(how_greedy:)
      @how_greedy = how_greedy
    end

    def plays(bandit)
      bandit_memory = bandit_memories[bandit.id]

      action = if greedy_this_time
                 bandit_memory.best_action
               else
                 bandit_memory.random_action
               end

      reward = bandit.receive(action)
      bandit_memory.re_evaluate(action, with: reward)
    end

    private

    def bandit_memories
      { id: bandit_memory }
    end

    def greedy_this_time
      rand < @how_greedy
    end

    class BanditMemory
      def re_evaluate(action, with:)
        reward = with
        actions[action].values << reward
      end

      def best_action
        cur_max = actions.max_by(&:average).average
        max_actions = actions.select { |action| action.average == cur_max }
        max_actions.sample
      end

      def random_action
        actions.sample
      end

      def actions
        @actions ||= Hash.new(Action.new)
      end

      class Action
        def values
          @values ||= []
        end

        def average
          values.reduce(&:+) / values.length
        end
      end
    end
  end
end
