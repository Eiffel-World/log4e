indexing
	description: "Pattern converter for formatting literal strings"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2001 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

class L4E_LITERAL_PATTERN_CONVERTER
	
inherit
	
	L4E_PATTERN_CONVERTER
		rename
			make as pattern_converter_make
		redefine
			format
		end
	
creation
	
	make
	
feature -- Initialisation
	
	make (value: STRING) is
			-- Create literal converter for 'value'
		require
			value_exists: value /= Void
		do
			literal := value
		end
	
feature -- Basic operations
	
	format (sbuf: STRING; event: L4E_EVENT) is
			-- Format literal and append to 'sbuf'
		do
			sbuf.append (literal)
		end
	
feature {NONE} -- Implementation
	
	literal: STRING
			-- String to format
	
	convert (event: L4E_EVENT): STRING is
			-- Convert conversion specifiers appropriately.
		do
			-- not used
		end
	
end -- class L4E_LITERAL_PATTERN_CONVERTER
