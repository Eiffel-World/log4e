indexing
	description: "Example servlet server for dispatching servlet requests."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "examples"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@optushome.com.au>"
	copyright: "Copyright (c) 2001 Glenn Maughan and others"
	license: "Eiffel Forum Freeware License v1 (see forum.txt)."

class
	SERVLET_SERVER
	
inherit

	HTTPD_SERVLET_APP
		rename
			make as parent_make
		end
		
	KL_SHARED_ARGUMENTS
		export
			{NONE} all
		end

creation

	make

feature -- Initialization

	make is
			-- Create and initialise a new server that will listen for connections
			-- on 'port' and serving documents from 'doc_root'.
			-- Start the server
		do
			initialise_logger
			create config
			parse_arguments
			if argument_error then
				print_usage
			else
				config.set_server_port (port)
				parent_make (port, 10)
				register_servlets
				run
			end
		end

feature -- Status report

	port: INTEGER
			-- Server connection port
				
feature {NONE} -- Implementation

	argument_error: BOOLEAN
			-- Did an error occur parsing arguments?

	config: SERVLET_CONFIG
			-- Configuration for servlets

	parse_arguments is
			-- Parse the command line arguments and store appropriate settings
		local
			dir: KL_DIRECTORY
		do
			if Arguments.argument_count < 2 then
				argument_error := True
			else
				-- parse port
				if Arguments.argument(1).is_integer then
					port := Arguments.argument(1).to_integer
					-- parse document root
					create dir.make (Arguments.argument (2))
					dir.open_read
					if dir.is_open_read then
						config.set_document_root (dir.name)
					else
						argument_error := True
					end
				else
					argument_error := True
				end
			end
		end

	print_usage is
			-- Display usage information
		do
			print ("Usage: servlet_server <port-number> <document-root>%R%N")
		end

	initialise_logger is
			-- Initialise the logger
		local
			cat: L4E_LOGGER
			appender: L4E_APPENDER
		do
			cat := Log_hierarchy.logger ("test.1")
			create {L4E_STDOUT_APPENDER} appender.make ("stdout")
			cat.add_appender (appender)
			create {L4E_ROLLING_FILE_APPENDER} appender.make ("test.log", 1000000, 0, True)
			cat.add_appender (appender)
			cat.set_additive (False)
			cat := Log_hierarchy.logger ("test.2")
			
		end
		
	register_servlets is
			-- Initialise servlets
		local
			servlet: HTTP_SERVLET	
		do
			-- register servlets
			servlet_manager.set_servlet_mapping_prefix ("servlet")
			servlet_manager.set_config (config)
			create {LOG4E_CONFIG_SERVLET} servlet.init (config)
			servlet_manager.register_servlet (servlet, "log4e")
		end

end -- class SERVLET_SERVER
