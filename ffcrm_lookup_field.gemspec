$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ffcrm_lookup_field/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ffcrm_lookup_field"
  s.version     = FfcrmLookupField::VERSION
  s.authors     = ["Steve Kenworthy"]
  s.email       = ["steveyken@gmail.com"]
  s.homepage    = "http://www.fatfreecrm.com"
  s.summary     = "A custom field suitable for lookup tables"
  s.description = "Add the ability for fields to lookup various tables in Fat Free CRM"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails"
  s.add_dependency "fat_free_crm"

  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
end
