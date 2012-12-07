require 'css_sortor/version.rb'
require 'css_sortor/css_parser.rb'
require 'debugger'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

module CssParser
	def self.hello 
		puts "hello"
	end
end


class CSSSortor

	def initialize(options)
		@parser = CssParser::Parser.new
		puts options[:path]
		puts 'parser loadfile.'
		@parser.load_file!(options[:path])
		puts 'loaded.'
		alipay_process!(@parser)
		puts @parser.to_s
	end

	def alipay_process!(parser)
		CssParser.hello
	end

end