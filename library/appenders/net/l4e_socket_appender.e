indexing
	description: "Logging appender that writes to a TCP socket."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_SOCKET_APPENDER

inherit
	
	L4E_APPENDER
		rename
			make as appender_make
		end

	L4E_SHARED_LOG_LOG
		export
			{NONE} all
		end
	
	NETWORK_CLIENT
		rename
			make as client_make
		end
		
	EXCEPTIONS
		export
			{NONE} all
		end
creation
	
	make

feature -- Initialization

	make (new_name, new_host: STRING; new_port: INTEGER) is
			-- Initialise socket appender that will send events to
			-- the TCP socket server listening at 'host' on 'port'.
		require
			name_exists: new_name /= Void
			host_exists: new_host /= Void
			sensible_port: new_port > 0
		do
			appender_make (new_name)
			host := new_host
			port := new_port
		end	
		
feature -- Status Setting
	
	close is
			-- Release any resources for this appender.
		do
			if not is_open then
				is_open := False
			end
		end	

feature {NONE} -- Implementation

	port: INTEGER
			-- Connection port
			
	host: STRING
			-- Connection host
			
	do_append (event: L4E_EVENT) is
			-- Append 'event' to this appender
		local
			retried: BOOLEAN
			storable: L4E_STORABLE_EVENT
		do
			if not retried then
				-- connect
				client_make (port, host)
				if not socket_ok then
					internal_log.error ("Failed to connect socket appender: " + error)
					is_open := False
				end
				-- send event
				storable := event.as_storable
				storable.set_formatted_message (layout.format (event))
				send (storable)
			else
				is_open := False
			end
		rescue
			if not assertion_violation then
				retried := True
				internal_log.error ("Failed to send event on socket appender: " + meaning (exception))
				cleanup
				retry
			end
		end	

feature -- Removal

	dispose is
			-- Close this appender when garbage collected. Perform
			-- minimal operations to release resources. Do not call
			-- other object as they may have been garbage collected.
		do
			is_open := False
		end
		
end -- class L4E_SOCKET_APPENDER
