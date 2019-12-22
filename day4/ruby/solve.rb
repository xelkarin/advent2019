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
    cnt = 0
    current = 0
    seqs = []

    password.digits.each do |d|
      if current != d
        seqs.push(cnt)
        cnt = 0
      end
      cnt += 1
      current = d
    end
    seqs.push(cnt)
    seqs.include?(2)
  end
end

num = data.valid_passwords.size
puts "Number of possible valid passwords: #{num}"
