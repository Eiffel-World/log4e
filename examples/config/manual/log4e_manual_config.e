indexing
	description: "Log4E manual configuration example"
	author:     "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright:  "Copyright (c) 2002, Glenn Maughan"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

class LOG4E_MANUAL_CONFIG

inherit

	L4E_PRIORITY_CONSTANTS
		export
			{NONE} all
		end

	L4E_FILTER_CONSTANTS
		export
			{NONE} all
		end

creation

	make
	
feature 

	make is
			-- Configure loggers and write events
		do
			configure_loggers
			write_log_events
		end

	h: L4E_HIERARCHY
			-- Logging hierarchy

	configure_loggers is
		local
			logger: L4E_LOGGER
			file_appender: L4E_FILE_APPENDER
			layout: L4E_PATTERN_LAYOUT
			filter: L4E_STRING_MATCH_FILTER
		do
			-- create hierarchy with a default logging level of Debug
			create h.make (Debug_p)
			
			-- attach a file appender to the root logger
			create file_appender.make ("app.log", True)
			h.root.add_appender (file_appender)
			
			-- attach a filtered appender to the root logger
			-- The filter will reject all events that contain the string 'an'
			create file_appender.make ("app-c.log", True)
			create filter.make ("an", False)
			file_appender.add_filter (filter)
			h.root.add_appender (file_appender)
			
			-- create a pattern layout and set it on the file appender logger
			create layout.make ("&d [&-6p] &c - &m%N")
			file_appender.set_layout (layout)
			
			-- create logger "a", set its priority to Error
			logger := h.logger ("a")
			logger.set_priority (Error_p)
			
			-- create logger "b", set its priority to Fatal
			logger := h.logger ("b")
			logger.set_priority (Fatal_p)
			
			-- create another file appender for logger "b". This time use
			-- the default layout
			create file_appender.make ("app-b.log", True)
			logger.add_appender (file_appender)
		end
	
	write_log_events is
			-- Write a series of events to the loggers
		local
			logger: L4E_LOGGER
		do
			-- log events of different priority to logger "a"
			h.logger ("a").debugging ("This is an debug message")
			h.logger ("a").info ("This is an informational message")
			h.logger ("a").warn ("This is a warning message")
			h.logger ("a").error ("This is an error message")
			h.logger ("a").fatal ("This is a fatal message")
			
			-- create a new logger on the fly and log to it
			h.logger ("a.b").error ("This is an error message in category a.b")
			
			-- log events to logger "b". This time hold onto the logger. Only the
			-- fatal message will appear in the logger's appender because of the priority.
			-- The fatal event should also appear in the root appender because of the
			-- additive flag.
			logger := h.logger ("b")
			logger.debugging ("This is an debug message")
			logger.info ("This is an informational message")
			logger.warn ("This is a warning message")
			logger.error ("This is an error message")
			logger.fatal ("This is a fatal message")
			
			-- close all appenders in the hierarchy
			h.close_all
		end
		
end -- class LOG4E_MANUAL_CONFIG
