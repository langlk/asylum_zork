#!/usr/bin/env ruby

require 'spec_helper'

describe('User') do
  let(:user) { User.create({
    moves: 0,
    game_text: ""
    })
  }

  let(:room) { Room.create({
    name: 'Start',
    description: 'The First Room.',
    x_coordinate: 1,
    y_coordinate: 1,
    active: true,
    solution_item: 'key',
    north_exit: true,
    east_exit: false,
    south_exit: true,
    west_exit: true,
    first_impression: 'you have entered a spooky foyer',
    visited: false,
    user_id: user.id
    }) }

  let(:item) { Item.create({
    name: "key",
    room_id: room.id,
    user_id: user.id,
    in_inventory: false,
  }) }

  describe '#rooms' do
    it "returns all rooms assigned to a user" do
      expect(user.rooms).to eq([room])
    end
  end

  describe '.clear_expired' do
    it "removes all user data for users who have not accessed their session within 'timeframe'" do
      user.update({updated_at: Time.now - (60)})
      user2 = User.create({ game_text: "", moves: 0})
      User.clear_expired(60)
      expect(User.all).to eq([user2])
    end
  end
end
