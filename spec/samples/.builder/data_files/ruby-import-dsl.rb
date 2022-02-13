KManager.model :key1
KManager.model :key2, namespace: :a
KManager.model :key3, namespace: %i[a b c]
KManager.model :duplicate_key
KManager.action :duplicate_key
KManager.csv(:duplicate_key, file: 'spec/samples/.builder/data_files/countries.csv') do
  load
end
KManager.json(:duplicate_key, file: 'spec/samples/.builder/data_files/PersonDetails.json') do
  load
end
KManager.yaml(:duplicate_key, file: 'spec/samples/.builder/data_files/sample-yaml-list.yaml') do
  load
end
