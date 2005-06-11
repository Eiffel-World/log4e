indexing
	description: "Pattern converter"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

deferred class L4E_PATTERN_CONVERTER
	
feature -- Initialisation
	
	make (formatting_info: L4E_FORMATTING_INFO) is
			-- Initialise with 'formatting_info'.
		require
			formatting_info_exists: formatting_info /= Void
		do
			min := formatting_info.min
			max := formatting_info.max
			left_align := formatting_info.left_align
		end
	
feature -- Status report
	
	min: INTEGER
			-- Minimum length of converted string, -1 for 
			-- no minimum.
	
	max: INTEGER
			-- Maximum length of converted string, 
			-- Max_integer for no maximum.
	
	
	left_align: BOOLEAN
			-- Should the string be left aligned.
	
	
feature -- Basic operations
	
	format (sbuf: STRING; event: L4E_EVENT) is
			-- Template routine for formatting in a converter
			-- specific way.
		require
			sbuf_exists: sbuf /= Void
			event_exists: event /= Void
		local
			s: STRING
			len: INTEGER
		do
			s := convert_event (event)
			if s = Void then
				if 0 < min then
					space_pad (sbuf, min)
				end
			else
				len := s.count
				if len > max then
					sbuf.append_string (s.substring (len - max + 1, len))
				elseif len < min then
					if left_align then
						sbuf.append (s)
						space_pad (sbuf, min - len)
					else
						space_pad (sbuf, min - len)
						sbuf.append (s)
					end
				else
					sbuf.append (s)
				end
			end
		end
	
feature {NONE} -- Implementation
	
	convert_event (event: L4E_EVENT): STRING is
			-- Convert conversion specifiers appropriately.
		require
			event_exists: event /= Void
		deferred
		ensure
			converted_string_exists: Result /= Void
		end
	
	space_pad (str: STRING; length: INTEGER) is
			-- Pad 'str' with 'length' space characters.
		require
			str_exists: str /= Void
			positive_length: length >= 0
		local
			pad: STRING
		do
			create pad.make_filled (' ', length) -- fix for Bug 764301

			str.append (pad)
		ensure
			correct_size: str.count >= old str.count + length
		end

end -- class L4E_PATTERN_CONVERTER

	
