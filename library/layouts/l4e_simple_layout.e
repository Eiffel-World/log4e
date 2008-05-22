indexing
	description: "Simple layout using 'priority - message'"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

class
	L4E_SIMPLE_LAYOUT

inherit
	
	L4E_LAYOUT

	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end
	
feature -- Rendering

	format (event: L4E_EVENT): STRING is
			-- Format contents of 'event' according to this layout's
			-- formatting rules. 
			-- Format is: priority - message
		do
			Result := event.priority.level_str.twin
			Result.append_string (" - ")
			Result.append_string (event.rendered_message)
			Result.append_string ("%N")
		end

	header: STRING is
			-- Format a header for this layout.
		do
			Result := "Log opened: " + system_clock.date_time_now.out + "%N"
		end
		
	footer: STRING is
			-- Format a footer for this layout.
		do
			Result := "Log closed: " + system_clock.date_time_now.out + "%N"
		end
				
end -- class L4E_SIMPLE_LAYOUT
