indexing
	description: "Filter matching on priorities."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

class
	
	L4E_STRING_MATCH_FILTER

inherit
	
	L4E_FILTER
	
create
	
	make

feature -- Initialization
	
	make (str_match: STRING; match_on_filter: BOOLEAN) is
			-- Create filter to match 'str_match' in 
			-- message of event.
			-- The decision is Filter_accept if 
			-- 'str_match' if found and 'match_on_filter' 
			-- is True. If a match is found and 
			-- 'match_on_filter' is False then 
			-- Filter_reject is returned.
			-- If no match is found then Filter_neutral 
			-- is returned.
		require
			str_match_exists: str_match /= Void
		do
			string_match := str_match
			match := match_on_filter
		end

feature -- Status report

	decide (event: L4E_EVENT): INTEGER is
			-- Should 'event' be logged. Return one of Filter_accept,
			-- Filter_reject, or Filter_neutral.
		do
			if event.rendered_message.substring_index (string_match, 1) = 0 then
				Result := Filter_neutral
			else
				if match then
					Result := Filter_accept
				else
					Result := Filter_reject
				end
			end
		end

feature {NONE} -- Implementation

	string_match: STRING
			-- Priority to match
			
	match: BOOLEAN

end -- class L4E_STRING_MATCH_FILTER
