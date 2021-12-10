# frozen_string_literal: true

class People
  def add_person(first_name, last_name, age)
    people << Person.new(first_name, last_name, age)
  end

  def people
    @people ||= []
  end
end

class Person

  attr_accessor :first_name
  attr_accessor :last_name
  attr_accessor :age

  def initialize(first_name, last_name, age)
    @first_name = first_name
    @last_name = last_name
    @age = age
  end

  def full_name
    [first_name, last_name].reject(&:blank?).join(' ')
  end
end

