indexing
	description: "Globally accessible internal logger used by the logging classes."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."
	
class L4E_SHARED_LOG_LOG
	
feature {NONE} -- Internal use only
	
	internal_log: L4E_LOG is
			-- Shared internal logger
		once
			create Result
		end
			
end -- class L4E_SHARED_LOG_LOG
