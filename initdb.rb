#!/usr/bin/env ruby

require 'sequel'

DB = Sequel.sqlite 'cidade.db'

DB.create_table :user do
  String :nick
  primary_key [:nick]
end

DB.create_table :room do
  primary_key :room_id
end

DB.create_table :room_player do
  foreign_key :room_id, :room
  foreign_key :nick, :user
  String :role
end

