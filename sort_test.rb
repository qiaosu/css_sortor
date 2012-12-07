VENDORPREFIXES = ['-webkit-', '-khtml-', '-epub-', '-moz-', '-ms-', '-o-']

HACKPREFIXES = ['_' , '*']

STRIP_CSS_COMMENTS_RX = /\/\*.*?\*\//m
STRIP_HTML_COMMENTS_RX = /\<\!\-\-|\-\-\>/m

def sort_by_abc(decs)
	original_properties = []
	real_properties = []
	decs.each do |property, data|
		original_properties << property
	end
	real_properties = process_comment(original_properties)
	real_properties = process_vendor(real_properties)
	real_properties = process_hack(real_properties)
	real_properties = real_properties.uniq.sort
end

def process_vendor(arr)
	output = []
	arr.each do |elem|
		output << elem.gsub(/\-(webkit|khtml|epub|moz|ms|o)\-/m, '')
	end
	output
end

def process_hack(arr)
	output = []
	arr.each do |elem|
		output << elem.gsub(/\-(\_|\*)\-/m, '')
	end
	output
end

def process_comment(arr)
	output = []
	arr.each do |elem|
		dec = elem.gsub(Regexp.union(STRIP_CSS_COMMENTS_RX, STRIP_HTML_COMMENTS_RX), '')
		dec = dec.gsub(/^(\/\*)/, '').strip
		output << dec
	end
	output
end

