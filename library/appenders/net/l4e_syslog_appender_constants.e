indexing
	description: "Constants defining syslog facilities."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_SYSLOG_APPENDER_CONSTANTS

obsolete 

	"This class is not yet fully functional"

feature
	
	Syslog_port: INTEGER is 514
			-- Standard syslog UDP port.

	Log_kern: INTEGER is 0
			-- Kernel messages
			
	Log_user: INTEGER is 8
			-- Random user-level messages
			
	Log_mail: INTEGER is 16
			-- Mail system
			
	Log_daemon: INTEGER is 24
			-- System daemons
			
	Log_auth: INTEGER is 32
			-- Security/authorization messages
			
	Log_syslog: INTEGER is 40
			-- Messages generated internally by syslogd
			
	Log_lpr: INTEGER is 48
			-- Line printer subsystem
			
	Log_news: INTEGER is 56
			-- Network news subsystem
			
	Log_uucp: INTEGER is 64
			-- UUCP subsystem
	
	Log_cron: INTEGER is 72
			-- Clock daemon
			
	Log_authpriv: INTEGER is 80
			-- Security/authorization messages (private)
			
	Log_ftp: INTEGER is 88
			-- FTP daemon
			
	Log_local0: INTEGER is 96
			-- Local use
			
	Log_local1: INTEGER is 104
			-- Local use
			
	Log_local2: INTEGER is 112
			-- Local use
			
	Log_local3: INTEGER is 120
			-- Local use
			
	Log_local4: INTEGER is 128
			-- Local use
			
	Log_local5: INTEGER is 136
			-- Local use
			
	Log_local6: INTEGER is 144
			-- Local use
			
	Log_local7: INTEGER is 152
			-- Local use

	is_valid_facility (facility: INTEGER): BOOLEAN is
			-- Is 'facility' a valid syslog facility?
		do
			Result := facility = Log_kern
				or facility = Log_user
				or facility = Log_mail
				or facility = Log_daemon
				or facility = Log_auth
				or facility = Log_syslog
				or facility = Log_lpr
				or facility = Log_news
				or facility = Log_uucp
				or facility = Log_cron
				or facility = Log_authpriv
				or facility = Log_ftp
				or facility = Log_local0
				or facility = Log_local1
				or facility = Log_local2
				or facility = Log_local3
				or facility = Log_local4
				or facility = Log_local5
				or facility = Log_local6
				or facility = Log_local7
		end
		
end -- class L4E_SYSLOG_APPENDER_CONSTANTS
