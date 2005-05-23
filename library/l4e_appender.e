indexing
	description: "Logging appender on which logging events can be appended."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."
	
deferred class L4E_APPENDER
		
inherit
	
	L4E_FILTER_CONSTANTS
		export
			{NONE} all
		end
	
	L4E_SHARED_LOG_LOG
	
	MEMORY
		export
			{NONE} all
		undefine
			dispose
		redefine
			dispose
		end
	
feature -- Initialisation
	
	make (new_name: STRING) is
			-- Create new appender with 'name'
			--| Descendants should either call this 
			--| routine or declare it as a creation routine.
		require
			new_name_exists: new_name /= Void
		do
			name := new_name
			create filters.make
			is_open := True
			create {L4E_SIMPLE_LAYOUT} layout
		end
	
feature -- Status Report
	
	name: STRING
			-- Name of this appender that uniquely 
			-- identifies it.

	layout: L4E_LAYOUT
			-- Layout used to format events for this appender. May be Void
			-- if no layout is used.

	is_open: BOOLEAN
			-- Is the appender open for appending?
			
feature -- Status Setting
	
	set_layout (new_layout: L4E_LAYOUT) is
			-- Set the layout that this appender should use.
		require
			layout_exists: new_layout /= Void
		do
			layout := new_layout
		end
	
	close is
			-- Release any resources for this appender.
		deferred
		ensure
			closed: not is_open
		end
	
	append (event: L4E_EVENT) is
			-- Log event on this appender.
		require
			event_exists: event /= Void
			is_open: is_open
		local
			done, accept: BOOLEAN
			c: DS_LINKED_LIST_CURSOR [L4E_FILTER]
		do
			-- filter event through filters to determine
			-- if it should be logged
			if filters.is_empty then
				do_append (event)
			else
				from
					c := filters.new_cursor
					c.start
				until
					c.off or done
				loop
					inspect c.item.decide (event)
					when Filter_accept then
						done := True
						accept := True
					when Filter_reject then
						done := True
					else -- Filter_neutral
						c.forth	
						if c.off then
							done := True
							accept := True
						end
					end	
				end
				if accept then
					do_append (event)
				end
			end
		end
	
	set_name (new_name: STRING) is
			-- Set the name of this appender
		require
			name_exists: new_name /= Void
		do
			name := new_name
		end
	
	add_filter (filter: L4E_FILTER) is
			-- Add 'filter' to the list of filters to 
			-- apply when determining if a log event will
			-- be processed by this appender.
		require
			filter_exists: filter /= Void
			filter_not_added: not has_filter (filter)
		do
			filters.force_last (filter)
		ensure
			filter_added: has_filter (filter)
		end
		
	has_filter (filter: L4E_FILTER): BOOLEAN is
			-- Is 'filter' in the list of filters for this
			-- appender?
		require
			filter_exists: filter /= Void
		do
			Result := filters.has (filter)
		end
		
	remove_filter (filter: L4E_FILTER) is
			-- Remove 'filter' from the list of filters for this
			-- appender.
		require
			filter_exists: filter /= Void
			filter_added: has_filter (filter)
		do
			filters.delete (filter)
		ensure
			filter_removed: not has_filter (filter)
		end
		
feature -- Removal

	dispose is
			-- Close this appender when garbage collected. Perform
			-- minimal operations to release resources. Do not call
			-- other object as they may have been garbage collected.
		deferred
		end
		
feature {NONE} -- Implementation

	do_append (event: L4E_EVENT) is
			-- Append 'event' to this appender
		require
			event_exists: event /= Void
			is_open: is_open
		deferred
		end
		
	filters: DS_LINKED_LIST [L4E_FILTER]
			-- Filters that determine if a log event is processed for this
			-- appender or not.
			
end -- class L4E_APPENDER

