indexing
	description: "Thread that listens on a socket for 'RollOver' message and notifies associated appender."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2001 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."
	
class
	L4E_ROLL_LISTEN_THREAD

inherit
	
	THREAD
	
	SOCKET_MULTIPLEXER_SINGLETON
		export
			{NONE} all
		end

	SOCKET_ERRORS 		
		export
			{NONE} all
		end

	L4E_SHARED_LOG_LOG
		export
			{NONE} all
		end
		
creation

	make

feature -- Initialization

	make (notify_appender: L4E_EXTERNALLY_ROLLED_FILE_APPENDER; listen_port: INTEGER) is
			-- Create a new notifier thread listening on 'listen_port'.
			-- Notify 'notify_appender' whenever the message "RollOver"
			-- is received.
		require
			notify_appender_exists: notify_appender /= Void
			listen_port_valid: listen_port >= 1
		do
			create socket.make (listen_port, 2, notify_appender)
		end

feature -- Basic operations

	execute is
			-- Listen for messages on socket
		local
			multiplexed : BOOLEAN
			error_code: INTEGER
		do
			from
				socket_multiplexer.register_managed_socket_read (socket)
			until
				error_code = sock_err_select or stop_flag
			loop
				multiplexed := socket_multiplexer.multiplex_registered (1, 0)
				debug ("roll_thread")
					print (".")
				end
				if not multiplexed then
					error_code := socket_multiplexer.last_socket_error_code
					if error_code /= 0 then
						internal_log.error ("Externally rolled listen error: " + error_code.out)
						internal_log.error ("    Socket error code: " + socket_multiplexer.last_socket_error_code.out)
						internal_log.error ("    Extended socket error code: " + socket_multiplexer.last_extended_socket_error_code.out)
					end
				end
				yield
			end

		end

	stop is
			-- Stop this thread
		do
			stop_flag := True
		end
		
feature {NONE} -- Implementation
			
	stop_flag: BOOLEAN
			-- Flag indicating whether the thread should stop
			
	socket: L4E_ROLL_SERVER_SOCKET
	
end -- class L4E_ROLL_LISTEN_THREAD
