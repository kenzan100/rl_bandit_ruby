module Bandit
  class Analyzer
    attr_reader :rewards

    def initialize(player:)
    end

    def add(run:, result:)
      @rewards ||= Hash.new([])
      @rewards[run.to_i] = @rewards[run.to_i] << result
    end

    def average_rewards(at:)
      rewards_at = @rewards[at.to_i]
      reward = (rewards_at.reduce(&:+) / rewards_at.length)
      "Average rewards at:#{at} is #{reward}"
    end
  end
end
