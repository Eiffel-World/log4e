indexing
	description: "Server socket that passes incoming connections to a L4E_SERVING_SOCKET to handle"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class L4E_ROLL_SERVER_SOCKET

inherit

	TCP_SERVER_SOCKET
		rename
			make as socket_make
		export
			{NONE} socket_make
		redefine
			multiplex_read_callback
		end

	SOCKET_MULTIPLEXER_SINGLETON
		export
			{NONE} all
		end

	L4E_SHARED_LOG_LOG
		export
			{NONE} all
		end
		
creation

    make

feature -- Initialisation

	make (port, backlog: INTEGER; notify_appender: L4E_EXTERNALLY_ROLLED_FILE_APPENDER) is
			-- Create server socket that will notify 'notify_appender'
		require
			notify_appender_exists: notify_appender /= Void
		do
			appender := notify_appender
			socket_make (port, backlog)
		end
		
feature

	multiplex_read_callback is
			-- we got a new client. Register the socket that talks to this client as a
			-- managed socket so that a select can work on it too
		local
			socket : TCP_SOCKET
		do
			socket := wait_for_new_connection
			if socket /= Void then
				appender.rollover
				socket.close
			else
				internal_log.error ("Externally rolling server socket error: " + socket_multiplexer.last_socket_error_code.out + ","
					+ socket_multiplexer.last_extended_socket_error_code.out + " read_bytes=" 
					+ socket_multiplexer.managed_read_count.out)
			end
		end

feature {NONE} -- Implementation

	appender: L4E_EXTERNALLY_ROLLED_FILE_APPENDER
	
end -- class L4E_ROLL_SERVER_SOCKET

