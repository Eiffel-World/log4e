indexing
	description: "Logging appender that writes to standard output."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."
	
class L4E_STDOUT_APPENDER
	
inherit
	
	L4E_APPENDER

create
	
	make

feature -- Basic Operations
	
	close is
			-- Release any resources for this appender.
		do
			is_open := False
		end
	
	do_append (event: L4E_EVENT) is
			-- Log event on this appender.
		do
			io.put_string (layout.format (event))
		end

feature -- Removal

	dispose is
			-- Close this appender when garbage collected. Perform
			-- minimal operations to release resources. Do not call
			-- other object as they may have been garbage collected.
		do
			is_open := False
		end
	
end -- class L4E_STDOUT_APPENDER
