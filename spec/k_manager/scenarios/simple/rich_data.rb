# frozen_string_literal: true

KManager.csv :dsl_countries, file: 'spec/k_manager/scenarios/simple/countries.csv' do
  load
end

KManager.json :dsl_traveling_people, file: 'spec/k_manager/scenarios/simple/traveling-people.json' do
  load
end

KManager.yaml :dsl_other_people, file: 'spec/k_manager/scenarios/simple/other-people.yaml' do
  # load
end

KManager.model :global do
  settings do
    key1 'value1'
    key2 'value2'
  end
end

KManager.model :admin_users do
  table :users do
    fields :user_name, :user, :email

    row :bad_ass  , 'Ken Va'    , 'ken@foliage.com.au'
    row :louise   , 'Louise'    , 'louise@gmail.com'
    row :alex     , 'Alexandro' , 'alex@gmail.com'
  end
end

