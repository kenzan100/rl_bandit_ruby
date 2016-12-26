require_relative 'bandit_machine'
require_relative 'bandit_player'
require_relative 'bandit_analyzer'

def create_machines(how_many:, seed:)
  how_many.times.map do
    Bandit::Machine.new(seed: seed)
  end
end

def spawn_players(greedy_values:)
  greedy_values.map do |greedy_value|
    Bandit::Player.new(how_greedy: greedy_value)
  end
end

bandits = create_machines(how_many: 2_000, seed: 1)
players = spawn_players(greedy_values: [1, 0.99, 0.9])

num_of_runs_per_problem = 1_000

analyzers = []
players.each do |player|
  analyzer = Bandit::Analyzer.new(player: player)
  bandits.each do |bandit|
    num_of_runs_per_problem.times do |run_i|
      analyzer.add(run: run_i, result: player.plays(bandit))
    end
  end
  analyzers << analyzer
end

step = (num_of_runs_per_problem / 100)
sample_runs_i = num_of_runs_per_problem.times.select { |i| i % step == 0 }
sample_runs_i.each do |sample_run_i|
  analyzers.each do |analyzer|
    puts analyzer.average_rewards(at: sample_run_i).to_s
  end
end

