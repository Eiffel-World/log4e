indexing
	description: "Log4E NT event log example"
	author:     "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright:  "Copyright (c) 2002, Glenn Maughan"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

class NT_EVENT_LOG

inherit

	L4E_PRIORITY_CONSTANTS
		export
			{NONE} all
		end

creation

	make
	
feature 

	make is
			-- Configure loggers and write events
		do
			configure_logger
			write_log_events
		end

	h: L4E_HIERARCHY
			-- Logging hierarchy

	configure_logger is
		local
			logger: L4E_LOGGER
			nt_appender: L4E_NT_EVENT_LOG_APPENDER
		do
			-- create hierarchy with a default logging level of Debug
			create h.make (Debug_p)
			
			-- attach an NT event log appender to the root logger
			create nt_appender.make ("Log4eExample")
			h.root.add_appender (nt_appender)
		end
	
	write_log_events is
			-- Write a series of events to the loggers
		do
			-- log events of different priority to logger "a"
			h.logger ("main").debugging ("This is an debug message")
			h.logger ("main").info ("This is an informational message")
			h.logger ("main").warn ("This is a warning message")
			h.logger ("main").error ("This is an error message")
			h.logger ("main").fatal ("This is a fatal message")

			-- close all appenders in the hierarchy
			h.close_all
		end
		
end -- class NT_EVENT_LOG
