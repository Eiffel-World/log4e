indexing
	description: "Log4E Vision main window"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."


class
	L4E_VISION_MAIN_WINDOW

inherit
	EV_TITLED_WINDOW
		redefine
			initialize,
			is_in_default_state
		end

	L4E_PRIORITY_CONSTANTS
		export
			{NONE} all
		undefine
			default_create, copy
		end
	
	KL_SHARED_FILE_SYSTEM
		export
			{NONE} all
		undefine
			default_create, copy
		end
		
create

	default_create

feature {NONE} -- Initialization

	initialize is
			-- Build the interface for this window.
		do
			Precursor {EV_TITLED_WINDOW}
			create pending_events.make
			initialise_menu
			initialise_widgets
			-- Execute `close_application' when the user clicks
			-- on the cross in the title bar.
			close_request_actions.extend (agent close_application)
			-- Set the title of the window
			set_title (Window_title)
			-- Set the initial size of the window
			set_size (Window_width, Window_height)
			-- update current filter settings
			update_current_priority_filter
			update_current_logger_filter
			update_current_message_filter
		end

	is_in_default_state: BOOLEAN is
			-- Is the window in its default state
			-- (as stated in `initialize')
		do
			Result := (width = Window_width) and then
				(height = Window_height) and then
				(title.is_equal (Window_title))
		end

feature -- Access

	main_menu: EV_MENU_BAR
			-- Menu bar
			
	event_list: EV_MULTI_COLUMN_LIST
			-- Event list
			
	detail_text: EV_TEXT
			-- Detail text
			
	priority_filter_label: EV_LABEL
			-- Current priority filter
			
	logger_filter_label: EV_LABEL
			-- Current logger filter
			
	message_filter_label: EV_LABEL
			-- Current message filter
			
	priority_filter_combo: EV_COMBO_BOX
			-- Priority filter
		
	logger_filter_text: EV_TEXT_FIELD
			-- Logger (category) filter
	
	message_filter_text: EV_TEXT_FIELD
			-- Message filter
			
	apply_button: EV_BUTTON
			-- Apply filter button
			
	pause_button: EV_BUTTON
			-- Pause button
			
	clear_button: EV_BUTTON
			-- Clear button
			
feature {NONE} -- Implementation

	close_application is
			-- Close the main window
		do
			destroy;
			(create {EV_ENVIRONMENT}).application.destroy
		end
		
feature {NONE} -- Implementation / Constants

	Window_title: STRING is "Log4E Vision"
			-- Title of the window.

	Window_width: INTEGER is 700
			-- Initial width for this window.

	Window_height: INTEGER is 350
			-- Initial height for this window.
		
	No_filter_applied_text: STRING is "No filter applied"
			-- Text to display when no filter is applied.
	
	initialise_menu is
			-- Setup menu bar
		local
			menu_item: EV_MENU_ITEM
			menu: EV_MENU
			sep: EV_MENU_SEPARATOR
		do
			create main_menu
			set_menu_bar (main_menu)
			
			-- file menu
			create menu.make_with_text ("&File")
			create menu_item.make_with_text_and_action ("&Export...", agent export_events)
			menu.extend (menu_item)
			create sep
			menu.extend (sep)
			create menu_item.make_with_text_and_action ("E&xit", agent close_application)
			menu.extend (menu_item)
			main_menu.extend (menu)
		end
		
	initialise_widgets is
			-- Setup widgets
		local
			vb: EV_VERTICAL_BOX
			sep: EV_HORIZONTAL_SEPARATOR
			table: EV_TABLE
			label: EV_LABEL
			li: EV_LIST_ITEM
			split: EV_VERTICAL_SPLIT_AREA
		do
			create vb
			vb.set_padding (4)
			extend (vb)

			create sep
			vb.extend (sep)
			vb.disable_item_expand (sep)
			
			create table
			table.set_column_spacing (4)
			table.set_row_spacing (4)
			table.resize (4, 3)
			vb.extend (table)
			vb.disable_item_expand (table)

			-- priority filter
			create label.make_with_text ("Priority:")
			label.align_text_left
			table.put (label, 1, 1, 1, 1)
			create priority_filter_label
			priority_filter_label.align_text_left
			table.put (priority_filter_label, 2, 1, 1, 1)
			create priority_filter_combo
			create li.make_with_text ("ALL")
			priority_filter_combo.extend (li)
			create li.make_with_text ("DEBUG")
			priority_filter_combo.extend (li)
			create li.make_with_text ("INFO")
			priority_filter_combo.extend (li)
			create li.make_with_text ("WARN")
			priority_filter_combo.extend (li)
			create li.make_with_text ("ERROR")
			priority_filter_combo.extend (li)
			create li.make_with_text ("FATAL")
			priority_filter_combo.extend (li)
			priority_filter_combo.disable_edit
			priority_filter_combo.select_actions.extend (agent enable_apply_button_for_combo)
			table.put (priority_filter_combo, 3, 1, 1, 1)

			-- logger filter
			create label.make_with_text ("Logger:")
			label.align_text_left
			table.put (label, 1, 2, 1, 1)
			create logger_filter_label
			logger_filter_label.align_text_left
			table.put (logger_filter_label, 2, 2, 1, 1)
			create logger_filter_text
			logger_filter_text.change_actions.extend (agent enable_apply_button)
			table.put (logger_filter_text, 3, 2, 1, 1)
			
			-- message filter
			create label.make_with_text ("Message:")
			label.align_text_left
			table.put (label, 1, 3, 1, 1)
			create message_filter_label
			message_filter_label.align_text_left
			table.put (message_filter_label, 2, 3, 1, 1)
			create message_filter_text
			message_filter_text.change_actions.extend (agent enable_apply_button)
			table.put (message_filter_text, 3, 3, 1, 1)
			
			-- apply filter button
			create apply_button.make_with_text ("Apply")
			apply_button.disable_sensitive
			apply_button.select_actions.extend (agent apply_filter_selections)
			table.put (apply_button, 4, 1, 1, 1)

			-- pause button
			create pause_button.make_with_text ("Pause")
			pause_button.select_actions.extend (agent pause)
			table.put (pause_button, 4, 2, 1, 1)
			
			-- clear button
			create clear_button.make_with_text ("Clear")
			clear_button.select_actions.extend (agent clear_events)
			clear_button.disable_sensitive
			table.put (clear_button, 4, 3, 1, 1)
			
			create split
			-- list
			create event_list
			event_list.set_column_titles (<<"Date/time", "Priority", "Logger", "Message">>)
			-- fit columns (fill 700 pixels minus 8 for borders)
			event_list.set_column_width (128, 1)
			event_list.set_column_width (48, 2)
			event_list.set_column_width (88, 3)
			event_list.set_column_width (428, 4)
			event_list.disable_multiple_selection
			split.extend (event_list)
			event_list.select_actions.extend (agent update_details)
			
			-- details bar
			create detail_text
			detail_text.disable_edit
			split.extend (detail_text)
			
			vb.extend (split)	
		end

feature -- Events

	process_log_event (event: L4E_STORABLE_EVENT) is
			-- Process 'event' and display it if it passes all filters
		require
			event_not_void: event /= Void
		local
			row: L4E_EVENT_ROW
		do
			-- check filters
			if priority_filter_matches (event.priority) 
					and then logger_filter_matches (event.logger_name)
					and then message_filter_matches (event.message) then
				-- if paused then store the event in a holding list
				if paused then
					pending_events.force_last (event)
					-- update the pause button to reflect the number of pending events
					pause_button.set_text ("Resume (" + pending_events.count.out + ")")
				else
					create row.make (event)
					lock_update
					event_list.extend (row)
					event_list.ensure_item_visible (row)
					clear_button.enable_sensitive
					unlock_update
				end
			end
		end
		
	priority_filter_matches (priority_text: STRING): BOOLEAN is
			-- Does 'priority_text' pass the priority filter?
		require
			priority_text_not_void: priority_text /= Void
		local
			event_priority: L4E_PRIORITY
		do
			Result := True
			if priority_filter /= Void then
				event_priority := create_priority (priority_text)
				if event_priority < priority_filter then
					Result := False
				end
			end
		end
		
	logger_filter_matches (logger_text: STRING): BOOLEAN is
			-- Does 'logger_text' pass the logger filter?
		require
			logger_text_not_void: logger_text /= Void
		do
			Result := True
			if logger_filter /= Void then
				logger_filter.match (logger_text)
				if logger_filter.match_count = 0 then
					Result := False
				end
			end
		end
		
	message_filter_matches (message_text: STRING): BOOLEAN is
			-- Does 'message_text' pass the message filter?
		require
			message_text_not_void: message_text /= Void
		do
			Result := True
			if message_filter /= Void then
				message_filter.match (message_text)
				if message_filter.match_count = 0 then
					Result := False
				end
			end
		end
		
	update_details (row: L4E_EVENT_ROW) is
			-- Update the formatted text area for the selected row
		require
			row_not_void: row /= Void
		local
			message: STRING
		do	
			message := clone (row.log_event.formatted_message)
			detail_text.set_text (message)
		end
	
	enable_apply_button is
			-- Allow the Apply button to be clicked.
		do
			apply_button.enable_sensitive
		end
	
	enable_apply_button_for_combo (list_item: EV_LIST_ITEM) is
			-- Allow the Apply button to be clicked.
		do
			apply_button.enable_sensitive
		end
		
	apply_filter_selections is
			-- Apply the filter selections made by the user.
		do
			apply_button.disable_sensitive
			change_priority_filter (priority_filter_combo.selected_item.text)
			change_logger_filter (logger_filter_text.text)
			change_message_filter (message_filter_text.text)
		end
		
	clear_events is
			-- Clear all event rows from the list
		do
			event_list.wipe_out
		end
		
	pause is
			-- Stop processing incoming events. Incomming events will be discarded.
			-- If allready paused then unpause.
		do
			if paused then
				-- resume event processing and process all pending events
				paused := False
				process_pending_events
				pause_button.set_text ("Pause")
			else
				paused := True
				pause_button.set_text ("Resume")
			end
		end
		
	change_priority_filter (item_text: STRING) is
			-- Change the priority filter
		require
			item_text_not_void: item_text /= Void
		do
			priority_filter := create_priority (item_text)
			update_current_priority_filter
		end

	update_current_priority_filter is
			-- Set the current priority filter text
		do
			if priority_filter = Void then
				priority_filter_label.set_text (No_filter_applied_text)
			else
				priority_filter_label.set_text (priority_filter.level_str)
			end
		end
		
	change_logger_filter (text: STRING) is
			-- Change the logger filter
		require
			text_not_void: text /= Void
		do
			if text /= Void and then not text.is_empty then
				logger_filter_str := clone (text)
				create logger_filter.make
				logger_filter.compile (text)
				if not logger_filter.is_compiled then
					show_error ("Invalid regular expression for logger filter")
					logger_filter_str := Void
					logger_filter := Void
					logger_filter_text.set_text (text)
					apply_button.enable_sensitive
				end
			else
				logger_filter_str := Void
				logger_filter := Void
			end
			update_current_logger_filter
		end
		
	update_current_logger_filter is
			-- Set the current logger filter text
		do
			if logger_filter = Void then
				logger_filter_label.set_text (No_filter_applied_text)
			else
				logger_filter_label.set_text (logger_filter_str)
			end
		end
		
	change_message_filter (text: STRING) is
			-- Change the message filter
		require
			text_not_void: text /= Void
		do
			if text /= Void and then not text.is_empty then
				message_filter_str := clone (text)
				create message_filter.make
				message_filter.compile (text)
				if not message_filter.is_compiled then
					show_error ("Invalid regular expression for message filter")
					message_filter_str := Void
					message_filter := Void
					message_filter_text.set_text (text)
					apply_button.enable_sensitive
				end
			else
				message_filter_str := Void
				message_filter := Void
			end
			update_current_message_filter	
		end
		
	update_current_message_filter is
			-- Set the current message filter text
		do
			if message_filter = Void then
				message_filter_label.set_text (No_filter_applied_text)
			else
				message_filter_label.set_text (message_filter_str)
			end
		end
			
	create_priority (priority_string: STRING): L4E_PRIORITY is
			-- Create a new priority object from the text 'priority_string'.
			-- Return Void if no matching priority can be found.
		require
			priority_string_not_void: priority_string /= Void
		do
			if priority_string.is_equal ("DEBUG") then
				Result := Debug_p
			elseif priority_string.is_equal ("INFO") then
				Result := Info_p
			elseif priority_string.is_equal ("WARN") then
				Result := Warn_p
			elseif priority_string.is_equal ("ERROR") then
				Result := Error_p
			elseif priority_string.is_equal ("FATAL") then
				Result := Fatal_p
			end
		end
		
	process_pending_events is
			-- Process all events in the holding list
		local
			c: DS_LINKED_LIST_CURSOR [L4E_STORABLE_EVENT]
		do
			lock_update
			from
				c := pending_events.new_cursor
				c.start
			until
				c.off
			loop
				process_log_event (c.item)
				c.forth
			end
			pending_events.wipe_out
			unlock_update
		end
	
	show_error (message: STRING) is
			-- Show 'message' in an error dialog
		require
			message_not_void: message /= Void
		local
			dialog_constants: expanded EV_DIALOG_CONSTANTS
			dialog: EV_ERROR_DIALOG
		do
			create dialog
			dialog.set_buttons (<<dialog_constants.ev_ok>>)
			dialog.set_default_push_button (dialog.button (dialog_constants.ev_ok))
			dialog.set_default_cancel_button (dialog.button (dialog_constants.ev_ok))
			dialog.set_text (message)
			dialog.show_modal_to_window (Current)
		end
		
	export_events is
			-- Prompt for a file name and write events stored in the list to a file.
		do
			file_select_dialog.show_modal_to_window (Current)
		end

	write_to_file is
			-- Write events to the file name chosen by the user
		local
			file: KI_TEXT_OUTPUT_FILE
			dialog: EV_WARNING_DIALOG
			info_dialog: EV_INFORMATION_DIALOG
			overwrite: BOOLEAN
			row: L4E_EVENT_ROW
		do
			overwrite := True
			file := File_system.new_output_file (file_select_dialog.file_name)
			if file.exists then
				create dialog
				dialog.set_text ("File " + file.name + " exists, overwrite?")
				dialog.set_buttons (<<"OK", "Cancel">>)
				dialog.show_modal_to_window (Current)
				-- handle ok or cancel
				if not dialog.selected_button.is_equal ("OK") then
					overwrite := False
				end
			end
			if overwrite then		
				file.open_write
				from
					event_list.start
				until
					event_list.off
				loop
					row ?= event_list.item
					check
						row_not_void: row /= Void
					end
					file.put_string (row.log_event.formatted_message)
					event_list.forth
				end
				file.close
				-- notify user
				create info_dialog
				info_dialog.set_text (event_list.count.out + " events written to file " + file.name)
				info_dialog.show_modal_to_window (Current)
			end
		end
		
	file_select_dialog: EV_FILE_SAVE_DIALOG is
			-- 
		once
			create Result
			Result.save_actions.extend (agent write_to_file)
		end
		
feature {NONE} -- Implementation / filters

	paused: BOOLEAN
			-- Is the processing of events suspended?
			
	priority_filter: L4E_PRIORITY
			-- Level of events to display.
	
	message_filter_str: STRING
			-- Message filter string
			
	message_filter: RX_PCRE_REGULAR_EXPRESSION
			-- Message filter reqular expression
			
	logger_filter_str: STRING
			-- Logger filter string
			
	logger_filter: RX_PCRE_REGULAR_EXPRESSION
			-- Logger filter reqular expression
	
	pending_events: DS_LINKED_LIST [L4E_STORABLE_EVENT]
			-- List of events received while paused.
		
invariant
	
	pending_events_not_void: pending_events /= Void
	running_no_pending_events: not paused implies pending_events.is_empty
	message_filter_not_set: message_filter_str = Void implies message_filter = Void
	logger_filter_not_set: logger_filter_str = Void implies logger_filter = Void
	
end -- class L4E_VISION_MAIN_WINDOW
