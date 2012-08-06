# Application Generator Template
# Used to create a new Rails 3 Application
# Usage: 
# rails new APP_NAME -m <git_url>/rails_3_template.rb


# clean up files and folders
run "rm public/index.html"
run "rm app/assets/images/rails.png"
run "rm app/views/layouts/application.html.erb"
run "rm -rf test/"


# Heroku production webserver
gem 'thin'


# Dev and Test gems
gem 'foreman', :group => [:development, :test]
gem 'rspec-rails', '~> 2.10.1', :group => [:development, :test]
gem 'factory_girl_rails', '~> 3.2.0', :group => [:development, :test]
gem 'guard-rspec', '~> 0.7.0', :group => [:development, :test]


# Test ONLY gems
gem 'faker', '~> 1.0.1', :group => [:test]
gem 'capybara', '~> 1.1.2', :group => [:test]
gem 'database_cleaner', '~> 0.7.2', :group => [:test]
gem 'launchy', '~> 2.1.0', :group => [:test]


# Production ONLY gems
gem 'pg', :group => [:production]


# Asset related gems
gem "twitter-bootstrap-rails", :group => [:assets]


# DB
rake "db:create", :env => 'development'
rake "db:create", :env => 'test'


# RSpec
inject_into_file 'config/application.rb', :after => "config.assets.version = '1.0'" do
  <<-eos
    
    
    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: true,
        request_specs: true
      g.fixture_replacement :factory_girl, dir: "spec/factories"
     end
  eos
end
generate "rspec:install"
run "echo '--format documentation' >> .rspec"


# Twitter Bootstrap
generate "bootstrap:install"
generate "bootstrap:layout application fixed"


# command used to launch web process on Heroku
run "touch Procfile"
run "echo 'web: bundle exec rails server thin -p $PORT -e $RACK_ENV' >> Procfile"
run "echo 'RACK_ENV=development' >>.env"


# Git
run "echo '.env' >> .gitignore"
git :init
git :add => "."
git :commit => "-am 'Generated initial Application'"


say "!!!!!!!! Your new Rails application is ready !!!!!!!!"
