indexing
	description: "Logging priorities."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."
	
class L4E_PRIORITY_CONSTANTS
	
feature -- Constants
	
	Fatal_int: INTEGER is 50000
	Error_int: INTEGER is 40000
	Warn_int: INTEGER is 30000
	Info_int: INTEGER is 20000
	Debug_int: INTEGER is 10000
	
	Fatal_p: L4E_PRIORITY is
			-- Fatal priority designates very severe error events 
			-- that will presumably lead the application to abort.
		once
			create Result.make (Fatal_int, "FATAL")
		end
		
	Error_p: L4E_PRIORITY is
			-- Error priority designates error events.
		once
			create Result.make (Error_int, "ERROR")
		end	
		
	Warn_p: L4E_PRIORITY is
			-- Warn priority designates potentially 
			-- harmful situations.
		once
			create Result.make (Warn_int, "WARN")
		end
	
	Info_p: L4E_PRIORITY is
			-- Info priority designates informational 
			-- messages that highlight the progress of 
			-- the application at coarse-grained level.
		once
			create Result.make (Info_int, "INFO")
		end
	
	Debug_p: L4E_PRIORITY is
			-- Debug priority designates fine-grained 
			-- informational events that are most useful 
			-- to debug an application.
		once
			create Result.make (Debug_int, "DEBUG")
		end
	
end -- class L4E_PRIORITY_CONSTANTS

