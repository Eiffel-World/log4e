indexing
	description: "Logging logger."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2001 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."
	
class L4E_LOGGER
	
inherit
	
	L4E_PRIORITY_CONSTANTS
		undefine
			is_equal
		end
	
	COMPARABLE
	
creation
	
	make
	
feature {L4E_LOGGER_FACTORY} -- Initialisation
	
	make (hierarchy: L4E_HIERARCHY; cat_name: STRING) is
			-- Create new logger with 'cat_name'
		require
			cat_name_exists: cat_name /= Void
		do
			context := hierarchy
			name := cat_name
			create appenders.make
			is_additive := True
		ensure
			context_set: context = hierarchy
			name_set: name = cat_name
			additive: is_additive
		end
	
feature -- Status Report
	
	name: STRING
			-- Name of this logger

	priority: L4E_PRIORITY is
			-- Starting from this caregory, search the logger 
			-- hieararchy for a non-null priority and return it. 
			-- Otherwise, return the priority of the root logger.
			--| Does not use recursion to speed up the search
		local
			next: L4E_LOGGER
		do
			from
				next := Current
				Result := next.cat_priority
			until
				Result /= Void
			loop	
				-- check internal priority
				next := next.parent
				Result := next.cat_priority
			end
		end
	
	parent: L4E_LOGGER
			-- The parent of this logger.
	
	context: L4E_HIERARCHY
			-- The hierarchy in which this logger operates.
	
	is_additive: BOOLEAN
			-- Should appenders of this logger's parent be used?
	
	is_priority_set: BOOLEAN is
			-- Does this logger have a priority set? False if the priority
			-- will be inherited from an ancestor.
		do
			Result := cat_priority /= Void
		end
		
	appenders: DS_LINKED_LIST [L4E_APPENDER]
			-- Appenders for this logger.
	
	is_enabled_for (check_priority: L4E_PRIORITY): BOOLEAN is
			-- Is this logger enabled for 'check_priority'?
		require
			check_priority_exists: check_priority /= Void
		do
			Result := context.disabled < check_priority.level and then priority <= check_priority
		ensure
			true_if_priority_enabled: Result = (context.disabled < check_priority.level
				and priority <= check_priority)
		end
	
feature -- Status Setting
	
	set_priority (new_priority: L4E_PRIORITY) is
			-- Set the priority for this logger. Pass Void to unset the
			-- priority and use an ancestor's.
		require
			priority_exists: new_priority /= Void
		do
			cat_priority := new_priority
		end
	
	add_appender (new_appender: L4E_APPENDER) is
			-- Add 'new_appender' to the list of 
			-- appenders for this logger.
		require
			new_appender_exists: new_appender /= Void
			not_added: not appenders.has (new_appender)
		do
			appenders.force_last (new_appender)
		ensure
			appender_added: appenders.has (new_appender)
		end
	
	remove_appender (appender_name: STRING) is
			-- Remove appender with name 'appender_name'
			-- Iterates to find matching appender.
		require
			name_exists: appender_name /= Void
		local
			c: DS_LINKED_LIST_CURSOR [L4E_APPENDER]
			found: BOOLEAN
		do
			from
				c := appenders.new_cursor
				c.start
			until
				c.off or found
			loop
				if c.item.name.is_equal (appender_name) then
					found := True
					c.remove
				else
					c.forth
				end
			end
		end

	call_appenders (event: L4E_EVENT) is
			-- Send 'event' to all appenders of this 
			-- logger and recursively parents appenders if
			-- additive.
		require
			event_exists: event /= Void
		local
			c: DS_LINKED_LIST_CURSOR [L4E_APPENDER]
		do
			-- loop through all appenders
			from
				c := appenders.new_cursor
				c.start
			until
				c.off
			loop
				c.item.append (event)
				c.forth
			end
			-- if additive then recurse to parent
			if is_additive and then parent /= Void then
				parent.call_appenders (event)
			end
		end
	
	close_appenders is
			-- Close all appenders
		local
			c: DS_LINKED_LIST_CURSOR [L4E_APPENDER]
		do
			-- loop through all appenders
			from
				c := appenders.new_cursor
				c.start
			until
				c.off
			loop
				c.item.close
				c.forth
			end		
		end
	
	set_additive (flag: BOOLEAN) is
			-- Set additive status to 'flag'.
		do
			is_additive := flag
		end
		
feature -- Logging
	
	debugging (message: ANY) is
			-- Log a message object with the priority Debug.
			-- First checks if this logger is enabled 
			-- by comparing the priority of this logger 
			-- with the Debug priority. If this logger 
			-- is debug enabled, then it converts the 
			-- message object to a string by invoking 
			-- 'out'. It then proceeds to call all the 
			-- registered appenders in this logger and 
			-- also higher in the hierarchy depending on 
			-- the value of the additivity flag.
		require
			message_exists: message /= Void
		do
			if is_enabled_for (Debug_p) then
				forced_log (Debug_p, message)
			end
		end
	
	warn (message: ANY) is
			-- Log a message object with the priority Warn.
			-- First checks if this logger is enabled 
			-- by comparing the priority of this logger 
			-- with the Warn priority. If this logger 
			-- is warn enabled, then it converts the 
			-- message object to a string by invoking 
			-- 'out'. It then proceeds to call all the 
			-- registered appenders in this logger and 
			-- also higher in the hierarchy depending on 
			-- the value of the additivity flag.
		require
			message_exists: message /= Void
		do
			if is_enabled_for (Warn_p) then
				forced_log (Warn_p, message)
			end
		end
	
	info (message: ANY) is
			-- Log a message object with the priority Info.
			-- First checks if this logger is enabled 
			-- by comparing the priority of this logger 
			-- with the Info priority. If this logger 
			-- is info enabled, then it converts the 
			-- message object to a string by invoking 
			-- 'out'. It then proceeds to call all the 
			-- registered appenders in this logger and 
			-- also higher in the hierarchy depending on 
			-- the value of the additivity flag.
		require
			message_exists: message /= Void
		do
			if is_enabled_for (Info_p) then
				forced_log (Info_p, message)
			end
		end
	
	error (message: ANY) is
			-- Log a message object with the priority Error.
			-- First checks if this logger is enabled 
			-- by comparing the priority of this logger 
			-- with the Error priority. If this logger 
			-- is info enabled, then it converts the 
			-- message object to a string by invoking 
			-- 'out'. It then proceeds to call all the 
			-- registered appenders in this logger and 
			-- also higher in the hierarchy depending on 
			-- the value of the additivity flag.
		require
			message_exists: message /= Void
		do
			if is_enabled_for (Error_p) then
				forced_log (Error_p, message)
			end
		end
	
	fatal (message: ANY) is
			-- Log a message object with the priority Fatal.
			-- First checks if this logger is enabled 
			-- by comparing the priority of this logger 
			-- with the Fatal priority. If this logger 
			-- is error enabled, then it converts the 
			-- message object to a string by invoking 
			-- 'out'. It then proceeds to call all the 
			-- registered appenders in this logger and 
			-- also higher in the hierarchy depending on 
			-- the value of the additivity flag.
		require
			message_exists: message /= Void
		do
			if is_enabled_for (Fatal_p) then
				forced_log (Fatal_p, message)
			end
		end
	
	log (event_priority: L4E_PRIORITY; message: ANY) is
			-- Log a general message. 
		require
			event_priority_exists: event_priority /= Void
			message_exists: message /= Void
		do
			if is_enabled_for (event_priority) then
				forced_log (event_priority, message)
			end
		end
	
feature {NONE} -- Implementation
	
	forced_log (event_priority: L4E_PRIORITY; message: ANY) is
			-- Create new logging event and send to appenders.
		require
			priority_exists: event_priority /= Void
			message_exists: message /= Void
		local
			event: L4E_EVENT
		do
			create  event.make (Current, event_priority, message)
			call_appenders (event)
		end
	
feature {L4E_LOGGER, L4E_HIERARCHY} -- Internal
	
	cat_priority: L4E_PRIORITY
			-- The assigned priority of this logger. Void if the 
			-- categories priority should be inherited 
			-- from an ancestor.
	
	set_parent (new_parent: L4E_LOGGER) is
			-- Set the parent for this logger.
		require
			not_root: context.root /= Current
			new_parent_exists: new_parent /= Void
		do
			parent := new_parent
		end
	
feature -- Comparison

	infix "<" (other: like Current): BOOLEAN is
			-- Is current object less than `other'?
		do
			Result := name < other.name
		end

invariant
	
	name_exists: name /= Void and then not name.is_empty
	appenders_exist: appenders /= Void
	
end -- class L4E_LOGGER
