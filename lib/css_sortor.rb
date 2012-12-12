require 'css_sortor/version.rb'
require 'css_sortor/css_parser.rb'

# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

class CSSSortor

	def initialize(options)
		@parser = CssParser::Parser.new({:sort_mode => options[:order]})
		@parser.load_file!(options[:path])
		# output

		file = File.expand_path(options[:path])
		file_name = File.basename(file, ".css")
		f_path = File.dirname(file)
		target_name = options[:target] || file_name+'_output.css'

		if check_exist(f_path + '/' +target_name) then
			raise "#{target_name} is exist now, You can not cover this file."
			return
		end

		create_file(f_path + '/' +target_name)
		puts 'Generate has been successfully.'
	end

	def check_exist(path)
		Dir.glob(path).length > 0
	end

	def create_file(path)
		open(File.expand_path(path, __FILE__), 'w') { |f|
      f.puts @parser.to_s
    }
	end

end