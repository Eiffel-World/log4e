indexing
	description: "Logging appender that writes to standard a file that is rolled when it receives a message via a socket."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."
	
class L4E_EXTERNALLY_ROLLED_FILE_APPENDER
	
inherit
	
	L4E_FILE_APPENDER
		rename
			make as file_appender_make
		export
			{NONE} file_appender_make
		redefine
			do_append, close
		end
		
	THREAD_CONTROL
		export
			{NONE} all
		end

	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end	
		
creation
	
	make
	
feature -- Initialisation
	
	make (new_name: STRING; port, number_of_backups: INTEGER; appending: BOOLEAN) is
			-- Create a new file appender on the file 
			-- with 'new_name'. Roll the log over when the message "RollOver" is received on
			-- a socket listening on 'port'. Keep a maximum of 'number_of_backups' backup files.
			-- Append to an existing log file if 'appending'.
		require
			name_exists: new_name /= Void
			name_not_empty: not new_name.is_empty
			sensible_port: port >= 1
			positive_number_of_backups: number_of_backups >= 0
		do
			max_number_of_backups := number_of_backups
			file_appender_make (new_name, appending)
			create listen_thread.make (Current, port)
			create stream_mutex
			listen_thread.launch
		ensure
			log_file_open: stream.is_open_write
		end
		
feature -- Basic Operations
		
	do_append (event: L4E_EVENT) is
			-- Log event on this appender.
		do
			debug ("roll_thread")
				print("L%N")
			end
			stream_mutex.lock
			stream.put_string (layout.format (event))
			stream.flush
			stream_mutex.unlock
		end

	close is
			-- Release any resources for this appender.
		do
			stream_mutex.lock
			listen_thread.stop
			listen_thread.join
			stream_mutex.unlock
			Precursor
		end
		
feature {L4E_ROLL_LISTEN_THREAD, L4E_ROLL_SERVER_SOCKET} -- Implementation

	listen_thread: L4E_ROLL_LISTEN_THREAD
			-- Thread listening for rollover requests
			
	stream_mutex: MUTEX
			-- Thread mutex used to provide synchronous access
			-- to the output stream.
			
	max_number_of_backups: INTEGER
			-- The number of backup files to keep. If 
			-- zero then no backups will be made.
	
	rollover is
			-- Rollover the current file by renaming (if 
			-- backups are required) or deleting. Open a 
			-- new file with the same name.
		local
			i: INTEGER
			file: PLAIN_TEXT_FILE
		do
			debug ("roll_thread")
				print("R%N")
			end
			stream_mutex.lock
  			-- do we need to make a backup
  			if max_number_of_backups > 0 then		
  				-- roll all existing backup files to 
  				-- next number
  				from
  					i := max_number_of_backups
  				until
  					i < 1
  				loop
  					create file.make (name + "." + i.out)
  					if file.exists then
  						file.change_name (name + "." + (i + 1).out)
  					end
  					i := i - 1
  				end
				
				-- remove the oldest backup if not keeping infinite number of backups
				if max_number_of_backups > 0 then
					create file.make (name + "." + (max_number_of_backups + 1).out)
	  				if file.exists then
	  					file.delete
	  				end		
				end
  				
  				-- rename current log file
  				stream.put_string ("Log rolled: " + system_clock.date_time_now.out + "%N")
  				stream.close
  				stream.change_name (name + ".1" )
				
  				-- re-open log
  				open_log
			end
			stream_mutex.unlock
		end

end -- class L4E_EXTERNALLY_ROLLED_FILE_APPENDER
