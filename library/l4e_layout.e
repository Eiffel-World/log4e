indexing
	description: "Abstract notion of an event layout formatter."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

deferred class

	L4E_LAYOUT

feature -- Rendering

	format (event: L4E_EVENT): STRING is
			-- Format contents of 'event' according to this layout's
			-- formatting rules
		require
			event_exists: event /= Void
		deferred
		ensure
			formatted_exists: Result /= Void
		end

	header: STRING is
			-- Format a header for this layout.
		deferred
		ensure
			header_exists: Result /= Void
		end
		
	footer: STRING is
			-- Format a footer for this layout.
		deferred
		ensure
			footer_exists: Result /= Void
		end
	
end -- class L4E_LAYOUT
