indexing
	description: "Servlet that allows dynamic configuration of a Log4e logger."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	LOG4E_CONFIG_SERVLET

inherit

	HTTP_SERVLET
		redefine
			do_get, do_post
		end

	UT_STRING_FORMATTER
		export
			{NONE} all
		end
	
	HTTPD_LOGGER
		export
			{NONE} all
		end

creation

	init
	
feature -- Basic operations

	do_get (req: HTTP_SERVLET_REQUEST; resp: HTTP_SERVLET_RESPONSE) is
			-- Process GET request
		local
			action: STRING
			cat_name: STRING
			response: STRING
		do
			action := req.get_parameter ("action")
			if action /= Void then
				cat_name := req.get_parameter ("cat")
				process_action (action, cat_name)
			end
			create response.make (1024)
			debug ("snoop")
				print ("Snoop Servlet%R%N")
			end
			response.append ("<html><head><title>Log4E Configuration</title></head>%R%N")
			response.append ("<h1>Log4E Configuration</h1>")
			response.append (logger_list)
			response.append ("</body></html>%R%N")	
			resp.set_content_length (response.count)
			resp.send (response)
		end
	
	do_post (req: HTTP_SERVLET_REQUEST; resp: HTTP_SERVLET_RESPONSE) is
			-- Process GET request
		do
			do_get (req, resp)
		end
		
feature {NONE} -- Implementation

	process_action (action, cat_name: STRING) is
			-- Process 'action' on 'cat_name'
		require
			action_not_void: action /= Void
			cat_name_not_void: cat_name /= Void
		local
			cat: L4E_LOGGER
		do
			if action.is_equal ("debug") then
				Log_hierarchy.logger (cat_name).set_priority (Debug_p)
			elseif action.is_equal ("info") then
				Log_hierarchy.logger (cat_name).set_priority (Info_p)
			elseif action.is_equal ("warn") then
				Log_hierarchy.logger (cat_name).set_priority (Warn_p)
			elseif action.is_equal ("error") then
				Log_hierarchy.logger (cat_name).set_priority (Error_p)
			elseif action.is_equal ("fatal") then
				Log_hierarchy.logger (cat_name).set_priority (Fatal_p)
			elseif action.is_equal ("reset") then
				Log_hierarchy.logger (cat_name).set_priority (Void)	
			elseif action.is_equal ("additive") then
				cat := Log_hierarchy.logger (cat_name)
				cat.set_additive (not cat.is_additive)
			end
		end
		
	logger_list: STRING is
			-- Generate logger list
		local
			loggers: DS_LIST [L4E_LOGGER]
			c: DS_LIST_CURSOR [L4E_LOGGER]
			ac: DS_LIST_CURSOR [L4E_APPENDER]
			cat: L4E_LOGGER
		do
			create Result.make (2000)
			Result.append ("<table width='100%%' border='1'><tr align='left' valign='top'><th>Logger</th><th>Priority</th><th>Additive?</th><th>Appenders</th><th>Action</th></tr>")
			from
				loggers := Log_hierarchy.all_loggers
				c := loggers.new_cursor
				c.start
			until
				c.off
			loop
				cat := c.item
				-- name
				Result.append ("<tr align='left' valign='top'>")
				Result.append ("<td>")
				Result.append (cat.name)
				Result.append ("</td>")
				-- current log level
				Result.append ("<td>")
				if not cat.is_priority_set then
					Result.append ("(")
				end
				Result.append (cat.priority.level_str)
				if not cat.is_priority_set then
					Result.append (")")
				end
				Result.append ("</td>")
				-- additive
				Result.append ("<td>")
				if cat = Log_hierarchy.root then
					Result.append ("N/A")
				else
					Result.append (cat.is_additive.out)
				end
				Result.append ("</td>")
				-- appenders
				Result.append ("<td>")
				if not cat.appenders.is_empty then
					from
						ac := cat.appenders.new_cursor
						ac.start
					until
						ac.off
					loop
						Result.append (ac.item.generator)
						Result.append (" (")
						Result.append (ac.item.name)
						Result.append (")")
						ac.forth
						if not ac.off then
							Result.append ("<br>")
						end
					end
				else
					Result.append ("&nbsp;")
				end
				Result.append ("</td>")
				-- actions
				Result.append ("<td>")
				Result.append (create_action_anchor ("debug", cat.name))
				Result.append ("&nbsp;")
				Result.append (create_action_anchor ("info", cat.name))
				Result.append ("&nbsp;")
				Result.append (create_action_anchor ("warn", cat.name))
				Result.append ("&nbsp;")
				Result.append (create_action_anchor ("error", cat.name))
				Result.append ("&nbsp;")
				Result.append (create_action_anchor ("fatal", cat.name))
				if cat /= Log_hierarchy.root then
					Result.append ("&nbsp;")
					Result.append (create_action_anchor ("reset", cat.name))
					Result.append ("&nbsp;")
					Result.append (create_action_anchor ("additive", cat.name))
				end
				Result.append ("</td>")
				Result.append ("</tr>")
				c.forth
			end
			Result.append ("</table>")
		end
	
	create_action_anchor (action, cat_name: STRING): STRING	is
			-- Create an anchor element for 'action' and 'cat_name'
		require
			action_not_void: action /= Void
			cat_name_not_void: cat_name /= Void
		do
			create Result.make (40)
			Result.append ("<a href=%"?action=")
			Result.append (action)
			Result.append ("&cat=")
			Result.append (cat_name)
			Result.append ("%">")
			Result.append (action)
			Result.append ("</a>")
		end
		
end -- class LOG4E_CONFIG_SERVLET
