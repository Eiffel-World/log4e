indexing
	description: "Log4E multi column list event row"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_EVENT_ROW

inherit

	EV_MULTI_COLUMN_LIST_ROW
		rename
			make as row_make
		export
			{NONE} row_make
		end
		
create
	make

feature {NONE} -- Initialisation

	make (event: L4E_STORABLE_EVENT) is
			-- Create new row representing 'event'
		require
			event_not_void: event /= Void
		do
			default_create
			log_event := event	
			-- store column data
			force (event.time_stamp)
			force (event.priority)
			force (event.logger_name)
			force (event.message)
		end

feature -- Access

	log_event: L4E_STORABLE_EVENT
			-- The log event represented by this row
			
invariant
	
	log_event_not_void: log_event /= Void
	
end -- class L4E_EVENT_ROW
