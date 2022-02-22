KManager.model :simple do
  settings do
    me          :simple
    name        'simple-name'
    description 'simple-description'
  end
end

KManager.model :deep, namespace: %i[multi nested] do
  settings do
    me          :deep
    name        'deep-name'
    description 'deep-description'
  end
end

KManager.model :simple_initialize do
  init do
    context.some_data = os(
      name: 'some-name',
      description: 'some-description')
  end
  settings do
    me          :simple_initialize
    name        context.some_data.name
    description context.some_data.description
  end
end

# # Migrate to:
# # Import.data(doc, :simple_kdoc, as: :ostruct)
# # doc.import_data(:simple_kdoc, :simple, as: :ostruct)

KManager.model :simple_dependency do
  depend_on(:simple_kdoc)
  init do
    context.simple = import_data(:simple_kdoc, as: :ostruct)
  end
  settings do
    me          :simple_dependency
    name        "import from: #{context.simple.settings.name}"
    description "import from: #{context.simple.settings.description}"
  end
end

# KManager.model :multiple_import do
#   simple  = import_data(:simple_kdoc, as: :ostruct)
#   deep    = import_data(:multi_nested_deep_kdoc, as: :ostruct)
  
#   settings :from_simple do
#     name        simple.settings.name
#     description simple.settings.description
#   end

#   settings :from_deep do
#     name        deep.settings.name
#     description deep.settings.description
#   end
# end

# KManager.model :recursion_a do
#   grab_from  = import_data(:recursion_b_kdoc, as: :ostruct)
#   settings do
#     me          :recursion_a
#     grab        grab_from.settings&.me || :recursion_b_not_set
#   end
# end

# KManager.model :recursion_b do
#   settings do
#     me          :recursion_b
#   end
# end

# # KManager.model :key3, namespace: %i[a b c]
# # KManager.model :duplicate_key
# # KManager.action :duplicate_key
# # KManager.csv(:duplicate_key, file: 'spec/samples/.builder/data_files/countries.csv') do
# #   load
# # end
# # KManager.json(:duplicate_key, file: 'spec/samples/.builder/data_files/PersonDetails.json') do
# #   load
# # end
# # KManager.yaml(:duplicate_key, file: 'spec/samples/.builder/data_files/sample-yaml-list.yaml') do
# #   load
# # end
