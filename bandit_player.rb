module Bandit
  class Player
    def initialize(how_greedy:)
      @how_greedy = how_greedy
    end

    def plays(bandit)
      bandit_memory = find_or_initialize_bandit_memories(bandit)

      action = if greedy_this_time
                 bandit_memory.best_action
               else
                 bandit_memory.random_action
               end

      reward = bandit.receive(action.id)
      bandit_memory.re_evaluate(action.id, with: reward)
      reward
    end

    def id
      "#{@how_greedy}"
    end

    private

    def find_or_initialize_bandit_memories(bandit)
      memory = bandit_memories[bandit.id]
      memory.actions = bandit.action_values if memory.empty?
      memory
    end

    def bandit_memories
      @bandit_memories ||= Hash.new { |h, k| h[k] = BanditMemory.new }
    end

    def greedy_this_time
      rand < @how_greedy
    end

    class BanditMemory
      def re_evaluate(action, with:)
        reward = with
        actions[action].values << reward
      end

      def empty?
        actions.empty?
      end

      def best_action
        cur_max = actions.max_by { |_k, action| action.average }[1].average
        max_actions = actions.select { |_k, action| action.average == cur_max }
        max_actions.values.sample
      end

      def random_action
        actions.values.sample
      end

      def actions
        @actions ||= Hash.new
      end

      def actions=(action_values)
        @actions = action_values.reduce({}) { |acc, val|
          acc[val] = Action.new(id: val)
          acc
        }
      end

      class Action
        def initialize(id:)
          @id = id
        end

        def id
          @id
        end

        def values
          @values ||= []
        end

        def average
          (values.reduce(&:+) || 0) / values.length
        rescue ZeroDivisionError
          0
        end
      end
    end
  end
end
