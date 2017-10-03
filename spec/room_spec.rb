#!/usr/bin/env ruby

require 'spec_helper'

describe('Room') do
  let(:room) { Room.new({
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
    visited: false
  }) }

  let(:item) { Item.new({
    name: "key",
    room_id: nil,
    in_inventory: false,
  }) }

  describe '#look' do
    it "returns the room's description if the room has already been visited" do
      room.save
      room.look
      expect(room.look).to eq('The First Room.')
    end

    it "returns first impression upon first visit to the room and marks room as visited" do
      room.save
      expect(room.look).to eq('you have entered a spooky foyer')
      expect(room.visited).to eq(true)
    end
  end

  describe '.find_by_coordinates' do
    it "returns the active room with the coordinates passed in" do
      room.save
      expect(Room.find_by_coordinates(1, 1)).to eq(room)
    end

    it "returns nil if no active room with the coordinates passed in" do
      room.save
      expect(Room.find_by_coordinates(0, 0)).to eq(nil)
    end
  end

  describe '#move' do
    it "returns nil when there is not an exit" do
      expect(room.move('east')).to eq(nil)
    end

    it "returns new room when there is an exit" do
      room2 = Room.new({
        name: 'Next',
        description: 'The Next Room.',
        x_coordinate: 1,
        y_coordinate: 2,
        active: true,
        solution_item: 'key',
        north_exit: true,
        east_exit: false,
        south_exit: true,
        west_exit: false,
      })
      room2.save
      expect(room.move('north')).to eq(room2)
    end
  end

  describe '#item' do
    it "returns item in room" do
      room.save
      item.room_id = room.id
      item.save
      expect(room.item).to eq(item)
    end
  end

  describe '#take' do
    it "moves item from room to inventory" do
      room.save
      item.room_id = room.id
      item.save
      room.take(item.name)
      expect(Item.find(item.id).in_inventory).to eq(true)
      expect(Room.find(room.id).item).to eq(nil)
    end
  end

  describe('#use') do
    it("returns the room's success version if the item is correct and in the user's inventory, and marks item as used") do
      item.in_inventory = true
      item.save
      room2 = Room.create({
       name: 'Start',
       description: 'The First Room.',
       x_coordinate: 1,
       y_coordinate: 1,
       active: false,
       solution_item: 'key',
       north_exit: true,
       east_exit: false,
       south_exit: true,
       west_exit: true,
       first_impression: 'you have used the key!',
       visited: false
     })
    expect(room.use("key")).to eq(room2)
    expect(Room.find(room2.id).active).to eq(true)
    expect(Item.find(item.id).in_inventory).to eq(false)
    end
  end

  describe '#note' do
    it "returns the note assigned to the room" do
      room.save
      note = Note.create({
        room_id: room.id,
        note_text: "This is a super scary note."
      })
      expect(room.note).to eq(note)
    end
  end

  describe '#read' do
    it "returns the text of the note assigned to the room" do
      room.save
      note = Note.create({
        room_id: room.id,
        note_text: "This is a super scary note."
      })
      expect(room.read).to eq("This is a super scary note.")
    end
  end
end
