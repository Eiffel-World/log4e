indexing
	description: "Hierarchy of logging categories."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."
	
class L4E_HIERARCHY
	
inherit
	
	L4E_PRIORITY_CONSTANTS
	
creation
	
	make
	
feature -- Initialisation
	
	make (priority: L4E_PRIORITY) is
			-- Create a logger hierarchy with a 
			-- root logger with priority 'priority'.
		do
			create root.make (Current, Root_logger_name)
			root.set_priority (priority)
			create categories.make_default
			enable_all
		ensure
			not_disabled: disabled = Disable_off
		end
	
feature -- Logger Factory
	
	logger (cat_name: STRING): L4E_LOGGER is
			-- Return a logger for 'name'. Initialise a new 
			-- logger instance if necessary.
		require
			cat_name_exists: cat_name /= Void and then not cat_name.is_empty
			no_start_or_end_dots: cat_name.item (1) /= '.' and then cat_name.item (cat_name.count) /= '.'
			no_consecutive_dots: cat_name.substring_index ("..", 1) = 0
		do
			-- return root logger if asked for, otherwise search for it
			if cat_name.is_equal (Root_logger_name) then
				Result := root
			else
				if categories.has (cat_name) then
					Result := categories.item (cat_name)
				else
					create Result.make (Current, cat_name)
					categories.put (Result, cat_name)
					set_logger_parents (Result)
				end
			end
		ensure
			logger_exists: has (cat_name)
		end
		
	all_loggers: DS_LIST [L4E_LOGGER] is
			-- Return list of all current categories. Root logger will be first in list
		local
			c: DS_HASH_TABLE_CURSOR [L4E_LOGGER, STRING]
			sorter: DS_QUICK_SORTER [L4E_LOGGER]
			a_comparator: DS_COMPARABLE_COMPARATOR [L4E_LOGGER]
		do
			create {DS_LINKED_LIST [L4E_LOGGER]} Result.make
			from
				c := categories.new_cursor
				c.start
			until
				c.off
			loop
				Result.put_last (c.item)
				c.forth
			end
			create a_comparator.make
			create sorter.make (a_comparator)
			Result.sort (sorter)
			Result.put_first (root)
		end
		
feature -- Status Report
	
	root: L4E_LOGGER
			-- Root logger of this hierarchy
	
	disabled: INTEGER
			-- Globally disabled priority level. Disable_off if no priorities
			-- are disabled.
	
	has (name: STRING): BOOLEAN is
			-- Does a logger with 'name' exist in this hierarchy?
		require
			name_exists: name /= Void
		do
			Result := categories.has (name)
		end
	
	Disable_off: INTEGER is -1
			-- Priority disabled off

	is_enabled_for (priority: L4E_PRIORITY): BOOLEAN is
			-- Is 'priority' level logging enabled for this hierarchy?
		do
			Result := disabled = Disable_off or disabled <= priority.level
		end
		
feature -- Status Setting
	
	disable (priority: L4E_PRIORITY) is
			-- Disable all logging for level 'priority'
		require
			priority_exists: priority /= Void
		do
			disabled := priority.level
		ensure
			priority_disabled: disabled = priority.level
		end
	
	disable_debug is
			-- Disable debug logging
		do
			disabled := Debug_int
		end
	
	disable_info is
			-- Disable info logging
		do
			disabled := Info_int
		end
	
	disable_all is
			-- Disable all logging
		do
			disabled := Fatal_int
		end
	
	enable_all is
			-- Enable all logging
		do
			disabled := Disable_off
		end
	
	clear is
			-- Clear all categories from this hierarchy
		do
			categories.wipe_out
		end
	
	close_all is
			-- Close all appenders for all categories in this
			-- hierarchy
		local
			cursor: DS_HASH_TABLE_CURSOR [L4E_LOGGER, STRING]
		do
			-- close all logger specific appenders
			from
				cursor := categories.new_cursor
				cursor.start
			until
				cursor.off
			loop
				cursor.item.close_appenders
				cursor.forth
			end
			-- close root logger appenders
			root.close_appenders
		end
		
feature {NONE} -- Implementation
	
	categories: DS_HASH_TABLE [L4E_LOGGER, STRING]
			-- Table of categories indexed by their fully qualified
			-- names.
	
	set_logger_parents (new_cat: L4E_LOGGER) is
			-- Split 'new_cat' name and check that 
			-- appropriate parents exist. Create a new 
			-- parent logger if necessary.
		require
			new_cat_exists: new_cat /= Void
		local
			cat_name, sub_name: STRING
			surrogate: L4E_LOGGER
		do
			cat_name := new_cat.name
			-- if this is a logger with no sub parts 
			-- then set its parent to the root
			if cat_name.occurrences ('.') = 0 then
				new_cat.set_parent (root)
			else
				-- if the new logger's name is "w.x.y.z", 
				-- recurse through "w.x.y", "w.x" and "w" but 
				-- not "w.x.y.z". If a parent does 
				-- not exist with the sub logger 
				-- then create it
				sub_name := cat_name.substring (1, last_index_of (cat_name, '.') - 1)
				if not categories.has (sub_name) then
					surrogate := logger (sub_name)
					new_cat.set_parent (surrogate)
				else
					new_cat.set_parent (categories.item (sub_name))
				end
			end
		end
	
feature {NONE} -- Implementation

	Root_logger_name: STRING is "root"
			-- Name of root logger.
			
	last_index_of (str: STRING; c: CHARACTER): INTEGER is
			-- Position of last occurrence of 'c'. 
			-- 0 if none.
			--| Portable implementation. Remove when unnecessary.
		require
			str_not_void: str /= Void
		local
			i: INTEGER
		do
			from
				i := str.count
			until
				i < 1 or else str.item (i) = c
			loop
				i := i - 1
			end
			if i >= 0 then
				Result := i
			end
		ensure
			correct_place: Result > 0 implies str.item (Result) = c
		end
		
end -- class L4E_HIERARCHY
