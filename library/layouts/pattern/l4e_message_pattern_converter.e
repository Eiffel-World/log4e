indexing
	description: "Pattern converter for formatting event messages"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

class L4E_MESSAGE_PATTERN_CONVERTER
	
inherit
	
	L4E_PATTERN_CONVERTER

create
	
	make
	
feature {NONE} -- Implementation
	
	convert_event (event: L4E_EVENT): STRING is
			-- Convert conversion specifiers appropriately.
		do
			Result := event.rendered_message
		end
	
end -- class L4E_MESSAGE_PATTERN_CONVERTER
