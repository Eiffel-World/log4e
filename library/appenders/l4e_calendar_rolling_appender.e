indexing
	description: "Logging appender that writes to a file and is rolled at specified calendar intervals."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_CALENDAR_ROLLING_APPENDER

inherit
	
	L4E_ROLLING_FILE_APPENDER
		rename
			make as rolling_file_appender_make
		export
			{NONE} rolling_file_appender_make
		redefine
			rollover_required
		end
	
	DT_SHARED_SYSTEM_CLOCK
		export
			{NONE} all
		end
		
creation
	
	make, make_daily, make_minutely, make_hourly
	
feature -- Initialisation
	
	make, make_daily (new_name: STRING; number_of_backups: INTEGER; appending: BOOLEAN) is
			-- Create a new file appender on the file 
			-- with 'new_name'. Roll the log over to a backup file every day.
			-- Keep a maximum of 'number_of_backups' backup files.
			-- Append to an existing log file if 'appending'.
		require
			name_exists: new_name /= Void
			name_not_empty: not new_name.is_empty
			positive_number_of_backups: number_of_backups >= 0
		do
			file_appender_make (new_name, appending)
			max_number_of_backups := number_of_backups
			rollover_period := Daily
			last_rollover := system_clock.date_time_now
		ensure
			L4E_file_open: stream.is_open_write
		end

	make_minutely (new_name: STRING; number_of_backups: INTEGER; appending: BOOLEAN) is
			-- Create a new file appender on the file 
			-- with 'new_name'. Roll the log over to a backup file every minute.
			-- Keep a maximum of 'number_of_backups' backup files.
			-- Append to an existing log file if 'appending'.
		require
			name_exists: new_name /= Void
			name_not_empty: not new_name.is_empty
			positive_number_of_backups: number_of_backups >= 0
		do
			file_appender_make (new_name, appending)
			max_number_of_backups := number_of_backups
			rollover_period := Minutely
			last_rollover := system_clock.date_time_now
		ensure
			L4E_file_open: stream.is_open_write
		end
		
	make_hourly (new_name: STRING; number_of_backups: INTEGER; appending: BOOLEAN) is
			-- Create a new file appender on the file 
			-- with 'new_name'. Roll the log over to a backup file every hour.
			-- Keep a maximum of 'number_of_backups' backup files.
			-- Append to an existing log file if 'appending'.
		require
			name_exists: new_name /= Void
			name_not_empty: not new_name.is_empty
			positive_number_of_backups: number_of_backups >= 0
		do
			file_appender_make (new_name, appending)
			max_number_of_backups := number_of_backups
			rollover_period := Hourly
			last_rollover := system_clock.date_time_now
		ensure
			L4E_file_open: stream.is_open_write
		end
feature {NONE} -- Implementation		
			
	rollover_period: INTEGER
			-- What period of rollover is required
	
	Minutely: INTEGER is unique
			-- Rollover every minute.
			
	Hourly: INTEGER is unique
			-- Rollover every hour

	Daily: INTEGER is unique
			-- Rollover at midnight every day.
			
	Weekly: INTEGER is unique
			-- Rollover every week midnight
			
	Monthly: INTEGER is unique
			-- Rollover at the end of every month
			
	Yearly: INTEGER is unique
			-- Rollover at the end of every year
			
	rollover_required: BOOLEAN is
			-- Has the current time reached the rollover date and time?
		local
			current_time: DT_DATE_TIME
			check_time: DT_DATE_TIME
		do
			current_time := system_clock.date_time_now
			check_time := clone (last_rollover)
			inspect rollover_period
			when Minutely then
				check_time.add_minutes (1)
			when Hourly then
				check_time.add_hours (1)
			when Daily then
				check_time.add_days (1)
			when Weekly then
				check_time.add_days (7)
			when Monthly then
				check_time.add_months (1)
			when Yearly then
				check_time.add_years (1)
			end
			Result := current_time >= check_time
			if Result then
				last_rollover := current_time
			end
		end

	last_rollover: DT_DATE_TIME
			-- Date and time of last check.
			
end -- class L4E_CALENDAR_ROLLING_APPENDER
