indexing
	description: "Log4E compile all test class"
	author:     "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright:  "Copyright (c) 2002, Glenn Maughan"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

class LOG4E_ALL

creation

	make
	
feature 

	make is
			-- Do nothing
		do
		end


feature -- References

	h: L4E_HIERARCHY
	l1: L4E_SHARED_HIERARCHY
	l2: L4E_ROLLING_FILE_APPENDER
	l3: L4E_STDERR_APPENDER
	l4: L4E_STDOUT_APPENDER
	l5: L4E_CALENDAR_ROLLING_APPENDER
	l9: L4E_SOCKET_APPENDER
	l10: L4E_NT_EVENT_LOG_APPENDER
	l11: L4E_XML_CONFIG_PARSER
	l12: L4E_PRIORITY_MATCH_FILTER
	l13: L4E_PRIORITY_RANGE_FILTER
	l14: L4E_STRING_MATCH_FILTER
	l15: L4E_DATE_TIME_LAYOUT
	l16: L4E_PATTERN_LAYOUT
	l17: L4E_TIME_LAYOUT
	
	l18: L4E_EXTERNALLY_ROLLED_FILE_APPENDER
	l19: L4E_ROLL_LISTEN_THREAD
	l20: L4E_ROLL_SERVER_SOCKET
	l21: L4E_SYSLOG_APPENDER

end -- class LOG4E_ALL
