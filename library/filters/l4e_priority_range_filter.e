indexing
	description: "Filter matching on a range of priorities."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

class
	L4E_PRIORITY_RANGE_FILTER

inherit

	L4E_FILTER

creation
	
	make
	
feature -- Initialization

	make (min_priority, max_priority: L4E_PRIORITY; match_on_filter: BOOLEAN) is
			-- Create filter to match 'priority'. The decision is based on
			-- the following decisions:
			--
			-- If the priority is outside the range (inclusive) then Filter_reject is returned.
			-- If the priority is within the range and 'match_on_filter' is True then
			-- Filter_accept is returned.
			-- If the priority is within the range and 'match_on_filter' if False then
			-- Filter_neutral is returned.
			--
			-- Passing Void for 'min_priority' effectively sets no minimum range.
			-- Passing Void for 'max_priority' effectively sets no maximum range.
		require
			range_specified: min_priority /= Void or max_priority /= Void
			range_valid: min_priority /= Void and max_priority /= Void
				implies min_priority < max_priority
		do
			minimum_priority := min_priority
			maximum_priority := max_priority
			match := match_on_filter
		end

feature -- Status report

	decide (event: L4E_EVENT): INTEGER is
			-- Should 'event' be logged. Return one of Filter_accept,
			-- Filter_reject, or Filter_neutral.
		local
			range_min_match, range_max_match: BOOLEAN
		do
			-- check minimum range
			if minimum_priority = Void then
				range_min_match := True
			elseif event.priority >= minimum_priority then
				range_min_match := True
			end				
			
			-- check maximum range
			if maximum_priority = Void then
				range_max_match := True
			elseif event.priority <= maximum_priority then
				range_max_match := True
			end
			
			if not (range_min_match and range_max_match) then
				Result := Filter_reject
			elseif match then
				Result := Filter_accept
			else
				Result := Filter_neutral
			end
		end

feature {NONE} -- Implementation

	minimum_priority, maximum_priority: L4E_PRIORITY
			-- Priority to range
			
	match: BOOLEAN

end -- class L4E_PRIORITY_RANGE_FILTER
