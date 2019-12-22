#!/usr/bin/ruby
# frozen_string_literal: true

DATA = (264793..803935).freeze

class << data = DATA.dup
  def valid_passwords
    self.select { |i| increasing_values?(i) }
        .select { |i| same_adjacent?(i) }
  end

  private

  def increasing_values?(password)
    current = 0
    password.digits.reverse.each do |d|
      return false if current > d

      current = d
    end
    true
  end

  def same_adjacent?(password)
    current = 0
    password.digits.reverse.each do |d|
      return true if current == d

      current = d
    end
    false
  end
end

num = data.valid_passwords.size
puts "Number of possible valid passwords: #{num}"
