indexing
	description: "Logging XML configuration parser."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_XML_CONFIG_PARSER

inherit
	
	L4E_SHARED_LOG_LOG
		export
			{NONE} all
			{ANY} is_equal, standard_is_equal
		end
	
	L4E_PRIORITY_CONSTANTS
		export
			{NONE} all
		end
		
	L4E_XML_CONFIG_CONSTANTS
		export
			{NONE} all
		end
		
creation

	make, make_with_hierarchy

feature -- Initialisation

	make (config_file_name: STRING) is
			-- Create a new config parser that will parse the file
			-- named 'config_file_name'.
		require
			config_file_name_exists: config_file_name /= Void
		do
			create file_name.make_from_string (config_file_name)
			create category_elements.make_default
			create appenders.make_default
			parse
		end
		
	make_with_hierarchy (config_file_name: STRING; h: L4E_HIERARCHY) is
			-- Create a new config parser that will parse the file
			-- named 'config_file_name' and configure 'h'.
		require
			config_file_name_exists: config_file_name /= Void
			h_not_void: h /= Void
		do
			hierarchy := h
			make (config_file_name)
		end
		
feature -- Parsing

	parse is
			-- Parse specified configuration file and create appropriate
			-- Log4E topology. Make resulting heirarchy available in 
			-- 'hierarchy'.
		do
			parser := parser_factory.new_toe_eiffel_tree_parser
			debug ("log4e_config")
				Internal_log.warn ("Parsing file: " + file_name.out + "...%R%N")
			end
			parser.parse_from_file_name (file_name)
			if parser.last_error = parser.Xml_err_none then
				process_config_tree (parser.document)
			else
				display_parser_error
			end
		end
	
	hierarchy: L4E_HIERARCHY
			-- Configured logging hierarchy
			
feature {NONE} -- Implementation

	parser_factory: expanded XM_PARSER_FACTORY
	
	parser: XM_TREE_PARSER

	file_name: UC_STRING
			-- Name of file to parse.
	
	display_parser_error is
			-- Output parsing error
		do
			internal_log.error (parser.last_error_extended_description)
		end

	appenders: DS_HASH_TABLE [L4E_APPENDER, STRING]
			-- Collection of named appenders
		
	category_elements: DS_HASH_TABLE [XM_ELEMENT, STRING]
			-- Collection of category elements for post processing (after all
			-- appenders have been created so that appender references can 
			-- be resolved.
		
	root_element: XM_ELEMENT
			-- Root element held for post processing all appender refs.
			
	process_config_tree (document: XM_DOCUMENT) is
			-- Process configuration DOM tree.
		require
			document_exists: document /= Void
		local
			child_node_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			element: XM_ELEMENT
		do
			-- process the root element
			process_root (document.root_element)
			if hierarchy /= Void then		
				-- iterate through top level elements and process according to type,
				-- ignoring root as it is already done
				if not document.root_element.is_empty then
					from
						child_node_cursor := document.root_element.new_cursor
						child_node_cursor.start
					until		
						child_node_cursor.off
					loop
						element ?= child_node_cursor.item
						-- skip non-elements
						if element /= Void then
							process_element (element)
						end
						child_node_cursor.forth
					end
				else
					internal_log.error ("No configuration elements found.")
				end
			end
			post_process_categories
			post_process_root	
		end
		
	process_element (element: XM_ELEMENT) is
			-- Determine type of element and process
		require
			element_exists: element /= Void
		local
			name: UC_STRING
		do
			name := element.name
			if name.is_equal (Appender_element_name) then
				process_appender (element)
			elseif name.is_equal (Category_element_name) then
				process_category (element)
			elseif name.is_equal (Root_element_name) then
				-- ignore, already processed
			else
				internal_log.error ("Unknown top level element type: " + name.out)
			end
		end
		
	process_appender (element: XM_ELEMENT) is
			-- Process an appender configuration element
		require
			element_exists: element /= Void
		local
			name, type: UC_STRING
		do
			if element.has_attribute_by_name (Name_attribute) then
				name := element.attribute_by_name (Name_attribute).value
				if element.has_attribute_by_name (Type_attribute) then
					type := element.attribute_by_name (Type_attribute).value
					create_appender (name, type, element)
				else
					internal_log.error ("Appender type attribute not found.")
				end
			else
				internal_log.error ("Appender name attribute not found.")
			end
		end
	
	create_appender (name, type: UC_STRING; element: XM_ELEMENT) is
			-- Create an appender of the specified 'type' and store
			-- in 'appenders' indexed by 'name'
		require
			name_exists: name /= Void
			type_exists: type /= Void
			element_exists: element /= Void
		local
			appender: L4E_APPENDER
		do
			if type.is_equal (Stdout_appender_type) then
				create {L4E_STDOUT_APPENDER} appender.make (name.out)
			elseif type.is_equal (Stderr_appender_type) then
				create {L4E_STDERR_APPENDER} appender.make (name.out)
			elseif type.is_equal (File_appender_type) then
				appender := create_file_appender (name, element)
			elseif type.is_equal (Rollingfile_appender_type) then
				appender := create_rolling_file_appender (name, element)
			elseif type.is_equal (Calendarrolling_appender_type) then
				appender := create_calendar_rolling_appender (name, element)
			end	
			-- process sub-elements
			process_appender_filters (appender, element)
			process_appender_layout (appender, element)
			-- store appender
			if appender /= Void then
				appenders.force (appender, name.out)	
			end
		end

	create_file_appender (name: UC_STRING; element: XM_ELEMENT): L4E_APPENDER is
			-- Create a file appender using parameters in 'element'
		require
			name_exists: name /= Void
			element_exists: element /= Void
		local
			file, append: STRING
		do
			-- retrieve mandatory file name param
			file := retrieve_param_value (Filename_param_name, element)
			if file /= Void then
				-- retrieve optional append param 
				append := retrieve_param_value (Append_param_name, element)
				if append /= Void and then append.is_equal ("true") then
					create {L4E_FILE_APPENDER} Result.make (file, True)
				else
					create {L4E_FILE_APPENDER} Result.make (file, False)
				end
			else
				internal_log.error ("File appender 'filename' attribute not found.")
			end
		end
	
	create_rolling_file_appender (name: UC_STRING; element: XM_ELEMENT): L4E_APPENDER is
			-- Create a rolling file appender using parameters in 'element'
		require
			name_exists: name /= Void
			element_exists: element /= Void
		local
			file, append: STRING
			max_size, number_of_backups: INTEGER_REF
		do
			-- retrieve mandatory file name param
			file := retrieve_param_value (Filename_param_name, element)
			if file /= Void then
				-- retrieve mandatory max_size param
				max_size := retrieve_integer_param_value (Maxsize_param_name, element)
				if max_size /= Void then
					-- retrieve mandatory number_of_backups param
					number_of_backups := retrieve_integer_param_value (Numbackups_param_name, element)
					if number_of_backups /= Void then
						-- retrieve optional append param 
						append := retrieve_param_value (Append_param_name, element)
						if append /= Void and then append.is_equal ("true") then
							create {L4E_ROLLING_FILE_APPENDER} Result.make (file, max_size.item, number_of_backups.item, True)
						else
							create {L4E_ROLLING_FILE_APPENDER} Result.make (file, max_size.item, number_of_backups.item, False)
						end	
					else
						internal_log.error ("File appender 'numbackups' attribute not found.")
					end
				else
					internal_log.error ("File appender 'maxsize' attribute not found.")
				end
			else
				internal_log.error ("File appender 'filename' attribute not found.")
			end
		end	
		
	create_calendar_rolling_appender (name: UC_STRING; element: XM_ELEMENT): L4E_APPENDER is
			-- Create a calendar rolling appender using parameters in 'element'
		require
			name_exists: name /= Void
			element_exists: element /= Void
		local
			file, append: STRING
			number_of_backups: INTEGER_REF
		do
			-- retrieve mandatory file name param
			file := retrieve_param_value (Filename_param_name, element)
			if file /= Void then
				-- retrieve mandatory number_of_backups param
				number_of_backups := retrieve_integer_param_value (Numbackups_param_name, element)
				if number_of_backups /= Void then
					-- retrieve optional append param 
					append := retrieve_param_value (Append_param_name, element)
					if append /= Void and then append.is_equal ("true") then
						create {L4E_CALENDAR_ROLLING_APPENDER} Result.make (file, number_of_backups.item, True)
					else
						create {L4E_CALENDAR_ROLLING_APPENDER} Result.make (file, number_of_backups.item, False)
					end	
				else
					internal_log.error ("Calendar rolling appender 'numbackups' attribute not found.")
				end
			else
				internal_log.error ("Calendar rolling appender 'filename' attribute not found.")
			end
		end	
		
	retrieve_param_value (name: UC_STRING; parent: XM_ELEMENT): STRING is
			-- Locate child param element with specified name. Return value
			-- if found, Void otherwise.
		require
			element_exists: parent /= Void
		local
			child_node_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			element: XM_ELEMENT
			param_name: UC_STRING
		do
			-- iterate through child elements and search for named parameter element
			if not parent.is_empty then
				from
					child_node_cursor := parent.new_cursor
					child_node_cursor.start
				until		
					child_node_cursor.off or Result /= Void
				loop
					element ?= child_node_cursor.item
					-- skip non-elements
					if element /= Void then
						if element.name.is_equal (Param_element_name) then
							-- check for a name attribute
							if element.has_attribute_by_name (Name_attribute) then
								param_name := element.attribute_by_name (Name_attribute).value
								if param_name.is_equal (name) then
									-- retrieve the value attribute
									if element.has_attribute_by_name (Value_attribute) then
										Result := element.attribute_by_name (Value_attribute).value.out
									else
										internal_log.error ("Parameter element value attribute not found.")
									end 
								end
							else
								internal_log.error ("Parameter element name attribute not found.")
							end
						end
					end
					child_node_cursor.forth
				end							
			end
		end
	
	process_appender_filters (appender: L4E_APPENDER; parent: XM_ELEMENT) is
			-- Search 'parent' for any nested filter elements and add them to the 'appender'
		require
			appender_exists: appender /= Void
			parent_exists: parent /= Void
		local
			child_node_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			element: XM_ELEMENT
			type: UC_STRING
			filter: L4E_FILTER
		do
			-- iterate through child elements and search for filter elements
			if not parent.is_empty then
				from
					child_node_cursor := parent.new_cursor
					child_node_cursor.start
				until		
					child_node_cursor.off
				loop
					element ?= child_node_cursor.item
					-- skip non-elements
					if element /= Void then
						if element.name.is_equal (Filter_element_name) then
							-- check for a type attribute
							if element.has_attribute_by_name (Type_attribute) then
								type := element.attribute_by_name (Type_attribute).value
								if type.is_equal (Prioritymatch_filter_type) then
									filter := create_priority_match_filter (element)
								elseif type.is_equal (Priorityrange_filter_type) then
									filter := create_priority_range_filter (element)
								elseif type.is_equal (Stringmatch_filter_type) then
									filter := create_string_match_filter (element)
								else
									internal_log.error ("Unknown filter type " + type.out)
								end
								if filter /= Void then
									appender.add_filter (filter)
								end
							else
								internal_log.error ("Filter element type attribute not found.")
							end
						end
					end
					child_node_cursor.forth
				end					
			end
		end
		
	create_priority_match_filter (element: XM_ELEMENT): L4E_FILTER is
			-- Create a priority match filter.
		require
			element_exists: element /= Void
		local
			priority: STRING
			match: STRING
		do
			-- find mandatory priority parameter
			priority := retrieve_param_value (Priority_param_name, element)
			if priority /= Void then
				-- find mandatory match on filter parameter
				match := retrieve_param_value (Match_param_name, element)
				if match /= Void then
					if match.is_boolean then
						create {L4E_PRIORITY_MATCH_FILTER} Result.make (create_priority (priority), match.to_boolean)
					else
						internal_log.error ("Priority match filter element 'match' attribute is not boolean.")
					end
				else
					internal_log.error ("Priority match filter element 'match' attribute not found.")
				end
			else
				internal_log.error ("Priority match filter element 'priority' attribute not found.")
			end
		end
	
	create_priority_range_filter (element: XM_ELEMENT): L4E_FILTER is
			-- Create a priority range filter.
		require
			element_exists: element /= Void
		local
			priority_start, priority_end: STRING
			match: STRING
		do
			-- find mandatory priority startparameter
			priority_start := retrieve_param_value (Prioritystart_param_name, element)
			if priority_start /= Void then
				-- find mandatory priority end parameter
				priority_end := retrieve_param_value (Priorityend_param_name, element)
				if priority_end /= Void then	
					-- find mandatory match on filter parameter
					match := retrieve_param_value (Match_param_name, element)
					if match /= Void then
						if match.is_boolean then
							create {L4E_PRIORITY_RANGE_FILTER} Result.make (create_priority (priority_start), 
								create_priority (priority_end), match.to_boolean)
						else
							internal_log.error ("Priority range filter element 'match' attribute is not boolean.")
						end
					else
						internal_log.error ("Priority range filter element 'match' attribute not found.")
					end
				else
					internal_log.error ("Priority range filter element 'priorityend' not found.")
				end
			else
				internal_log.error ("Priority range filter element 'prioritystart' attribute not found.")
			end
		end	
	
	create_string_match_filter (element: XM_ELEMENT): L4E_FILTER is
			-- Create a string match filter.
		require
			element_exists: element /= Void
		local
			string: STRING
			match: STRING
		do
			-- find mandatory string parameter
			string := retrieve_param_value (String_param_name, element)
			if string /= Void then
				-- find mandatory match on filter parameter
				match := retrieve_param_value (Match_param_name, element)
				if match /= Void then
					if match.is_boolean then
						create {L4E_STRING_MATCH_FILTER} Result.make (string, match.to_boolean)
					else
						internal_log.error ("String match filter element 'match' attribute is not boolean.")
					end
				else
					internal_log.error ("String match filter element 'match' attribute not found.")
				end
			else
				internal_log.error ("String match filter element 'string' attribute not found.")
			end
		end	
		
	process_appender_layout (appender: L4E_APPENDER; parent: XM_ELEMENT) is
			-- Search 'parent' for any nested layout element and set it on the 'appender'
		require
			appender_exists: appender /= Void
			parent_exists: parent /= Void
		local
			child_node_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			element: XM_ELEMENT
			type: UC_STRING
			layout: L4E_LAYOUT
		do
			-- iterate through child elements and search for layout elements
			if not parent.is_empty then
				from
					child_node_cursor := parent.new_cursor
					child_node_cursor.start
				until		
					child_node_cursor.off
				loop
					element ?= child_node_cursor.item
					-- skip non-elements
					if element /= Void then
						if element.name.is_equal (Layout_element_name) then
							-- check for a type attribute
							if element.has_attribute_by_name (Type_attribute) then
								type := element.attribute_by_name (Type_attribute).value
								if type.is_equal (Datetime_layout_type) then
									create {L4E_DATE_TIME_LAYOUT} layout
								elseif type.is_equal (Simple_layout_type) then
									create {L4E_SIMPLE_LAYOUT} layout
								elseif type.is_equal (Time_layout_type) then
									create {L4E_TIME_LAYOUT} layout.make
								elseif type.is_equal (Pattern_layout_type) then
									layout := create_pattern_layout (element)
								else
									internal_log.error ("Unknown layout type " + type.out)
								end
								if layout /= Void then
									appender.set_layout (layout)
								end
							else
								internal_log.error ("Layout element type attribute not found.")
							end
						end
					end
					child_node_cursor.forth
				end					
			end
		end
		
	create_pattern_layout (element: XM_ELEMENT): L4E_LAYOUT is
			-- Create a pattern layout.
		require
			element_exists: element /= Void
		local
			pattern: STRING
		do
			-- find mandatory pattern parameter
			pattern := retrieve_param_value (Pattern_param_name, element)
			if pattern /= Void then
				create {L4E_PATTERN_LAYOUT} Result.make (pattern)
			else
				internal_log.error ("Pattern layout element 'pattern' attribute not found.")
			end
		end
		
	retrieve_integer_param_value (name: UC_STRING; parent: XM_ELEMENT): INTEGER_REF is
			-- Locate an integer child param element with specified name. Return value
			-- if found, Void otherwise.
		require
			element_exists: parent /= Void
		local
			value: STRING
		do
			value := retrieve_param_value (name, parent)
			if value /= Void then
				if value.is_integer then
					create Result
					Result.set_item (value.to_integer)		
				else
					internal_log.error ("Invalid value found for parameter " + name.out)
				end	
			end
		end
		
	process_category (element: XM_ELEMENT) is
			-- Process a category element
		require
			element_exists: element /= Void
		local
			name: UC_STRING
		do
			if element.has_attribute_by_name (Name_attribute) then
				name := element.attribute_by_name (Name_attribute).value
				category_elements.force (element, name.out)
			else
				internal_log.error ("Category name attribute not found.")
			end			
		end

	post_process_categories is
			-- Process all category elements to resolve appender references
		local
			cursor: DS_HASH_TABLE_CURSOR [XM_ELEMENT, STRING]
		do
			from
				cursor := category_elements.new_cursor
				cursor.start
			until
				cursor.off
			loop
				post_process_category (cursor.key, cursor.item)
				cursor.forth
			end
		end
		
	post_process_category (name: STRING; element: XM_ELEMENT) is
			-- Process a category element and create appropriate category object
		local
			category: L4E_LOGGER
			priority: L4E_PRIORITY
			child_node_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			child: XM_ELEMENT
			additive: STRING
		do
			category := hierarchy.logger (name)
			-- search for optional priority attribute
			if element.has_attribute_by_name (Priority_attribute) then
				priority := create_priority (element.attribute_by_name (Priority_attribute).value.out)
				if priority /= Void then
					category.set_priority (priority)
				end
			end
			-- search for optional additivity attribute
			if element.has_attribute_by_name (Additive_attribute) then
				additive := element.attribute_by_name (Additive_attribute).value.out
				category.set_additive (additive.is_boolean and then additive.to_boolean)
			end
			-- search for optional appender refs
			if not element.is_empty then
				from
					child_node_cursor := element.new_cursor
					child_node_cursor.start
				until		
					child_node_cursor.off
				loop
					child ?= child_node_cursor.item
					-- skip non-elements
					if child /= Void then
						if child.name.is_equal (Appenderref_element_name) then
							-- search for mandatory ref attribute
							if child.has_attribute_by_name (Ref_attribute) then
								category.add_appender (appenders.item (child.attribute_by_name (Ref_attribute).value.out))
							else
								internal_log.error ("Appender reference 'ref' attribute not found.")
							end
						else
							internal_log.error ("Invalid child node within category: " + name)
						end
					end
					child_node_cursor.forth
				end
			end
		end
		
	create_priority (priority_name: STRING): L4E_PRIORITY is
			-- Create a priority object representing the named priority. 
			-- Return Void if not a valid priority
		require
			priority_name_exists: priority_name /= Void
		local
			upper_name: STRING
		do
			upper_name := clone (priority_name)
			upper_name.to_upper
			--| TODO: implement this as a factory
			if upper_name.is_equal ("DEBUG") then
				Result := Debug_p
			elseif upper_name.is_equal ("INFO") then
				Result := Info_p
			elseif upper_name.is_equal ("WARN") then
				Result := Warn_p
			elseif upper_name.is_equal ("ERROR") then
				Result := Error_p
			elseif upper_name.is_equal ("FATAL") then
				Result := Fatal_p
			end
		end
		
	process_root (parent: XM_ELEMENT) is
			-- Process a root element
		require
			element_exists: parent /= Void
		local
			child_node_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			element: XM_ELEMENT
			done: BOOLEAN
			priority: L4E_PRIORITY
		do
			if not parent.is_empty then
				from
					child_node_cursor := parent.new_cursor
					child_node_cursor.start
				until		
					child_node_cursor.off or done
				loop
					element ?= child_node_cursor.item
					-- skip non-elements
					if element /= Void then
						if element.name.is_equal (Root_element_name) then
							-- this is the root, get the priority
							if element.has_attribute_by_name (Priority_attribute) then
								priority := create_priority (element.attribute_by_name (Priority_attribute).value.out)
								if priority /= Void then
									-- if the hierarchy is Void then create a new one, otherwise just set the
									-- priority
									if hierarchy = Void then
										create hierarchy.make (priority)
									else
										hierarchy.root.set_priority (priority)
									end	
									-- store the root element for post processing
									root_element := element
								else
									internal_log.error ("Invalid root category priority.")
								end
							else
								internal_log.error ("Root category priority attribute not found.")
							end
							done := True
						end
					end
					child_node_cursor.forth
				end
			else
				internal_log.error ("Root element not found.")
			end
		end
		
	post_process_root is
			-- Process a category element and create appropriate category object
		require
			root_element_exists: root_element /= Void
		local
			child_node_cursor: DS_BILINEAR_CURSOR [XM_NODE]
			child: XM_ELEMENT
		do
			-- search for optional appender refs
			if not root_element.is_empty then
				from
					child_node_cursor := root_element.new_cursor
					child_node_cursor.start
				until		
					child_node_cursor.off
				loop
					child ?= child_node_cursor.item
					-- skip non-elements
					if child /= Void then
						if child.name.is_equal (Appenderref_element_name) then
							-- search for mandatory ref attribute
							if child.has_attribute_by_name (Ref_attribute) then
								hierarchy.root.add_appender (appenders.item (child.attribute_by_name (Ref_attribute).value.out))
							else
								internal_log.error ("Appender reference 'ref' attribute not found for root.")
							end
						else
							internal_log.error ("Invalid child node within root.")
						end
					end
					child_node_cursor.forth
				end
			end
		end
		
end -- class L4E_XML_CONFIG_PARSER
