indexing
	description: "Filter matching on priorities."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_PRIORITY_MATCH_FILTER

inherit

	L4E_FILTER

creation
	
	make
	
feature -- Initialization

	make (priority: L4E_PRIORITY; match_on_filter: BOOLEAN) is
			-- Create filter to match 'priority'. The decision is based on
			-- the following table:
			--
			-- Match Occurred           Match_on_filter
			--                       True             False
			--     True          Filter_accept    Filter_reject
			--     False         Filter_reject    Filter_accept
		require
			priority_exists: priority /= Void
		do
			matching_priority := priority
			match := match_on_filter
		end

feature -- Status report

	decide (event: L4E_EVENT): INTEGER is
			-- Should 'event' be logged. Return one of Filter_accept,
			-- Filter_reject, or Filter_neutral.
		local
			match_occurred: BOOLEAN
		do
			if event.priority.is_equal (matching_priority) then
				match_occurred := True
			end		
			if match xor match_occurred then
				Result := Filter_reject
			else
				Result := Filter_accept
			end
		end

feature {NONE} -- Implementation

	matching_priority: L4E_PRIORITY
			-- Priority to match
			
	match: BOOLEAN

end -- class L4E_PRIORITY_MATCH_FILTER
