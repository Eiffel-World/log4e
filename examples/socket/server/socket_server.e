indexing
	description: "Example Log4E socket server."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	SOCKET_SERVER
	
inherit
		
	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end

	NETWORK_SERVER
		rename
			make as server_make
		export
			{NONE} server_make
		redefine
			received
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
				server_make (port)
				execute
			end	
		rescue
			cleanup
		end

feature -- Status report

	port: INTEGER
			-- Listen port
	
feature {NONE} -- Implementation

	argument_error: BOOLEAN
			-- Did an error occur parsing arguments?

	parse_arguments is
			-- Parse the command line arguments and store appropriate settings
		do
			if Arguments.argument_count < 1 then
				argument_error := True
			else
				-- parse port
				if Arguments.argument(1).is_integer then
					port := Arguments.argument(1).to_integer
				else
					argument_error := True
				end
			end
		end

	print_usage is
			-- Display usage information
		do
			print ("Usage: socket_server <port-number>%N")
		end
	
	received: L4E_STORABLE_EVENT
			-- Logging event
			
	process_message is
			-- Process 'received'
		do
			print ("Event:%N")
			print ("%TMessage: " + received.message + "%N")
			print ("%TLogger: " + received.logger_name + "%N")
			print ("%TTimestamp: " + received.time_stamp + "%N")
			print ("%TPriority: " + received.priority + "%N")
			print ("%TFormatted: " + received.formatted_message + "%N")
			print ("%N")
		end

end -- class SOCKET_SERVER
