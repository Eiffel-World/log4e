indexing
	description: "Log4E socket event handler"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_SOCKET_EVENT_HANDLER
	
inherit
		
	POLL_COMMAND
		rename
			make as command_make
		export
			{NONE} command_make
		end

creation

	make

feature -- Initialization

	make (s: like active_medium; callback: like event_callback) is
			-- create new command to process socket events by calling
			-- 'callback'
		require
			s_not_void: s /= Void
			callback_not_void: callback /= Void
		do
			command_make (s)
			event_callback := callback
		end
	
feature -- Access

	event_callback: PROCEDURE [ANY, TUPLE[like active_medium]]
			-- Agent to call on an event

feature -- Basic operation

	execute (arg: ANY) is
			-- Process the new connection
		do
			event_callback.call ([active_medium])
		end

end -- class L4E_SOCKET_EVENT_HANDLER
