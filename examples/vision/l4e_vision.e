indexing
	description: "Log4E Vision application"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_VISION

inherit
	EV_APPLICATION
	
	MEMORY
		export
			{NONE} all
		undefine
			default_create, copy
		end
		
create
	make 

feature {NONE} -- Initialization

	make is
			-- Launch the application.
		do
			default_create
			create main_window
			main_window.show
			post_launch_actions.extend (agent initialise_server)
			launch
			shutdown_server
		end

feature {NONE} -- Implementation

	main_window: L4E_VISION_MAIN_WINDOW
			-- Main window.
	
	server_socket: NETWORK_STREAM_SOCKET
			-- Server socket
	
	poller: MEDIUM_POLLER
			-- 
	initialise_server is
			-- Initialise socket server
		local
			handler: L4E_SOCKET_EVENT_HANDLER
		do
			create server_socket.make_server_by_port (9000)
			create poller.make
			poller.set_ignore_write
			create handler.make (server_socket, agent accept_connection (?))
			poller.put_read_command (handler)
			server_socket.listen (5)
			idle_actions.extend (agent poll)
		end
	
	poll is
			-- Check all mediums for events
		do
			poller.execute (15, 100)
			full_collect
		end
		
	accept_connection (socket: NETWORK_STREAM_SOCKET) is
			-- Accept a new connection on 'socket' and enable read events on the 
			-- new socket.
		require
			socket_not_void: socket /= Void
			socket_valid: socket.is_readable
		local
			new_socket: NETWORK_STREAM_SOCKET
			handler: L4E_SOCKET_EVENT_HANDLER
		do
			socket.accept
			new_socket := socket.accepted
			create handler.make (new_socket, agent process_log_event (?))
			poller.put_read_command (handler)
		end
		
	process_log_event (socket: NETWORK_STREAM_SOCKET) is
			-- Read a log event from 'socket' and process it. Close the
			-- socket after reading.
		require
			socket_not_void: socket /= Void
			socket_valid: socket.is_readable
		local
			event: L4E_STORABLE_EVENT
		do
			event ?= socket.retrieved
			check
				event_valid_type: event /= Void
			end
			poller.remove_associated_read_command (socket)
			socket.close
			main_window.process_log_event (event)
		end
		
	shutdown_server is
			-- Close server sockets
		do
			server_socket.close
		end
		
end -- class L4E_VISION
