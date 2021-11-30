# puts '.model'
KManager.model

# puts '.model'
KManager.model :via_param_key

# puts '.model'
KManager.model key: :via_named_key

# puts '.csv'
KManager.csv(file: 'spec/samples/.builder/data_files/countries.csv') do
  load
end

# puts '.json'
KManager.json(file: 'spec/samples/.builder/data_files/PersonDetails.json') do
  load
end

# puts '.yaml'
KManager.yaml(file: 'spec/samples/.builder/data_files/sample-yaml-list.yaml') do
  load
end

# puts '.yaml'
KManager.yaml(file: 'spec/samples/.builder/data_files/sample-yaml-object.yaml') do
  load
end
