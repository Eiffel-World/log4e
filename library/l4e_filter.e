indexing
	description: "Filter for log events to determine if they should be logged or not."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

deferred class
	L4E_FILTER

inherit
	
	L4E_FILTER_CONSTANTS

feature -- Status report

	decide (event: L4E_EVENT): INTEGER is
			-- Should 'event' be logged. Return one of Filter_accept,
			-- Filter_reject, or Filter_neutral.
		require
			event_exists: event /= Void
		deferred
		ensure
			valid_result: valid_filter_decision (Result)
		end
		
end -- class L4E_FILTER
