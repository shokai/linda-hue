#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'em-rocketio-linda-client'
require 'hue'
$stdout.sync = true

EM::run do
  hue = Hue::Client.new

  url   = ENV["LINDA_BASE"]  || ARGV.shift || "http://localhost:5000"
  space = ENV["LINDA_SPACE"] || "test"
  puts "connecting.. #{url}"
  linda = EM::RocketIO::Linda::Client.new url
  ts = linda.tuplespace[space]

  linda.io.on :connect do  ## RocketIO's "connect" event
    puts "connect!! <#{linda.io.session}> (#{linda.io.type})"
    ts.watch ["hue"] do |tuple|
      p tuple
      if tuple.size == 2
        _, state = tuple
        results =
          case state.downcase
          when "on"
            hue.lights.map do |light|
            light.on = true
          end
          when "off"
            hue.lights.map do |light|
            light.on = false
          end
          when "random"
            hue.lights.map do |light|
            state = { :on => true, :hue => rand(65535),
              :saturation => rand(255), :brightness => rand(255) }
            light.set_state state, 1
          end
          end
        tuple << results
        ts.write tuple
      elsif tuple.size == 6
        if tuple[2] == "hsb"
          _,id,_,h,s,b = tuple
          state = { :on => true, :hue => h.to_i,
            :saturation => s.to_i, :brightness => b.to_i }
          hue.lights[id.to_i].set_state state, 1
        end
      elsif tuple.size == 3
        if ["on", "off"].include? tuple[2]
          _,id,stat = tuple
          hue.lights[id.to_i].on = (stat == "on") ? true : false
        end
      end
    end
  end

  linda.io.on :disconnect do
    puts "RocketIO disconnected.."
  end
end
