indexing
	description: "Pattern converter formatting information"
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."

class
	L4E_FORMATTING_INFO
	
create
	
	make
	
feature -- Initialisation

	make, reset is 
			-- Initialise to default values
		do
			min := -1
			max := 2_147_483_647
			left_align := False
		end
		
feature -- Status report

	max: INTEGER
			-- Maximum size of formatted string

	min: INTEGER
			-- Minimum size of formatted string
	
	left_align: BOOLEAN
			-- Should formatted string be left aligned?
	
feature -- Status setting
	
	set_max (new_max: INTEGER) is
			-- Set maximum size of formatted string
		require
			positive_max: new_max >= 0
		do
			max := new_max
		end
	
	set_min (new_min: INTEGER) is
			-- Set minimum size of formatted string
		require
			positive_min: new_min >= 0
		do
			min := new_min
		end
	
	set_left_align is
			-- Format the string left aligned
		do
			left_align := True
		end
	
	set_right_align is
			-- Format the string right aligned
		do
			left_align := False
		end
		
end -- class L4E_FORMATTING_INFO

