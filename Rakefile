require 'rubygems'
gem 'hoe', '>= 2.1.0'
require 'hoe'
require 'fileutils'
require './lib/picasa_plucker'

Hoe.plugin :newgem
# Hoe.plugin :website
Hoe.plugin :cucumberfeatures

# Generate all the Rake tasks
# Run 'rake -T' to see list of generated tasks (from gem root directory)
$hoe = Hoe.spec 'picasa_plucker' do
  self.developer 'Dr Nic Williams', 'drnicwilliams@gmail.com'
  self.extra_deps << ['hpricot','>= 0.8.2']
  self.extra_deps << ['ruby-progressbar','>= 0.0.9']
end

require 'newgem/tasks'
Dir['tasks/**/*.rake'].each { |t| load t }

task :default => [:spec, :features]
