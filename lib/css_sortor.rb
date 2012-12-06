require 'css_sortor/version.rb'
require 'css_parser'

module CssParser
	def self.hello 
		puts "hello"
	end
end

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

class CSSSortor

	def initialize(options)
		@parser = CssParser::Parser.new
		puts options[:path]
		puts 'parser loaduri.'
		@parser.load_uri!('http://dev.assets.alipay.net/fundselling/alice.fundselling-1.0-SNAPSHOT-src.css')
		puts 'loaded.'
		alipay_process!(@parser)
		puts @parser.to_s
	end

	def alipay_process!(parser)
		CssParser.hello
	end

end