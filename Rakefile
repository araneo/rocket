# -*- ruby -*-

COMPONENTS = %w[rocket rocket-core rocket-server rocket-js]

desc "Build current version as a rubygem"
task :build do
  COMPONENTS.each {|component| `cd #{component}; rake build; cd ..` }
end

desc "Relase current version to rubygems.org"
task :release => :build do
  `git tag -am "Version bump to #{Rocket.version}" v#{Rocket.version}`
  `git push origin master`
  `git push origin master --tags`
  
  COMPONENTS.each {|component| `cd #{component}; rake release; cd ..` }
end

desc "Perform installation via rubygems"
task :install do
  COMPONENTS.each {|component| `cd #{component}; rake install; cd ..` }
end

desc "Run specs for all components"
task :spec do
  COMPONENTS.each {|component| `cd #{component}; rake spec; cd ..` }
end
