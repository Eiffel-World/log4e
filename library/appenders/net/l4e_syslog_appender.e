indexing
	description: "Logging appender that writes to Unix syslog via a UDP socket."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_SYSLOG_APPENDER

obsolete 

	"This class is not yet fully functional"

inherit
	
	L4E_APPENDER
		rename
			make as appender_make
		end

	L4E_SYSLOG_APPENDER_CONSTANTS
		export
			{NONE} all
			{ANY} is_valid_facility
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
	
	make, make_on_port

feature -- Initialization

	make (new_name, host: STRING; facility: INTEGER) is
			-- Initialise syslog appender that will send events to
			-- the syslod daemon listening at 'host'.
		require
			name_exists: new_name /= Void
			host_exists: host /= Void
			valid_facility: is_valid_facility (facility)
		do
			make_on_port (new_name, host, Syslog_port, facility)
		end

	make_on_port (new_name, host: STRING; port, facility: INTEGER) is
			-- Initialise syslog appender that will send events to
			-- the syslod daemon listening at 'host on UDP 'port'.
		require
			name_exists: new_name /= Void
			host_exists: host /= Void
			sensible_port: port > 0
			valid_facility: is_valid_facility (facility)
		do
			create socket.make_connecting_to_port (host, port)
			if socket.last_error_code /= Sock_err_no_error then
				internal_log.error ("Syslog socket connect error: " + socket.last_error_code.out)
				internal_log.error ("    Socket error code: " + socket.last_socket_error_code.out)
				internal_log.error ("    Extended socket error code: " + socket.last_extended_socket_error_code.out)

			end
			log_facility := facility
			appender_make (new_name)
		end	
		
feature -- Status Setting
	
	close is
			-- Release any resources for this appender.
		do
			if not is_open then
				socket.close
				is_open := False
			end
		end	

feature {NONE} -- Implementation

	do_append (event: L4E_EVENT) is
			-- Append 'event' to this appender
		do
			socket.send_string (event.rendered_message)
			if socket.last_error_code /= Sock_err_no_error then
				internal_log.error ("Syslog socket write error: " + socket.last_error_code.out)
				internal_log.error ("    Socket error code: " + socket.last_socket_error_code.out)
				internal_log.error ("    Extended socket error code: " + socket.last_extended_socket_error_code.out)

			end
		end	

	socket: UDP_SOCKET
			-- UDP socket for sending syslog datagrams
	
	log_facility: INTEGER
			-- Syslog facility to log messages with
		
feature -- Removal

	dispose is
			-- Close this appender when garbage collected. Perform
			-- minimal operations to release resources. Do not call
			-- other object as they may have been garbage collected.
		do
			is_open := False
		end
		
end -- class L4E_SYSLOG_APPENDER
