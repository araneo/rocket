# -*- ruby -*-
$:.unshift(File.expand_path('../rocket/lib', __FILE__))
$:.unshift(File.expand_path('../rocket-core/lib', __FILE__))
require 'rocket/version'

COMPONENTS = %w[rocket-core rocket-server rocket-js rocket]

desc "Build current version as a rubygem"
task :build do
  COMPONENTS.each {|component| 
    sh "cd #{component}; rake build; cd .." 
  }
end

desc "Relase current version to rubygems.org"
task :release => :build do
  sh "git tag -am 'Version bump to #{Rocket.version}' v#{Rocket.version}"
  sh "git push origin master"
  sh "git push origin master --tags"
  COMPONENTS.each {|component| 
    sh "cd #{component}; rake release; cd .." 
  }
end

desc "Perform installation via rubygems"
task :install do
  COMPONENTS.each {|component| 
    sh "cd #{component}; rake install; cd .." 
  }
end

desc "Run specs for all components"
task :spec do
  COMPONENTS.each {|component| 
    sh "cd #{component}; rake spec; cd .." 
  }
end
