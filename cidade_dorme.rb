#!/usr/bin/env ruby

require 'sinatra'
require 'json'
require_relative 'control'

get '/' do
  {bla: 10}.to_json
end

get '/newroom' do
  {room: create_room, success: true}.to_json
end

post '/newuser' do
  nick = create_user params[:nick]
  if nick.nil?
    {success: false}.to_json
  else
    {nick: nick, sucess: true}.to_json
  end
end

get '/rooms/:room' do
  room = room_info params[:room]
  if room.nil?
    {sucess: false}.to_json
  else
    {**room, sucess: true}.to_json
  end
end

post '/rooms/:room/join' do
  {sucess: join_room(params[:nick], params[:room])}.to_json
end

post '/rooms/:room/define_roles' do
  {success: define_roles(params[:room].to_i)}.to_json
end
