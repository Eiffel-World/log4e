indexing
	description: "Logging appender that writes to an NT event log."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."
	
class L4E_NT_EVENT_LOG_APPENDER
	
inherit
	
	L4E_APPENDER
		rename
			make as appender_make
		end
	
	L4E_PRIORITY_CONSTANTS
		export
			{NONE} all
		end

	KL_SHARED_EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end
		
creation
	
	make
	
feature -- Initialisation

	make (new_name: STRING) is
			-- Create new NT event log appender and connect to
			-- event source.
			-- NOTE: A registry key will be created for the event source under
			-- HKEY_LOCAL_MACHINE\System\CurrentControlSet\Services\EventLog\Application\
			-- with 'name'. 
		require
			name_exists: new_name /= Void and then not new_name.is_empty
		do
			appender_make (new_name)
			add_event_source
			connect_to_event_source
		end
		
feature -- Basic Operations
		
	close is
			-- Release any resources for this appender.
		local
			deregister_result: INTEGER
		do
			if is_open then
				deregister_result := c_deregister_event_source (source_handle)
				if deregister_result = 0 then
					internal_log.error ("Failed to close NT event log source " + name)
				else
					is_open := False		
				end
			end
		end
	
	do_append (event: L4E_EVENT) is
			-- Log event on this appender.
		local
			return_result: INTEGER
			messages: ARRAY [POINTER]
			c_str: ANY
			c_messages:ANY
		do
			c_str := event.rendered_message.to_c
			create messages.make (0, 0)
			messages.put ($c_str, 0)
			c_messages := messages.to_c

			return_result := c_report_event (
				source_handle, 								-- handle to log source
				map_priority_to_type (event.priority), 		-- event type
				map_priority_to_category (event.priority),	-- event category
				c_Log4e_nt_message, 						-- event ID
				default_pointer, 							-- user SID
				1, 											-- num format strings
				0,											-- raw data size 
				$c_messages, 								-- format string array
				default_pointer)							-- raw data buffer
			if return_result = 0 then
				internal_log.error ("Failed to report event to NT event log source " + name)
			end
		end
	
feature {NONE} -- Implementation
	
	source_handle: POINTER
			-- Handle for event source
	
	add_event_source is
			-- Create registry keys for this NT event source. Use 'name' as the
			-- name of the source.
		local
			parent_key, key: POINTER
			disposition, key_result, types, count: INTEGER
			subkey, message_file: STRING
			c_subkey, c_message_file: ANY
		do
			-- construct key
			parent_key := c_Hkey_local_machine
			subkey := clone (Event_source_subkey)
			subkey.append (name)
			c_subkey := subkey.to_c
			
			-- create key
			key_result := c_reg_create_key_ex (parent_key, $c_subkey, 0, default_pointer, 
				c_Reg_option_non_volatile, c_Key_all_access, default_pointer, $key, $disposition)
			if key_result = c_Error_success then
				-- if key was created (not opened) then set its values			
				if disposition = c_Reg_created_new_key then
				
					-- add the message file name of the EventMessageFile subkey
					message_file := Execution_environment.interpreted_string ("NTEventLogAppender.dll")
					c_message_file := message_file.to_c
					subkey := "EventMessageFile"
					c_subkey := subkey.to_c
					key_result := c_reg_set_value_ex (key, $c_subkey, 0, c_Reg_expand_sz,
						$c_message_file, message_file.count + 1)
					if key_result /= c_Error_success then
						internal_log.error ("Failed to add ErrorMessageFile subkey to NT event log registry key for " + name)
					end	
					
					-- set the TypesSupported subkey
					subkey :="TypesSupported"
					c_subkey := subkey.to_c
					types := c_Eventlog_error_type + c_Eventlog_warning_type + c_Eventlog_information_type
					key_result := c_reg_set_value_ex (key, $c_subkey, 0, c_Reg_dword, $types, 4) -- 4 = sizeof (DWORD)
					if key_result /= c_Error_success then
						internal_log.error ("Failed to add TypesSupported subkey to NT event log registry key for " + name)
					end	
					
					-- add the CategoryMessageFile subkey
					subkey := "CategoryMessageFile"
					c_subkey := subkey.to_c
					key_result := c_reg_set_value_ex (key, $c_subkey, 0, c_Reg_expand_sz,
						$c_message_file, message_file.count + 1)
					if key_result /= c_Error_success then
						internal_log.error ("Failed to add CategoryMessagFile subkey to NT event log registry key for " + name)
					end	

					-- set the CategoryCount subkey
					subkey := "CategoryCount"
					c_subkey := subkey.to_c
					count := 5
					key_result := c_reg_set_value_ex (key, $c_subkey, 0, c_Reg_dword, $count, 4) -- 4 = sizeof (DWORD)
					if key_result /= c_Error_success then
						internal_log.error ("Failed to add CategoryCount subkey to NT event log registry key for " + name)
					end	
				end
				-- close the key
				key_result := c_reg_close_key (key)
				if key_result /= c_Error_success then
					internal_log.error ("Failed to close NT event source registry key for " + name)
				end
			else
				internal_log.error ("Failed to create/open NT event source registry key for " + name)
			end
		end
		
	connect_to_event_source is
			-- Connect to the default event source
		local
			c_name: ANY
		do
			c_name := name.to_c
			source_handle := c_register_event_source (default_pointer, $c_name)
			if source_handle = default_pointer then
				internal_log.error ("Failed to connect to NT event log source " + name)
			end
		ensure
			source_handle_set: source_handle /= default_pointer
		end
	
	map_priority_to_type (priority: L4E_PRIORITY): INTEGER is
			-- Map 'priority' to NT event log type code.
		require
			priority_exists: priority /= Void
		do
			inspect priority.level
			when Fatal_int then
				Result := c_Eventlog_error_type
			when Error_int then
				Result := c_Eventlog_error_type
			when Warn_int then
				Result := c_Eventlog_warning_type
			when Info_int then
				Result := c_Eventlog_information_type
			when Debug_int then
				Result := c_Eventlog_information_type
			else
				Result := c_Eventlog_information_type
			end
		end
		
	map_priority_to_category (priority: L4E_PRIORITY): INTEGER is
			-- Map 'priority' to NT event log category code.
		require
			priority_exists: priority /= Void
		do
			inspect priority.level
			when Fatal_int then
				Result := c_Log4e_nt_fatal
			when Error_int then
				Result := c_Log4e_nt_error
			when Warn_int then
				Result := c_Log4e_nt_warn
			when Info_int then
				Result := c_Log4e_nt_info
			when Debug_int then
				Result := c_Log4e_nt_debug
			else
				Result := c_Log4e_nt_debug
			end
		end

feature -- Removal

	dispose is
			-- Close this appender when garbage collected. Perform
			-- minimal operations to release resources. Do not call
			-- other object as they may have been garbage collected.
		do
		end
		
feature {NONE} -- External routines

	c_reg_create_key_ex (parent_key: POINTER; key_name: POINTER; res: INTEGER; clas: POINTER; opt, sam: INTEGER; 
			sec, resu, dis: POINTER): INTEGER is
		external
			"[
				C macro signature (HKEY, LPCTSTR, DWORD, LPTSTR, DWORD, REGSAM, LPSECURITY_ATTRIBUTES, PHKEY, LPDWORD): EIF_INTEGER 
				use <windows.h>
			 ]"
		alias
			"RegCreateKeyEx"
		end
	
	c_reg_close_key (hkey: POINTER): INTEGER is
			-- Create the specified registry key. If the key already exists, then open it. 
		external
			"[
				C macro signature (HKEY): EIF_INTEGER use <windows.h>
			 ]"
		alias
			"RegCloseKey"
		end	
		
	c_reg_set_value_ex (key, keyname: POINTER; res, type: INTEGER; data: POINTER; siz: INTEGER): INTEGER is
		external
			"[
				C macro signature (HKEY, LPCTSTR, DWORD, DWORD, BYTE *, DWORD): EIF_INTEGER use <windows.h>
			 ]"
		alias
			"RegSetValueEx"
		end

	c_register_event_source (server_name, source_name: POINTER): POINTER is
			-- Connect to NT event source with server name specified by
			-- the 'server_name' urn and source name identified by 
			-- 'source_name'.
		external
			"[
				C macro signature (LPCTSTR, LPCTSTR): EIF_POINTER use <windows.h>
			 ]"
		alias
			"RegisterEventSource"
		end
	
	c_deregister_event_source (event_log: POINTER): INTEGER is
			-- Closes write handle to specified event log.
		external
			"[
				C macro signature (HANDLE): EIF_INTEGER use <windows.h>
			 ]"
		alias
			"DeregisterEventSource"
		end
		
	c_report_event (event_log: POINTER; type, category, event_id: INTEGER; user_id: POINTER; 
		num_strings, data_size: INTEGER; strings: POINTER; raw_data: POINTER): INTEGER is
		external
			"[
				C macro signature (HANDLE, WORD, WORD, DWORD, PSID, WORD, DWORD, LPCTSTR*, LPVOID): EIF_INTEGER 
				use <windows.h>
			 ]"
		alias
			"ReportEvent"
		end
		
	c_get_last_error: INTEGER is
		external
			"[
				C macro signature (): EIF_INTEGER use <windows.h>
			 ]"
		alias
			"GetLastError"
		end
		
	c_Eventlog_error_type: INTEGER is
		external
			"C macro use <windows.h>"
		alias
			"EVENTLOG_ERROR_TYPE"
		end

	c_Eventlog_warning_type: INTEGER is
		external
			"C macro use <windows.h>"
		alias
			"EVENTLOG_WARNING_TYPE"
		end	
		
	c_Eventlog_information_type: INTEGER is
		external
			"C macro use <windows.h>"
		alias
			"EVENTLOG_INFORMATION_TYPE"
		end
	
	c_Reg_option_non_volatile: INTEGER is
		external
			"C macro use <windows.h>"
		alias
			"REG_OPTION_NON_VOLATILE"
		end
		
	c_Hkey_local_machine: POINTER is
		external
			"C macro use <windows.h>"
		alias
			"HKEY_LOCAL_MACHINE"
		end
		
	c_Key_all_access: INTEGER is
		external
			"C macro use <windows.h>"
		alias
			"KEY_ALL_ACCESS"
		end	
		
	c_Error_success: INTEGER is
		external
			"C macro use <windows.h>"
		alias
			"ERROR_SUCCESS"
		end
	
	c_Reg_created_new_key: INTEGER is
		external
			"C macro use <windows.h>"
		alias
			"REG_CREATED_NEW_KEY"
		end
	
	c_Reg_expand_sz: INTEGER is
		external
			"C macro use <windows.h>"
		alias
			"REG_EXPAND_SZ"
		end
		
	c_Reg_dword: INTEGER is
		external
			"C macro use <windows.h>"
		alias
			"REG_DWORD"
		end

	c_Log4e_nt_fatal: INTEGER is
		external
			"C macro use %"EventLogCategories.h%""
		alias
			"LOG4E_NT_FATAL"
		end	
		
	c_Log4e_nt_error: INTEGER is
		external
			"C macro use %"EventLogCategories.h%""
		alias
			"LOG4E_NT_ERROR"
		end
		
	c_Log4e_nt_warn: INTEGER is
		external
			"C macro use %"EventLogCategories.h%""
		alias
			"LOG4E_NT_WARN"
		end
		
	c_Log4e_nt_info: INTEGER is
		external
			"C macro use %"EventLogCategories.h%""
		alias
			"LOG4E_NT_INFO"
		end
		
	c_Log4e_nt_debug: INTEGER is
		external
			"C macro use %"EventLogCategories.h%""
		alias
			"LOG4E_NT_DEBUG"
		end
		
	c_Log4e_nt_message: INTEGER is
		external
			"C macro use %"EventLogCategories.h%""
		alias
			"LOG4E_NT_MESSAGE"
		end
		
	Event_source_subkey: STRING is "SYSTEM\CurrentControlSet\Services\EventLog\Application\"
	
end -- class L4E_NT_EVENT_LOG_APPENDER
