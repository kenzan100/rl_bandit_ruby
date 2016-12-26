require_relative 'bandit_machine'
require_relative 'bandit_player'
require_relative 'bandit_analyzer'

require 'byebug'

def create_machines(how_many:, arm_num:)
  how_many.times.map do |i|
    Bandit::Machine.new(arm_num: arm_num, name: "bandit #{i}")
  end
end

def spawn_players(greedy_values:)
  greedy_values.map do |greedy_value|
    Bandit::Player.new(how_greedy: greedy_value)
  end
end

bandits = create_machines(how_many: 10, arm_num: 10)
players = spawn_players(greedy_values: [1, 0.99, 0.9])

num_of_runs_per_problem = 100

analyzers = []
players.each do |player|
  analyzer = Bandit::Analyzer.new(player: player)
  bandits.each do |bandit|
    num_of_runs_per_problem.times do |run_i|
      puts("#{bandit.id}, #{run_i} ") if run_i % 10 == 0
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
