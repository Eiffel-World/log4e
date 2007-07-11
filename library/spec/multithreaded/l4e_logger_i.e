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
			make
		end

creation
	make

feature {NONE} -- Implementation

	make (hierarchy: L4E_HIERARCHY; cat_name: STRING) is
			-- Create new logger with 'cat_name'
		do
			Precursor (hierarchy, cat_name)
			create lock.make
		end

feature {NONE} -- Implementation

	lock: MUTEX
			-- Lock for calling the appenders.

	forced_log (event_priority: L4E_PRIORITY; message: ANY) is
			-- Create new logging event and send to appenders.
		local
			event: L4E_EVENT
		do
			lock.lock
			create  event.make (Current, event_priority, message)
			call_appenders (event)
			lock.unlock
		end

invariant
	lock_not_void: lock /= Void
end
