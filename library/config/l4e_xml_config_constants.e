indexing
	description: "Logging XML configuration constants."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

class
	L4E_XML_CONFIG_CONSTANTS

feature -- Constants

	Log4e_namespace_uri: STRING is "http://goanna.info/spec/log4e"

	Empty_namespace_uri: STRING is ""
		
	Appender_element_name: STRING is "appender"
	
	Param_element_name: STRING is "param"
		
	Category_element_name: STRING is "logger"
	
	Root_element_name: STRING is "root"
		
	Appenderref_element_name: STRING is "appender-ref"
		
	Filter_element_name: STRING is "filter"
		
	Layout_element_name: STRING is "layout"
		
	Name_attribute: STRING is "name"
	
	Value_attribute: STRING is "value"
		
	Type_attribute: STRING is "type"
	
	Priority_attribute: STRING is "priority"

	Additive_attribute: STRING is "additive"
	
	Pattern_attribute: STRING is "pattern"
		
	Ref_attribute: STRING is "ref"
		
	Stdout_appender_type: STRING is "stdout"
		
	Stderr_appender_type: STRING is "stderr"

	File_appender_type: STRING is "file"
	
	Rollingfile_appender_type: STRING is "rollingfile"

	Calendarrolling_appender_type: STRING is "calendarrolling"
	
	Prioritymatch_filter_type: STRING is "prioritymatch"
		
	Priorityrange_filter_type: STRING is "priorityrange"
		
	Stringmatch_filter_type: STRING is "stringmatch"
		
	Datetime_layout_type: STRING is "datetime"
		
	Pattern_layout_type: STRING is "pattern"
		
	Simple_layout_type: STRING is "simple"
	
	Time_layout_type: STRING is "time"
		
	Filename_param_name: STRING is "filename"

	Append_param_name: STRING is "append"
	
	Maxsize_param_name: STRING is "maxsize"
	
	Numbackups_param_name: STRING is "numbackups"
	
	Priority_param_name: STRING is "priority"
	
	Prioritystart_param_name: STRING is "prioritystart"
		
	Priorityend_param_name: STRING is "priorityend"
		
	Match_param_name: STRING is "match"
	
	String_param_name: STRING is "string"

	Pattern_param_name: STRING is "pattern"
		
end -- class L4E_XML_CONFIG_CONSTANTS
