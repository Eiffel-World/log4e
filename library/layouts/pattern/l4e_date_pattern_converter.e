indexing
	description: "Pattern converter for formatting literal strings"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

class L4E_DATE_PATTERN_CONVERTER
	
inherit
	
	L4E_PATTERN_CONVERTER
		rename
			make as pattern_converter_make
		export
			{NONE} pattern_converter_make
		end

create

	make
	
feature -- Initialisation
	
	make (formatting_info: L4E_FORMATTING_INFO; options: STRING) is
			-- Initialise with 'formatting_info'.
		require
			formatting_info_exists: formatting_info /= Void
		do
			pattern_converter_make (formatting_info)
		end
		
feature {NONE} -- Implementation
	
	convert_event(event: L4E_EVENT): STRING is
			-- Convert conversion specifiers appropriately.
		do
			Result := event.time_stamp.out
		end
	
end -- class L4E_DATE_PATTERN_CONVERTER
