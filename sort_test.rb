module CssParser

	class Sortor

		VENDORPREFIXES = ['-webkit-', '-khtml-', '-epub-', '-moz-', '-ms-', '-o-']
		HACKPREFIXES = ['_' , '*']

		STRIP_CSS_COMMENTS_RX = /\/\*.*?\*\//m
		STRIP_HTML_COMMENTS_RX = /\<\!\-\-|\-\-\>/m

		def initialize(decs, options={})
			@decs = decs
			@sort_arr = []
		end

		def generate_sort_arr
			original_properties = []
			real_properties = []
			@decs.each do |property, data|
				original_properties << property
			end
			real_properties = process_comment(original_properties)
			real_properties = process_vendor(real_properties)
			real_properties = process_hack(real_properties)
			real_properties = real_properties.uniq.sort
			@sort_arr = real_properties
		end

		def calculate_sort_point!
			selector = ""
			@decs.each do |property, data|
				selector, data[:point] = property, 0
				if is_vendor?(selector) then
					data[:point] += 0.2
					selector = process_vendor(selector)
				end
				if is_hack?(selector) then
					data[:point] += 0.2
					selector = process_hack(selector)
				end
				if is_comment?(selector) then
					data[:point] += 0.1
					selector = process_comment(selector)
				end
				data[:point] += @sort_arr.index(selector).to_i
			end
			@decs
		end

		private

		def process_vendor(obj)
			if obj.class == String then
				output = obj.gsub(/\-(webkit|khtml|epub|moz|ms|o)\-/m, '')
			else
				output = []
				obj.each do |elem|
					output << elem.gsub(/\-(webkit|khtml|epub|moz|ms|o)\-/m, '')
				end
			end

			output
		end

		def is_vendor?(str) 
			!!str.match(/\-(webkit|khtml|epub|moz|ms|o)\-/m)
		end 

		def process_hack(obj)
			if obj.class == String then 
				output = obj.gsub(/\-(\_|\*)\-/m, '')
			else
				output = []
				obj.each do |elem|
					output << elem.gsub(/\-(\_|\*)\-/m, '')
				end
			end

			output
		end

		def is_hack?(str) 
			!!str.match(/\-(\_|\*)\-/m)
		end 

		def process_comment(obj)
			if obj.class == String then
				output = obj.gsub(Regexp.union(STRIP_CSS_COMMENTS_RX, STRIP_HTML_COMMENTS_RX), '')
				output = output.gsub(/^(\/\*)/, '').strip
			else
				output = []
				obj.each do |elem|
					dec = elem.gsub(Regexp.union(STRIP_CSS_COMMENTS_RX, STRIP_HTML_COMMENTS_RX), '')
					dec = dec.gsub(/^(\/\*)/, '').strip
					output << dec
				end
			end

			output
		end

		def is_comment?(str) 
			str.match(Regexp.union(STRIP_CSS_COMMENTS_RX, STRIP_HTML_COMMENTS_RX)) || str.match(/^(\/\*)/)
		end 

	end

end