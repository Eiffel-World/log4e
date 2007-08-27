indexing
	description: "Logging logger."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Patrick Ruckstuhl <patrick@tario.org>"
	copyright: "Copyright (c) 2007 Patrick Ruckstuhl"
	license: "Eiffel Forum License v1 (see forum.txt)."

class
	L4E_LOGGER

inherit
	L4E_LOGGER_COMMON
		redefine
			make,
			add_appender, remove_appender,
			call_appenders, close_appenders
		end

creation
	make

feature  {L4E_LOGGER_FACTORY} -- Creation 

	make (hierarchy: L4E_HIERARCHY; cat_name: STRING) is
			-- Create new logger with 'cat_name'
		do
			create lock.make
			lock.lock
			Precursor (hierarchy, cat_name)
			lock.unlock
		end

feature -- Basic operatino

	add_appender (new_appender: L4E_APPENDER) is
			-- Add new_appender.
		do
			lock.lock
			Precursor (new_appender)
			lock.unlock
		end
	
	remove_appender (appender_name: STRING) is
			-- Remove appender with appender_name.
		do
			lock.lock
			Precursor (appender_name) 
			lock.unlock
		end

	call_appenders (event: L4E_EVENT) is
			-- Call the appenders.
		do
			lock.lock
			Precursor (event)
			lock.unlock
		end
	
	close_appenders is 
			-- Close the appenders.
		do
			lock.lock
			Precursor
			lock.unlock
		end

feature {NONE} -- Implementation

	lock: MUTEX
			-- Lock for accessing the appenders.

	forced_log (event_priority: L4E_PRIORITY; message: ANY) is
			-- Create new logging event and send to appenders.
		local
			event: L4E_EVENT
		do
			create  event.make (Current, event_priority, message)
			call_appenders (event)
		end

invariant
	lock_not_void: lock /= Void
end
