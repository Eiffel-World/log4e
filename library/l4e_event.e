indexing
	description: "Logging event."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."
	
class L4E_EVENT
	
inherit
	
	DT_SHARED_SYSTEM_CLOCK

creation
	
	make
	
feature -- Initialisation
	
	make (log: L4E_LOGGER; event_priority: L4E_PRIORITY; event_message: ANY) is
			-- Create a new logging event for the 
			-- logger 'log', priority 'event_priority' 
			-- and message object 'event_message'. The 
			-- message will be converted to a string 
			-- using '.out'.
		require
			cat_exists: log /= Void
			event_priority_exists: event_priority /= Void
			event_message_exists: event_message /= Void
		do
			logger := log
			priority := event_priority
			message := event_message
			rendered_message := render (message)
			time_stamp := system_clock.date_time_now
		end
	
feature -- Status Report
	
	logger: L4E_LOGGER
			-- The logger in which this logging event occurred.
	
	priority: L4E_PRIORITY
			-- The logging priority level for this event.
	
	message: ANY
			-- Unrenderred message object
	
	rendered_message: STRING
			-- String representation of 'message' after 
			-- applying layout.
	
	time_stamp: DT_DATE_TIME
			-- Time stamp indicating when event was created.
	
feature -- Transformation

	as_storable: L4E_STORABLE_EVENT is
			-- Convert to a storable memento object
		do
			create Result.make (Current)
		end
		
feature {NONE} -- Implementation
	
	render (obj: ANY): STRING is
			-- Render 'obj' by calling '.out' and applying layout 
			-- to the resulting string.
		require
			obj_exists: obj /= Void
		do
			Result := obj.out
		end
	
end -- class L4E_EVENT

