indexing
	description: "Test features of log4e cluster"
	library:    "Goanna log4e Test Harnesses"
	author:     "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright:  "Copyright (c) 2001, Glenn Maughan and others"
	license:    "Eiffel Forum Freeware License v1 (see forum.txt)"
	date:       "$Date$"
	revision:   "$Revision$"

deferred class LOG4E_TEST_LOGGING

inherit

	TS_TEST_CASE

	L4E_PRIORITY_CONSTANTS
		export
			{NONE} all
		end

	L4E_FILTER_CONSTANTS
		export
			{NONE} all
		end
		
feature -- Test

	test_log_hierarchy is
		local
			h: L4E_HIERARCHY
			cat, cat2: L4E_LOGGER
		do
			create h.make (Debug_p)
			cat := h.logger ("test")
			assert ("test_cat_added", h.has ("test"))
			
			-- check that we get the same category if we use the same name
			cat2 := h.logger ("test")
			assert_same ("same_cat", cat, cat2)
			
			-- check a complex category. All intermediate categories should
			-- be created
			cat := h.logger ("a.b.c")
			assert ("cat_a_exists", h.has ("a"))
			assert ("cat_a.b_exists", h.has ("a.b"))
			assert ("cat_a.b.c_exists", h.has ("a.b.c"))
			h.close_all
		end

	test_priority_inheritance is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
		do
			-- test example 1 from log4j docs
			create h.make (Debug_p)
			cat := h.logger ("x.y.z")
			assert ("inherited x.y.z", cat.priority = Debug_p)
			assert ("inherited x.y", h.logger ("x.y").priority = Debug_p)
			assert ("inherited x", h.logger ("x").priority = Debug_p)
			
			-- test example 2 from log4j docs
			create h.make (Debug_p)
			cat := h.logger ("x.y.z")
			cat.set_priority (Error_p)
			cat := h.logger ("x.y")
			cat.set_priority (Fatal_p)
			cat := h.logger ("x")
			cat.set_priority (Warn_p)
			assert ("set x.y.z", h.logger ("x.y.z").priority = Error_p)
			assert ("set x.y", h.logger ("x.y").priority = Fatal_p)
			assert ("set x", h.logger ("x").priority = Warn_p)
			
			-- test example 3 from log4j docs
			create h.make (Debug_p)
			cat := h.logger ("x.y.z")
			cat.set_priority (Error_p)
			cat := h.logger ("x")
			cat.set_priority (Warn_p)
			assert ("set x.y.z", h.logger ("x.y.z").priority = Error_p)
			assert ("inherited x.y", h.logger ("x.y").priority = Warn_p)
			assert ("set x", h.logger ("x").priority = Warn_p)
			
			-- test example 4 from log4j docs
			create h.make (Debug_p)
			cat := h.logger ("x.y.z")
			cat := h.logger ("x")
			cat.set_priority (Warn_p)
			assert ("inherited x.y.z", h.logger ("x.y.z").priority = Warn_p)
			assert ("inherited x.y", h.logger ("x.y").priority = Warn_p)
			assert ("set x", h.logger ("x").priority = Warn_p)	
			
			h.close_all
		end

	test_priority_match_filter is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			filter: L4E_FILTER
			event: L4E_EVENT
		do
			-- create dummy hierarchy and category
			create h.make (Debug_p)
			cat := h.logger ("test")

			create {L4E_PRIORITY_MATCH_FILTER} filter.make (Info_p, true)

			create event.make (cat, Info_p, "test event")
			assert_equal ("info_match", filter.decide (event), Filter_accept)
			
			create event.make (cat, Debug_p, "test event")
			assert_equal ("info_not_match_debug", filter.decide (event), Filter_neutral)
			create event.make (cat, Warn_p, "test event")
			assert_equal ("info_not_match_warn", filter.decide (event), Filter_neutral)
			create event.make (cat, Error_p, "test event")
			assert_equal ("info_not_match_error", filter.decide (event), Filter_neutral)
			create event.make (cat, Fatal_p, "test event")
			assert_equal ("info_not_match_fatal", filter.decide (event), Filter_neutral)	

			create {L4E_PRIORITY_MATCH_FILTER} filter.make (Info_p, false)
			
			create event.make (cat, Info_p, "test event")
			assert_equal ("info_match", filter.decide (event), Filter_reject)
			
			create event.make (cat, Debug_p, "test event")
			assert_equal ("info_not_match_debug", filter.decide (event), Filter_neutral)
			create event.make (cat, Warn_p, "test event")
			assert_equal ("info_not_match_warn", filter.decide (event), Filter_neutral)
			create event.make (cat, Error_p, "test event")
			assert_equal ("info_not_match_error", filter.decide (event), Filter_neutral)
			create event.make (cat, Fatal_p, "test event")
			assert_equal ("info_not_match_fatal", filter.decide (event), Filter_neutral)	
			
			h.close_all
		end
		
	test_priority_range_filter is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			filter: L4E_FILTER
			event: L4E_EVENT
		do
			-- create dummy hierarchy and category
			create h.make (Debug_p)
			cat := h.logger ("test")

			-- Range includes Info, Warn and Error. Accept on range match.
			create {L4E_PRIORITY_RANGE_FILTER} filter.make (Info_p, Error_p, True)

			create event.make (cat, Info_p, "test event")
			assert_equal ("info_match", filter.decide (event), Filter_accept)
			create event.make (cat, Warn_p, "test event")
			assert_equal ("warn_match", filter.decide (event), Filter_accept)
			create event.make (cat, Error_p, "test event")
			assert_equal ("error_match", filter.decide (event), Filter_accept)

			create event.make (cat, Fatal_p, "test event")
			assert_equal ("fatal_not_match", filter.decide (event), Filter_neutral)
			create event.make (cat, Debug_p, "test event")
			assert_equal ("debug_not_match", filter.decide (event), Filter_neutral)
			
			-- Range includes Info, Warn and Error. Reject on range match.
			create {L4E_PRIORITY_RANGE_FILTER} filter.make (Info_p, Error_p, False)
			
			create event.make (cat, Info_p, "test event")
			assert_equal ("info_match", filter.decide (event), Filter_reject)
			create event.make (cat, Warn_p, "test event")
			assert_equal ("warn_match", filter.decide (event), Filter_reject)
			create event.make (cat, Error_p, "test event")
			assert_equal ("error_match", filter.decide (event), Filter_reject)

			create event.make (cat, Fatal_p, "test event")
			assert_equal ("fatal_not_match", filter.decide (event), Filter_neutral)
			create event.make (cat, Debug_p, "test event")
			assert_equal ("debug_not_match", filter.decide (event), Filter_neutral)
			
			-- Range includes Info, Warn and Error and Fatal. Accept on range match.
			create {L4E_PRIORITY_RANGE_FILTER} filter.make (Info_p, Void, true)
			
			create event.make (cat, Info_p, "test event")
			assert_equal ("info_match", filter.decide (event), Filter_accept)
			create event.make (cat, Warn_p, "test event")
			assert_equal ("warn_match", filter.decide (event), Filter_accept)
			create event.make (cat, Error_p, "test event")
			assert_equal ("error_match", filter.decide (event), Filter_accept)
			create event.make (cat, Fatal_p, "test event")
			assert_equal ("fatal_not_match", filter.decide (event), Filter_accept)

			create event.make (cat, Debug_p, "test event")
			assert_equal ("debug_not_match", filter.decide (event), Filter_neutral)
		
			-- Range includes Debug, Info, Warn and Error. Reject on range match.
			create {L4E_PRIORITY_RANGE_FILTER} filter.make (Void, Error_p, true)
			
			create event.make (cat, Info_p, "test event")
			assert_equal ("info_match", filter.decide (event), Filter_accept)
			create event.make (cat, Warn_p, "test event")
			assert_equal ("warn_match", filter.decide (event), Filter_accept)
			create event.make (cat, Error_p, "test event")
			assert_equal ("error_match", filter.decide (event), Filter_accept)
			create event.make (cat, Debug_p, "test event")
			assert_equal ("debug_not_match", filter.decide (event), Filter_accept)

			create event.make (cat, Fatal_p, "test event")
			assert_equal ("fatal_not_match", filter.decide (event), Filter_neutral)	
			
			h.close_all
		end
	
	test_string_match_filter is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			filter: L4E_FILTER
			event: L4E_EVENT
		do
			-- create dummy hierarchy and category
			create h.make (Debug_p)
			cat := h.logger ("test")

			create {L4E_STRING_MATCH_FILTER} filter.make ("match", True)
			create event.make (cat, Info_p, "this contains match")
			assert_equal ("match_true", filter.decide (event), Filter_accept)
			create event.make (cat, Info_p, "doesn't contain it")
			assert_equal ("no_match_true", filter.decide (event), Filter_neutral)
			
			create {L4E_STRING_MATCH_FILTER} filter.make ("match", False)
			create event.make (cat, Info_p, "this contains match")
			assert_equal ("match_false", filter.decide (event), Filter_reject)
			create event.make (cat, Info_p, "doesn't contain it")
			assert_equal ("no_match_false", filter.decide (event), Filter_neutral)
			
			h.close_all
		end
	
	test_file_appender is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			appender: L4E_APPENDER
		do
			create h.make (Debug_p)
			cat := h.logger ("test")
			
			create {L4E_FILE_APPENDER} appender.make ("log.txt", True)
			cat.add_appender (appender)
			
			cat.debugging ("This is a test")
			cat.error ("This is an error")
			cat.warn ("This is a warning")
			cat.fatal ("This is fatal")
			cat.info ("This is information")
			
			h.close_all
		end
	
	test_rolling_file_appender is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			appender: L4E_APPENDER
			i: INTEGER
		do
			create h.make (Debug_p)
			cat := h.logger ("test")			
			create {L4E_ROLLING_FILE_APPENDER} appender.make ("log_rolling.txt", 200, 4, True)
			cat.add_appender (appender)	
			create {L4E_ROLLING_FILE_APPENDER} appender.make ("log_rolling_2nd.txt", 100, 10, True)
			cat.add_appender (appender)			
			from
				i := 1
			until
				i >= 5
			loop
				cat.debugging ("This is a test")
				cat.error ("This is an error")
				cat.warn ("This is a warning")
				cat.fatal ("This is fatal")
				cat.info ("This is information")
				i := i + 1
			end		
			
			h.close_all
		end

	test_calendar_rolling_file_appender is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			appender: L4E_APPENDER
			i: INTEGER
		do
			create h.make (Debug_p)
			cat := h.logger ("test")			
			create {L4E_CALENDAR_ROLLING_APPENDER} appender.make_minutely ("log_calendar_rolling.txt", 4, True)
			cat.add_appender (appender)	
			from
				i := 1
			until
				i >= 5
			loop
				cat.debugging ("This is a test")
				cat.error ("This is an error")
				cat.warn ("This is a warning")
				cat.fatal ("This is fatal")
				cat.info ("This is information")
				i := i + 1
			end		
			
			h.close_all
		end
		
	test_nt_event_appender is
		local
--			h: L4E_HIERARCHY
--			cat: L4E_LOGGER
--			appender: L4E_APPENDER
		do
--			create h.make (Debug_p)
--			cat := h.logger ("test")			
--			create {L4E_NT_EVENT_L4E_APPENDER} appender.make ("GoannaLog4e")
--			cat.add_appender (appender)	
--			cat.fatal ("This is fatal")
--			cat.error ("This is an error")
--			cat.warn ("This is a warning")
--			cat.info ("This is information")
--			cat.debugging ("This is a test")
		end
		
	test_stdout_event_appender is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			appender: L4E_APPENDER
		do
			create h.make (Debug_p)
			cat := h.logger ("test")			
			create {L4E_STDOUT_APPENDER} appender.make ("stdout")
			cat.add_appender (appender)	
			cat.fatal ("STDOUT: This is fatal")
			cat.error ("STDOUT: This is an error")
			cat.warn ("STDOUT: This is a warning")
			cat.info ("STDOUT: This is information")
			cat.debugging ("STDOUT: This is a test")
			
			h.close_all
		end
		
	test_stderr_event_appender is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			appender: L4E_APPENDER
		do
			create h.make (Debug_p)
			cat := h.logger ("test")			
			create {L4E_STDERR_APPENDER} appender.make ("stderr")
			cat.add_appender (appender)	
			cat.fatal ("STDERR: This is fatal")
			cat.error ("STDERR: This is an error")
			cat.warn ("STDERR: This is a warning")
			cat.info ("STDERR: This is information")
			cat.debugging ("STDERR: This is a test")
			
			h.close_all
		end
	
	test_time_layout is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			appender: L4E_APPENDER
			layout: L4E_LAYOUT
		do
			create h.make (Debug_p)
			cat := h.logger ("test")			
			create {L4E_STDOUT_APPENDER} appender.make ("stdout")
			create {L4E_TIME_LAYOUT} layout.make
			appender.set_layout (layout)
			cat.add_appender (appender)	
			cat.fatal ("This is fatal")
			cat.error ("This is an error")
			cat.warn ("This is a warning")
			cat.info ("This is information")
			cat.debugging ("This is a test")
			
			h.close_all
		end	
		
	test_date_time_layout is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			appender: L4E_APPENDER
			layout: L4E_LAYOUT
		do
			create h.make (Debug_p)
			cat := h.logger ("test")			
			create {L4E_STDOUT_APPENDER} appender.make ("stdout")
			create {L4E_TIME_LAYOUT} layout.make
			appender.set_layout (layout)
			cat.add_appender (appender)	
			cat.fatal ("This is fatal")
			cat.error ("This is an error")
			cat.warn ("This is a warning")
			cat.info ("This is information")
			cat.debugging ("This is a test")
			
			h.close_all
		end	
		
	test_log_pattern_parser is
		local
			converter: L4E_PATTERN_PARSER
		do
			create converter.make ("[@30m]")
			--assert ("parsing_ok", converter.ok)
		end
		
	test_log_pattern_layout is
		local
			h: L4E_HIERARCHY
			cat: L4E_LOGGER
			appender: L4E_APPENDER
			layout: L4E_LAYOUT
		do
			create h.make (Debug_p)
			cat := h.logger ("test")			
			create {L4E_STDOUT_APPENDER} appender.make ("stdout")
			create {L4E_PATTERN_LAYOUT} layout.make ("@d [@-6p] @c - @.10m%N")
			appender.set_layout (layout)
			cat.add_appender (appender)	
			cat.fatal ("This is fatal")
			cat.error ("This is an error")
			cat.warn ("This is a warning")
			cat.info ("This is information")
			cat.debugging ("This is a test")
			
			h.close_all
		end
		
--	test_syslog_appender is
--		local
--			h: L4E_HIERARCHY
--			cat: L4E_LOGGER
--			appender: L4E_APPENDER
--			facilities: expanded L4E_SYSL4E_APPENDER_CONSTANTS
--		do
--			create h.make (Debug_p)
--			cat := h.logger ("test")			
--			create {L4E_SYSLOG_APPENDER} appender.make ("stdout", "192.168.0.46", facilities.Log_local0)
--			cat.add_appender (appender)	
--			cat.fatal ("This is fatal")
--			cat.error ("This is an error")
--			cat.warn ("This is a warning")
--			cat.info ("This is information")
--			cat.debugging ("This is a test")
--		end

	test_shared_log_hierarchy is
		local
			shared_hierarchy: expanded L4E_SHARED_HIERARCHY
			appender: L4E_APPENDER
		do
			create {L4E_STDOUT_APPENDER} appender.make ("stdout")
			shared_hierarchy.log_hierarchy.logger ("test.cat").add_appender (appender)
			shared_hierarchy.fatal ("test.cat", "This is fatal for shared")
			shared_hierarchy.error ("test.cat", "This is an error for shared")
			shared_hierarchy.warn ("test.cat", "This is a warning for shared")
			shared_hierarchy.info ("test.cat", "This is information for shared")
			shared_hierarchy.debugging ("test.cat", "This is a test for shared")
		end
	
	test_log_xml_config is
		local
--			shared_hierarchy: expanded L4E_SHARED_HIERARCHY
			config: L4E_XML_CONFIG_PARSER
		do
			create config.make ("log_config.xml")
		end	
		
end -- class LOG4E_TEST_LOGGING
