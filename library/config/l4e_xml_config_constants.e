indexing
	description: "Logging XML configuration constants."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	L4E_XML_CONFIG_CONSTANTS

feature -- Constants

	Log4e_namespace_uri: UC_UTF8_STRING is
		once
			create Result.make_from_string ("http://goanna.info/spec/log4e")
		end

	Empty_namespace_uri: UC_UTF8_STRING is
		once
			create Result.make_from_string ("")
		end
		
	Appender_element_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("appender")
		end
	
	Param_element_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("param")
		end
		
	Category_element_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("category")
		end
	
	Root_element_name: UC_UTF8_STRING is
		once 
			create Result.make_from_string ("root")
		end
		
	Appenderref_element_name: UC_UTF8_STRING is
		once 
			create Result.make_from_string ("appender-ref")
		end
		
	Filter_element_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("filter")
		end
		
	Name_attribute: UC_UTF8_STRING is
		once
			create Result.make_from_string ("name")
		end
	
	Value_attribute: UC_UTF8_STRING is
		once
			create Result.make_from_string ("value")
		end
		
	Type_attribute: UC_UTF8_STRING is
		once
			create Result.make_from_string ("type")
		end
	
	Priority_attribute: UC_UTF8_STRING is
		once
			create Result.make_from_string ("priority")
		end
	
	Additive_attribute: UC_UTF8_STRING is
		once
			create Result.make_from_string ("additive")
		end	
		
	Ref_attribute: UC_UTF8_STRING is
		once
			create Result.make_from_string ("ref")
		end
		
	Stdout_appender_type: UC_UTF8_STRING is
		once 
			create Result.make_from_string ("stdout")
		end
		
	Stderr_appender_type: UC_UTF8_STRING is
		once 
			create Result.make_from_string ("stderr")
		end

	File_appender_type: UC_UTF8_STRING is
		once 
			create Result.make_from_string ("file")
		end
	
	Rollingfile_appender_type: UC_UTF8_STRING is
		once
			create Result.make_from_string ("rollingfile")
		end

	Calendarrolling_appender_type: UC_UTF8_STRING is
		once
			create Result.make_from_string ("calendarrolling")
		end
	
	Prioritymatch_filter_type: UC_UTF8_STRING is
		once
			create Result.make_from_string ("prioritymatch")
		end
		
	Priorityrange_filter_type: UC_UTF8_STRING is
		once
			create Result.make_from_string ("priorityrange")
		end
		
	Stringmatch_filter_type: UC_UTF8_STRING is
		once
			create Result.make_from_string ("stringmatch")
		end
		
	Filename_param_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("filename")
		end

	Append_param_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("append")
		end
	
	Maxsize_param_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("maxsize")
		end
	
	Numbackups_param_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("numbackups")
		end
	
	Priority_param_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("priority")
		end
	
	Prioritystart_param_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("prioritystart")
		end
		
	Priorityend_param_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("priorityend")
		end
		
	Match_param_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("match")
		end
	
	String_param_name: UC_UTF8_STRING is
		once
			create Result.make_from_string ("string")
		end

end -- class L4E_XML_CONFIG_CONSTANTS
