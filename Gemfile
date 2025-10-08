source "http://rubygems.org"

gemspec

gem "fat_free_crm"
gem 'responds_to_parent2', git: 'https://github.com/CloCkWeRX/responds_to_parent.git'
gem 'acts_as_commentable', git: 'https://github.com/fatfreecrm/acts_as_commentable.git', tag: "7.1.0"

group :development, :test do
  gem "jquery-rails" # jquery-rails is used by the dummy application
  gem "byebug" unless ENV["CI"]
end
