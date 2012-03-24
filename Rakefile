desc 'Generate guides (for authors) in English, use ONLY=foo to process just "foo.textile"'
task :generate_guides_EN do
  ENV['GUIDES_LANGUAGE']='EN' 
  ENV['RAILS_VERSION'] = 'v3.2' 
  ruby "rails_guides.rb"
end


desc "Task description"
task :generate_guides_CN do
  ENV['GUIDES_LANGUAGE']='CN'
  ENV['RAILS_VERSION'] = 'v3.2' 
  ruby "rails_guides.rb"
end

task :generate_guides => [:generate_guides_CN, :generate_guides_EN ]

desc 'Validate guides, use ONLY=foo to process just "foo.html"'
task :validate_guides do
  ruby "w3c_validator.rb"
end
