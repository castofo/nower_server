namespace :nower do
  desc 'Converts the Swagger documentation from YAML to JSON, placing it under public/swagger.json'
  task doc: :environment do
    input_path = Rails.root.join('app', 'doc', 'swagger.yml')
    input_file = File.open(input_path, 'r')
    puts "Processing YAML file from #{input_path}"
    input_yaml = input_file.read
    input_file.close
    output_path = Rails.root.join('public', 'swagger.json')
    output_file = File.open(output_path, 'w+')
    output_json = JSON.pretty_generate(YAML::load(input_yaml))
    output_file.write(output_json)
    output_file.close
    puts "JSON written in #{output_path}"
  end
end
