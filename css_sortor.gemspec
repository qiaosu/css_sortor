# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','css_sortor','version.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'css_sortor'
  s.version = CssSortor::VERSION
  s.author = 'Kenshin'
  s.email = 'tracy.xin.li@gmail.com'
  s.homepage = 'http://www.decimage.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Fantasy CSS Sort Out Method.'
# Add your other files here if you make them
  s.files = %w(
bin/css_sortor
lib/css_sortor/version.rb
lib/css_sortor.rb
  )
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','css_sortor.rdoc']
  s.rdoc_options << '--title' << 'css_sortor' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'css_sortor'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('addressable')
  s.add_development_dependency('debugger')
  s.add_runtime_dependency('gli','2.5.0')
end
