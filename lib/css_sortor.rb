require 'css_sortor/version.rb'
require 'css_sortor/css_parser.rb'
require 'debugger'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

class CSSSortor

	def initialize(options)
		@parser = CssParser::Parser.new({:sort_mode => options[:order]})
		@parser.load_file!(options[:path])
		# output
		puts @parser.to_s
	end

end