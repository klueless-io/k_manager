# frozen_string_literal: true

def people
  # person = KManager.get(:tp_ben_dover).data
  # people = KManager.get(:tp_traveling_people).data
  person = nil
  people = []
  people << person

  # Join the data in traveling_people with ben-dover and return a single array
  people.reject(&:nil?)
end
