indexing
	description: "Log4E shared configuration example"
	author:     "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright:  "Copyright (c) 2002, Glenn Maughan"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

class LOG4E_SHARED_CONFIG

inherit

	L4E_PRIORITY_CONSTANTS
		export
			{NONE} all
		end

	L4E_FILTER_CONSTANTS
		export
			{NONE} all
		end

	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end

	L4E_SHARED_HIERARCHY	
		export
			{NONE} all
		end	
creation

	make
	
feature 

	make is
			-- Configure loggers and write events
		do
			parse_arguments
			if arguments_ok then
				configure_loggers
				write_log_events	
			else
				print_usage
			end
		end

	arguments_ok: BOOLEAN
			-- Were the command line arguments parsed correctly?
			
	config_file: STRING
			-- File name of configuration file
			
	parse_arguments is
			-- Parse and store argument values
		local
			file: KL_FILE
		do
			arguments_ok := True
			if Arguments.Argument_count /= 1 then
				arguments_ok := False
			else
				config_file := clone (Arguments.argument (1))
			end
		end
		
	print_usage is
			-- Print usage message
		do
			print ("Usage: log4e_shared_config <xmlfilename>%N")
		end
		
	configure_loggers is
		local
			config: L4E_XML_CONFIG_PARSER
		do
			-- configure the hierarchy using the specified XML file. Pass
			-- the shared log heirarchy in.
			create config.make_with_hierarchy (config_file, Log_hierarchy)
		end
	
	write_log_events is
			-- Write a series of events to the loggers
		local
			logger: L4E_LOGGER
		do
			-- log events of different priority to logger "a"
			Log_hierarchy.logger ("a").debugging ("This is an debug message")
			Log_hierarchy.logger ("a").info ("This is an informational message")
			Log_hierarchy.logger ("a").warn ("This is a warning message")
			Log_hierarchy.logger ("a").error ("This is an error message")
			Log_hierarchy.logger ("a").fatal ("This is a fatal message")
			
			-- create a new logger on the fly and log to it
			Log_hierarchy.logger ("a.b").error ("This is an error message in category a.b")
			
			-- log events to logger "b". This time hold onto the logger. Only the
			-- fatal message will appear in the logger's appender because of the priority.
			-- The fatal event should also appear in the root appender because of the
			-- additive flag.
			logger := Log_hierarchy.logger ("b")
			logger.debugging ("This is an debug message")
			logger.info ("This is an informational message")
			logger.warn ("This is a warning message")
			logger.error ("This is an error message")
			logger.fatal ("This is a fatal message")
			
			-- close all appenders in the hierarchy
			Log_hierarchy.close_all
		end
		
end -- class LOG4E_SHARED_CONFIG
