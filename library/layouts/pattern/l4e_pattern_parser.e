indexing
	description: "Pattern parser"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_PATTERN_PARSER
	
inherit
	
	L4E_SHARED_LOG_LOG
		
creation
	
	make
	
feature -- Initialisation

	make (new_pattern: STRING) is
			-- Parse 'new_pattern' and make pattern converter 
			-- list available in 'converters'. If an 
			-- error occurs then log errors and set 'ok' 
			-- to False.
		require
			pattern_exists: new_pattern /= Void
		do
			create converters.make
			pattern := new_pattern
			pattern_length := pattern.count
			state := Literal_state
			parse_pattern
		end
	
feature -- Status report
	
	converters: DS_LINKED_LIST [L4E_PATTERN_CONVERTER]
			-- List of pattern converters to apply.
	
feature {NONE} -- Implementation
	
	Escape_char: CHARACTER is '@'
	
	Literal_state: INTEGER is unique
	Converter_state: INTEGER is unique
	Minus_state: INTEGER is unique
	Dot_state: INTEGER is unique
	Min_state: INTEGER is unique
	Max_state: INTEGER is unique
	
	state: INTEGER
	current_literal: STRING
	pattern_length: INTEGER
	i: INTEGER
	formatting_info: L4E_FORMATTING_INFO
	pattern: STRING
	
	extract_option: STRING is
			-- Extract option string from current position
		local
			last: INTEGER
		do
			if i <= pattern_length and pattern.item (i) = '{' then
				last := pattern.index_of ('}', i)
				if last > i then
					Result := pattern.substring (i + 1, last)
					i := last + 1
				end
			end
		end
	
	extract_precision_option: INTEGER is
			-- Extract precision option. Expected to be 
			-- in decimal and positive. In case of error 
			-- zero is returned.
		local
			opt: STRING
		do
			opt := extract_option
			if opt /= Void then
				if opt.is_integer then
					Result := opt.to_integer
					if Result <= 0 then
						internal_log.error ("Presision option (" + opt + ") isn't a positive integer.")
					end
				end
			end
		end
	
	parse_pattern is
			-- Parse 'pattern' and create list of pattern elements for each
			-- distinct part.
		require
			pattern_exists: pattern /= Void
		local
			c: CHARACTER
			converter: L4E_PATTERN_CONVERTER
		do
			from
				i := 1
				create current_literal.make (32)
				create formatting_info.make
			until
				i > pattern_length
			loop
				c := pattern.item (i)
				inspect state
				when Literal_state then
					if i = pattern_length then
						current_literal.append_character (c)
					elseif c = Escape_char then
						-- peek at the next char
						inspect pattern.item (i + 1)
						when Escape_char then
							current_literal.append_character (c)
							i := i + 1
						when 'n' then
							current_literal.append_character ('%N')
							i := i + 1
						else
							if current_literal.count /= 0 then
								create {L4E_LITERAL_PATTERN_CONVERTER} converter.make (clone (current_literal))
								converters.force_last (converter)
							end
							current_literal.wipe_out
							current_literal.append_character (c)
							state := Converter_state
							formatting_info.reset
						end
					else
						current_literal.append_character (c)
					end
				when Converter_state then
					current_literal.append_character (c)
					inspect c 
					when '-' then
						formatting_info.set_left_align
					when '.' then
						state := Dot_state
					else
						if c >= '0' and c <= '9' then
							formatting_info.set_min (c.code - ('0').code)
							state := Min_state
						else
							finalize_converter (c)
						end
					end
				when Min_state then
					current_literal.append_character (c)
					if c >= '0' and c <= '9' then
						formatting_info.set_min (formatting_info.min * 10 + (c.code - ('0').code))
					elseif c = '.' then
						state := Dot_state
					else
						finalize_converter (c)
					end
				when Dot_state then
					current_literal.append_character (c)
					if c >= '0' and c <= '9' then
						formatting_info.set_max (c.code - ('0').code)
						state := Max_state
					else
						internal_log.error ("Error occured in position " + i.out + 
								    ".%N Was expecting digit, instead got char '" + c.out + "'.")
						state := Literal_state
					end
				when Max_state then
					current_literal.append_character (c)
					if c >= '0' and c <= '9' then
						formatting_info.set_max (formatting_info.max * 10 + (c.code - ('0').code))
					else
						finalize_converter (c)
						state := Literal_state
					end
				end
				-- move to next character
				i := i + 1
			end
			if current_literal.count /= 0 then 
				create {L4E_LITERAL_PATTERN_CONVERTER} converter.make (clone (current_literal))
				converters.force_last (converter)
			end
		end
	
	finalize_converter (c: CHARACTER) is
		local
			converter: L4E_PATTERN_CONVERTER
			cat_converter: L4E_CATEGORY_PATTERN_CONVERTER
			date_converter: L4E_DATE_PATTERN_CONVERTER
			message_converter: L4E_MESSAGE_PATTERN_CONVERTER
			relative_time_converter: L4E_RELATIVE_TIME_PATTERN_CONVERTER
			literal_converter: L4E_LITERAL_PATTERN_CONVERTER
			priority_converter: L4E_PRIORITY_PATTERN_CONVERTER
		do
			inspect c
			when 'c' then
				create cat_converter.make (formatting_info, extract_precision_option)
				converter := cat_converter
			when 'd' then
				create date_converter.make (formatting_info, extract_option)
				converter := date_converter
			when 'm' then
				create message_converter.make (formatting_info)
				converter := message_converter
			when 'r' then
				create relative_time_converter.make (formatting_info)
				converter := relative_time_converter
			when 'p' then
				create priority_converter.make (formatting_info)
				converter := priority_converter
			else
				internal_log.error ("Unexpected char [" + c.out + "at position " + i.out + " in conversion pattern.")
				create literal_converter.make (clone (current_literal))
				converter := literal_converter
			end
			current_literal.wipe_out
			add_converter (converter)
		end
	
	add_converter (converter: L4E_PATTERN_CONVERTER) is
			-- Add 'converter' to list of pattern converters.
		require
			converter_exists: converter /= Void
		do
			current_literal.wipe_out
			converters.force_last (converter)
			state := Literal_state
			formatting_info.reset
		end
	
end -- class L4E_PATTERN_PARSER
