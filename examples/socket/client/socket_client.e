indexing
	description: "Example Log4E socket client."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	SOCKET_CLIENT
	
inherit
		
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

feature -- Initialization

	make is
			-- Create and initialise a new client that will write log events
			-- to a socket appender.
		do
			parse_arguments
			if argument_error then
				print_usage
			else
				initialise_logger
				write_log_messages
			end
		end

feature -- Status report

	port: INTEGER
			-- Appender connection port
	
	host: STRING
			-- Appender host
			
feature {NONE} -- Implementation

	argument_error: BOOLEAN
			-- Did an error occur parsing arguments?

	parse_arguments is
			-- Parse the command line arguments and store appropriate settings
		do
			if Arguments.argument_count < 2 then
				argument_error := True
			else
				-- get host
				host := Arguments.argument(1)
				-- parse port
				if Arguments.argument(2).is_integer then
					port := Arguments.argument(2).to_integer
					
				else
					argument_error := True
				end
			end
		end

	print_usage is
			-- Display usage information
		do
			print ("Usage: socket_client <hostname> <port-number>%R%N")
		end

	initialise_logger is
			-- Initialise the logger
		local
			logger: L4E_LOGGER
			appender: L4E_APPENDER
			layout: L4E_LAYOUT
		do
			logger := Log_hierarchy.logger ("test")
			create {L4E_SOCKET_APPENDER} appender.make ("socket", host, port)
			logger.add_appender (appender)
			create {L4E_PATTERN_LAYOUT} layout.make ("&d [&-6p] &c - &m%N")
			appender.set_layout (layout)

		end
	
	write_log_messages is
			-- Write a few messages to the log
		local
			logger, logger2, logger3, logger4: L4E_LOGGER
		do
			logger := Log_hierarchy.logger ("test")
			logger.debugging ("This is a debug message")
			logger.info ("This is an info message")
			logger.warn ("This is a warn message")
			logger.error ("This is an error message")
			logger.fatal ("This is a fatal message")
			logger2 := Log_hierarchy.logger ("test.category")
			logger2.info ("This is an info message")
			logger2.warn ("This is a warn message")
			logger2.error ("This is an error message")
			logger2.fatal ("This is a fatal message")
			logger3 := Log_hierarchy.logger ("test.category.foo")
			logger3.info ("This is an info message")
			logger3.warn ("This is a warn message")
			logger3.error ("This is an error message")
			logger3.fatal ("This is a fatal message")
			logger4 := Log_hierarchy.logger ("test.category.bar")
			logger4.info ("This is an info message")
			logger4.warn ("This is a warn message")
			logger4.error ("This is an error message")
			logger4.fatal ("This is a very long fatal message. This is a very long fatal message. This is a very long fatal message. This is a very long fatal message.%NThis is a very long fatal message. This is a very long fatal message. This is a very long fatal message. ")
		end
		
end -- class SOCKET_CLIENT
