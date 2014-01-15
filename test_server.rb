#!/usr/bin/env ruby
require 'sinatra'
require 'json'
require_relative './app/neo4ruby'
require_relative './simulation_startup'

class TestServer < Sinatra::Base

  extend SimulationStartup

  simulation_manager = start_simulation
  query_processor = start_query_processor

  get "/status" do
    JSON(status: "Listening")
  end

  get "/search" do
    raw_query = params[:query]
    res = { answers: "" }

    Neo4rubyLogger.log(level: :debug, msg: "Received query with params: #{params}")

    if raw_query
      query = query_processor.run(raw_query)

      Neo4rubyLogger.log(level: :debug, msg: "Running simulation")
      res[:answers] = simulation_manager.answer_query(query)

      Neo4rubyLogger.log(level: :debug, msg: "Simulation ended.")
    end

    JSON(res)
  end

end