indexing
	description: "Internal logger used by the logging classes."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2001 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."
	
class L4E_LOG
	
inherit

	KL_SHARED_STANDARD_FILES
	
feature -- Status Report
	
	quiet_mode: BOOLEAN
			-- Quiet mode? Quiet mode will suppress all logging.
	
	stderr_mode: BOOLEAN 
			-- Is stderr used to log messages? Otherwise 
			-- stdout is used.
	
feature -- Status Setting
	
	enable_quite_mode is
			-- Enable quiet mode.
		do
			quiet_mode := True
		end
	
	disable_quiet_mode is
			-- Disable quiet mode.
		do
			quiet_mode := False
		end
	
	set_stderr_logging is
			-- Use stderr for logging
		do
			stderr_mode := True
		end
	
	set_stdout_logging is
			-- Use stdout for logging
		do
			stderr_mode := False
		end
	
feature -- Logging
	
	error (message: STRING) is
			-- Log 'message' as an error
		require
			message_exists: message /= Void
		do
			if not quiet_mode then
				write (Error_prefix + message + "%N")
			end
		end
	
	warn (message: STRING) is
			-- Log 'message' as a warning
		require
			message_exists: message /= Void
		do
			if not quiet_mode then
				write (Warning_prefix + message + "%N")
			end
		end
	
feature {NONE} -- Implementation
	
	Warning_prefix: STRING is "log4e WARN "
	Error_prefix: STRING is "log4e ERROR "

	write (message: STRING) is
			-- Write 'message' on stdout or stderr 
			-- depending on 'stderr_mode'.
		require
			message_exists: message /= Void
		do
			if stderr_mode then			
				std.error.put_string (message)
			else
				std.output.put_string (message)
			end
		end	
	
end -- class L4E_LOG
