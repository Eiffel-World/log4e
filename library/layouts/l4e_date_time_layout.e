indexing
	description: "Layout using 'formatted_date_time - priority - message'"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_DATE_TIME_LAYOUT

inherit
	
	L4E_SIMPLE_LAYOUT
		redefine
			format
		end

feature -- Rendering

	format (event: L4E_EVENT): STRING is
			-- Format contents of 'event' according to this layout's
			-- formatting rules. 
			-- Format is: formatted_date - priority - message
		do
			Result := event.time_stamp.out
			Result.append (" - ")
			Result.append (event.priority.level_str)
			Result.append (" - ")
			Result.append (event.rendered_message)
			Result.append ("%N")
		end
	
end -- class L4E_DATE_TIME_LAYOUT
