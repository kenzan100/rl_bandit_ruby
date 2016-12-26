module Bandit
  class Analyzer
    def initialize(player:)
      @player_name = player.id
    end

    def add(run:, result:)
      rewards[run.to_i] = (rewards[run.to_i] << result)
    end

    def rewards
      @rewards ||= Hash.new { |h, k| h[k] = [] }
    end

    def average_rewards(at:)
      rewards_at = @rewards[at.to_i]
      reward = (rewards_at.reduce(&:+) / rewards_at.length)
      "Player #{@player_name} Average rewards at:#{at} is #{reward}"
    end
  end
end
