indexing
	description: "Log event filter constants."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_FILTER_CONSTANTS

feature -- Filter Constants

	Filter_accept: INTEGER is unique
			-- Event will be logged. Remaining filters will not
			-- be consulted.
			
	Filter_reject: INTEGER is unique
			-- Event will not be logged.
			
	Filter_neutral: INTEGER is unique
			-- Remaining filters will be consulted to determine
			-- if the event should be logged. If there are no
			-- remaining filters then the event will be logged.
	
	valid_filter_decision (code: INTEGER): BOOLEAN is
			-- Is 'code' a valid filter result code?
		do
			Result := code = Filter_accept or code = Filter_reject or code = Filter_neutral
		end
		
end -- class L4E_FILTER_CONSTANTS
