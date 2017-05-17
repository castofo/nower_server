namespace :nower do
  desc "Converts the Swagger documentation from YAML to JSON, placing it under public/swagger.json"\
       " PREREQUISITE: node installed in the machine, with 'multi-file-swagger' package globally"\
       " installed. (npm i -g multi-file-swagger)"
  task doc: :environment do
    Dir.chdir(Rails.root.join('app', 'doc')) do
      input_path = Rails.root.join('app', 'doc', 'swagger.yml')
      output_path = Rails.root.join('public', 'swagger.json')
      command = "multi-file-swagger #{input_path} > #{output_path}"
      if system(command)
        puts "JSON written in #{output_path}"
      else
        puts "ERROR: Could not process JSON with documentation. Do you have node and "\
             "'multi-file-swagger' module globally installed?"
      end
    end
  end
end
