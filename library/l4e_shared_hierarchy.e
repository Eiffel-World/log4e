indexing
	description: "Logging appender that writes to Unix syslog via a UDP socket."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

class
	L4E_SHARED_HIERARCHY

inherit
	
	L4E_PRIORITY_CONSTANTS
		export
			{NONE} all
			{ANY} is_equal, standard_is_equal
		end
		
feature -- Access

	Log_hierarchy: L4E_HIERARCHY is
			-- Shared logging hierarchy.
			-- Will have Debug logging priority by default.
			-- NOTE: No appenders will be created in this hierarchy.
			-- You will need to create and set appenders before log messages
			-- will appear.
		once
			create Result.make (Debug_p)
		end
		
feature -- Logging

	debugging (logger: STRING; message: ANY) is
			-- Log a 'message' object with the priority Debug
			-- on the named 'logger'.
			-- Will create the logger if it does not already
			-- exist.
		require
			logger_name_exists: logger /= Void
			message_exists: message /= Void
		do
			if Log_hierarchy.is_enabled_for (Debug_p) then
				Log_hierarchy.logger (logger).debugging (message)
			end
		end
	
	warn (logger: STRING; message: ANY) is
			-- Log a 'message' object with the priority Warn
			-- on the named 'logger'.
			-- Will create the logger if it does not already
			-- exist.
		require
			logger_name_exists: logger /= Void
			message_exists: message /= Void
		do
			if Log_hierarchy.is_enabled_for (Warn_p) then
				Log_hierarchy.logger (logger).warn (message)
			end
		end
	
	info (logger: STRING; message: ANY) is
			-- Log a 'message' object with the priority Info
			-- on the named 'logger'.
			-- Will create the logger if it does not already
			-- exist.
		require
			logger_name_exists: logger /= Void
			message_exists: message /= Void
		do
			if Log_hierarchy.is_enabled_for (Info_p) then
				Log_hierarchy.logger (logger).info (message)
			end
		end
	
	error (logger: STRING; message: ANY) is
			-- Log a 'message' object with the priority Error
			-- on the named 'logger'.
			-- Will create the logger if it does not already
			-- exist.
		require
			logger_name_exists: logger /= Void
			message_exists: message /= Void
		do
			if Log_hierarchy.is_enabled_for (Error_p) then
				Log_hierarchy.logger (logger).error (message)
			end
		end
	
	fatal (logger: STRING; message: ANY) is
			-- Log a 'message' object with the priority Fatal
			-- on the named 'logger'.
			-- Will create the logger if it does not already
			-- exist.
		require
			logger_name_exists: logger /= Void
			message_exists: message /= Void
		do
			if Log_hierarchy.is_enabled_for (Fatal_p) then
				Log_hierarchy.logger (logger).fatal (message)
			end
		end
	
	log (logger: STRING; event_priority: L4E_PRIORITY; message: ANY) is
			-- Log a 'message' object with the given 'event_priority' on
			-- the named 'logger'.
			-- Will create the logger if it does not already
			-- exist.
		require
			logger_name_exists: logger /= Void
			event_priority_exists: event_priority /= Void
			message_exists: message /= Void
		do
			if Log_hierarchy.is_enabled_for (event_priority) then
				Log_hierarchy.logger (logger).log (event_priority, message)
			end
		end	

end -- class L4E_SHARED_HIERARCHY
