module CssParser

	class Sortor

		GROUPORDER = [ 
			'position', 
			'top', 
			'right', 
			'bottom', 
			'left', 
			'z-index', 
			'display', 
			'float', 
			'width', 
			'height', 
	    'max-width', 
	    'max-height', 
	    'min-width', 
	    'min-height', 
	    'padding', 
	    'padding-top', 
	    'padding-right', 
	    'padding-bottom', 
	    'padding-left', 
	    'margin', 
	    'margin-top', 
	    'margin-right', 
	    'margin-bottom', 
	    'margin-left', 
	    'margin-collapse', 
	    'margin-top-collapse', 
	    'margin-right-collapse', 
	    'margin-bottom-collapse', 
	    'margin-left-collapse', 
	    'overflow', 
	    'overflow-x', 
	    'overflow-y', 
	    'clip', 
	    'clear', 
	    'font', 
	    'font-family', 
	    'font-size', 
	    'font-smoothing', 
	    'font-style', 
	    'font-weight', 
	    'hyphens', 
	    'src', 
	    'line-height', 
	    'letter-spacing', 
	    'word-spacing', 
	    'color', 
	    'text-align', 
	    'text-decoration', 
	    'text-indent', 
	    'text-overflow', 
	    'text-rendering', 
	    'text-size-adjust', 
	    'text-shadow', 
	    'text-transform', 
	    'word-break', 
	    'word-wrap', 
	    'white-space', 
	    'vertical-align', 
	    'list-style', 
	    'list-style-type', 
	    'list-style-position', 
	    'list-style-image', 
	    'pointer-events', 
	    'cursor', 
	    'background', 
	    'background-attachment', 
	    'background-color', 
	    'background-image', 
	    'background-position', 
	    'background-repeat', 
	    'background-size', 
	    'border', 
	    'border-collapse', 
	    'border-top', 
	    'border-right', 
	    'border-bottom', 
	    'border-left', 
	    'border-color', 
	    'border-top-color', 
	    'border-right-color', 
	    'border-bottom-color', 
	    'border-left-color', 
	    'border-spacing', 
	    'border-style', 
	    'border-top-style', 
	    'border-right-style', 
	    'border-bottom-style', 
	    'border-left-style', 
	    'border-width', 
	    'border-top-width', 
	    'border-right-width', 
	    'border-bottom-width', 
	    'border-left-width', 
	    'border-radius', 
	    'border-top-right-radius', 
	    'border-bottom-right-radius', 
	    'border-bottom-left-radius', 
	    'border-top-left-radius', 
	    'border-radius-topright', 
	    'border-radius-bottomright', 
	    'border-radius-bottomleft', 
	    'border-radius-topleft', 
	    'content', 
	    'quotes', 
	    'outline', 
	    'outline-offset', 
	    'opacity', 
	    'filter', 
	    'visibility', 
	    'size', 
	    'zoom', 
	    'transform', 
	    'box-align', 
	    'box-flex', 
	    'box-orient', 
	    'box-pack', 
	    'box-shadow', 
	    'box-sizing', 
	    'table-layout', 
	    'animation', 
	    'animation-delay', 
	    'animation-duration', 
	    'animation-iteration-count', 
	    'animation-name', 
	    'animation-play-state', 
	    'animation-timing-function', 
	    'animation-fill-mode', 
	    'transition', 
	    'transition-delay', 
	    'transition-duration', 
	    'transition-property', 
	    'transition-timing-function', 
	    'background-clip', 
	    'backface-visibility', 
	    'resize', 
	    'appearance', 
	    'user-select', 
	    'interpolation-mode',
	    'direction', 
	    'marks', 
	    'page', 
	    'set-link-source', 
	    'unicode-bidi'
    ]

		VENDORPREFIXES = ['-webkit-', '-khtml-', '-epub-', '-moz-', '-ms-', '-o-']
		HACKPREFIXES = ['_' , '*']

		STRIP_CSS_COMMENTS_RX = /\/\*.*?\*\//m
		STRIP_HTML_COMMENTS_RX = /\<\!\-\-|\-\-\>/m

		def initialize(decs, options={})
			@options = {:sort_mode => 'abc'}.merge(options)
			@decs = decs
			@sort_arr = []
		end

		def generate_sort_arr
			if @options[:sort_mode] == 'abc' then
				g_sort_abc_arr
			else 
				g_sort_group_arr
			end
		end

		def g_sort_abc_arr
			@decs.each do |property, data|
				@sort_arr << property
			end
			process_comment
			process_vendor
			process_hack
			@sort_arr = @sort_arr.uniq.sort
		end

		def g_sort_group_arr
			@sort_arr = GROUPORDER
		end

		def calculate_sort_point
			selector = ""
			@decs.each do |property, data|
				selector, data[:point] = property, 0
				if is_vendor?(selector) then
					data[:point] += 0.2
					selector = delete_vendor(selector)
				end
				if is_hack?(selector) then
					data[:point] += 0.2
					selector = delete_hack(selector)
				end
				if is_comment?(selector) then
					data[:point] += 0.1
					selector = delete_comment(selector)
				end
				data[:point] += @sort_arr.index(selector).to_i
			end
			@decs
		end

		private

		def process_vendor
			@sort_arr.each do |elem|
				elem.gsub!(/\-(webkit|khtml|epub|moz|ms|o)\-/m, '')
			end
			@sort_arr
		end

		def delete_vendor(str)
			str.gsub(/\-(webkit|khtml|epub|moz|ms|o)\-/m, '')
		end

		def is_vendor?(str) 
			!!str.match(/\-(webkit|khtml|epub|moz|ms|o)\-/m)
		end 

		def process_hack
			@sort_arr.each do |elem|
				elem.gsub!(/\-(\_|\*)\-/m, '')
			end
			@sort_arr
		end

		def delete_hack(str)
			str.gsub(/\-(\_|\*)\-/m, '')
		end

		def is_hack?(str) 
			!!str.match(/\-(\_|\*)\-/m)
		end 

		def process_comment
			tmp = []
			@sort_arr.each do |elem|
				desc = elem.gsub(Regexp.union(STRIP_CSS_COMMENTS_RX, STRIP_HTML_COMMENTS_RX), '')
				tmp << desc
			end
			@sort_arr = tmp
		end

		def delete_comment(str)
			str = str.gsub(Regexp.union(STRIP_CSS_COMMENTS_RX, STRIP_HTML_COMMENTS_RX), '')
		end

		def is_comment?(str) 
			str.match(Regexp.union(STRIP_CSS_COMMENTS_RX, STRIP_HTML_COMMENTS_RX)) || str.match(/^(\/\*)/)
		end 

	end

end