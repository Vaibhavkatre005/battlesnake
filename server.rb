require 'rubygems'
require 'benchmark'
require 'sinatra'
require 'json'
require 'pry' if development?
require "sinatra/reloader" if development?
require 'awesome_print'

Dir["lib/*.rb"].each {|file| require_relative file }

set :port, ENV['PORT']
set :bind, '0.0.0.0'

TEST_DATA = {
  "you": "25229082-f0d7-4315-8c52-6b0ff23fb1fb",
  "width": 25,
  "turn": 0,
  "snakes": [
    {
      "taunt": "git gud",
      "name": "my-snake",
      "id": "25229082-f0d7-4315-8c52-6b0ff23fb1fb",
      "health_points": 93,
      "coords": [[18,10],[15,10],[16,10],[17,10]]
    },
    {
      "taunt": "gotta go fast",
      "name": "other-snake",
      "id": "0fd33b05-37dd-419e-b44f-af9936a0a00c",
      "health_points": 50,
      "coords": [[3,5],[4,5],[5,5],[6,5],[7,5],[8,5],[9,5],[10,5],[10,6],[10,7]]
    }
  ],
  "height": 15,
  "game_id": "870d6d79-93bf-4941-8d9e-944bee131167",
  "food": [[18,5]],
  "dead_snakes": [
    {
      "taunt": "gotta go fast",
      "name": "other-snake",
      "id": "c4e48602-197e-40b2-80af-8f89ba005ee9",
      "health_points": 50,
      "coords": [[5,12],[5,12],[5,12]]
    }
  ]
}

get '/' do
  return { message: 'Hello World'}.to_json
end

get '/bind' do
  # binding.pry
  bench = Benchmark.measure { 
    g = Grid.new(
      width: TEST_DATA[:width], 
      height: TEST_DATA[:height],
      me: TEST_DATA[:you],
      snakes: TEST_DATA[:snakes].collect{|s| Snake.new(s)},
      food: TEST_DATA[:food].collect{|f| Food.new(x:f[0], y:f[1])}
    );
    p = Painter.new(g)
    p.paint
    # p.grid.print
    tb = TreeBuilder.new(p.grid)
    tb.build_tree
    t = tb.tree
    puts "Node count: #{tb.count}"
    # binding.pry
  }

  return { 
    message: "Done bind.",
    time: "#{Time.now}",
    bench: "#{(bench.total*1000).floor}ms",
    time_percent: "#{bench.total.round(2)*1000*100/200}%",
    levels: Config::Tree::LEVELS
  }.to_json
end

post '/start' do

    # Example input

    # {
    #   "width": 20,
    #   "height": 20,
    #   "game_id": "b1dadee8-a112-4e0e-afa2-2845cd1f21aa"
    # }
  	return {
    	color: "#FF0000",
    	head_url: "http://placecage.com/c/100/100",
    	name: "Holy Smokes Korea",
    	taunt: "gorogorogoro"
  	}.to_json
end

post '/move' do
    requestBody = request.body.read
    req = requestBody ? JSON.parse(requestBody) : {}

    # example request
    #
    # {
    #   "you": "25229082-f0d7-4315-8c52-6b0ff23fb1fb",
    #   "width": 2,
    #   "turn": 0,
    #   "snakes": [
    #     {
    #       "taunt": "git gud",
    #       "name": "my-snake",
    #       "id": "25229082-f0d7-4315-8c52-6b0ff23fb1fb",
    #       "health_points": 93,
    #       "coords": [[0,0],[0,0],[0,0]]
    #     },
    #     {
    #       "taunt": "gotta go fast",
    #       "name": "other-snake",
    #       "id": "0fd33b05-37dd-419e-b44f-af9936a0a00c",
    #       "health_points": 50,
    #       "coords": [[1,0],[1,0],[1,0]]
    #     }
    #   ],
    #   "height": 2,
    #   "game_id": "870d6d79-93bf-4941-8d9e-944bee131167",
    #   "food": [[1,1]],
    #   "dead_snakes": [
    #     {
    #       "taunt": "gotta go fast",
    #       "name": "other-snake",
    #       "id": "c4e48602-197e-40b2-80af-8f89ba005ee9",
    #       "health_points": 50,
    #       "coords": [[5,0],[5,0],[5,0]]
    #     }
    #   ]
    # }



  	return {
    	move: ["left","right","up","down"].sample,
    	taunt: "gorogorogoro"
	}.to_json
end

post '/end' do
  return { message: 'Game over'}.to_json
end
