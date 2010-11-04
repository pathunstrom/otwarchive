source 'http://rubygems.org'

gem 'bundler', '~>1.0.0' 

gem 'rails', '3.0.1'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Database
# gem 'sqlite3-ruby', :require => 'sqlite3'
gem 'mysql2'

# Use unicorn as the web server
gem 'unicorn', :require => false

# Deploy with Capistrano
gem 'capistrano', :require => false

# Here are all our application-specific gems
gem 'rack-openid', '>=0.2.1', :require => 'rack/openid'


#gem 'will_paginate', '3.0.pre'
gem 'will_paginate',
  :git     => 'git://github.com/huerlisi/will_paginate.git',
  :branch  => 'rails3',
  :require => 'will_paginate'

gem 'htmlentities'
gem 'whenever', :require => false
gem 'nokogiri'
gem 'mechanize'
gem 'sanitize'
gem 'rest-client', :require => 'rest_client'
gem 'delayed_job', '>=2.1.0.pre2'
gem 'thinking-sphinx',
  :git     => 'git://github.com/freelancing-god/thinking-sphinx.git',
  :branch  => 'rails3',
  :require => 'thinking_sphinx'
gem 'ts-delayed-delta', :require => 'thinking_sphinx/deltas/delayed_delta'
#gem 'daemon-spawn', :require => 'daemon_spawn'
gem 'aws-s3', :require => 'aws/s3'
# gem 'fastercsv' -- will use this eventually for exporting to excel tsv format
gem 'mocha'
gem 'css_parser'

gem 'paperclip',
  :git => 'git://github.com/thoughtbot/paperclip.git', 
  :branch => 'master',
  :require => 'paperclip'

gem 'tolk',
  :git => 'git://github.com/ambtus/tolk.git',
  :branch => 'rails3',
  :require => 'tolk'

gem 'authlogic',
  :git     => 'git://github.com/odorcicd/authlogic.git',
  :branch  => 'rails3',
  :require => 'authlogic'

# A highly updated version of the authorization plugin
gem 'permit_yo'

# fix for annoying UTF-8 error messages as per this:
# http://openhood.com/rack/ruby/2010/07/15/rack-test-warning/
gem "escape_utils"

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  # enable debugging with "rails server -u" or "rails server --debugger"
  if RUBY_VERSION >= '1.9'
    gem 'ruby-debug19', :require => 'ruby-debug'
  else
    gem 'ruby-debug'
  end
  gem 'rspec-rails', '>=2.0.0.beta.22'  
end

group :test do
  gem 'pickle'
  gem 'shoulda'
  gem 'factory_girl'
  gem 'capybara', '=0.3.9'
  gem 'database_cleaner', '>=0.6.0.rc.3'
  gem 'cucumber-rails'
  gem 'cucumber', '>=0.9.1'
  gem 'launchy'    # So you can do Then show me the page
end

group :production do
  gem "memcache-client"
  gem 'exception_notification',
    :git     => 'git://github.com/rails/exception_notification.git',
    :branch  => 'master',
    :require => 'exception_notifier'
end

