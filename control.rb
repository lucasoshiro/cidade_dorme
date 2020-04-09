require 'sequel'

DB = Sequel.sqlite './cidade.db'

def create_room
  DB[:room].insert
end

def create_user nick
  begin
    DB[:user].insert nick: nick
  rescue Sequel::UniqueConstraintViolation
    nil
  end
end

def join_room nick, room
  begin
    DB[:room_player].insert room_id: room, nick: nick
    true
  rescue
    false
  end
end

def room_info room
  begin
    room_id = DB[:room].where(room_id: room).first[:room_id]
    players = DB[:room_player]
                .where(room_id: room)
                .join(:user, nick: :nick)
                .map {|player| {nick: player[:nick], role: player[:role]}}
    {room_id: room_id,
     players: players}
  rescue
    nil
  end
end

def define_roles room
  roles = ['mayor', 'murderer', 'angel', 'detective', 'victim', 'lawyer']

  begin
    players = DB[:room_player]
                .where(room_id: room)
                .join(:user, nick: :nick)
                .map {|player| player[:nick]}
                .to_a
                .shuffle

    players.zip(roles).to_h.each do
      |nick, role|
      DB[:room_player].where(nick: nick).update(:role => role)
    end
    true

  rescue
    false
  end
end

def allusers
  DB[:user].all
end
