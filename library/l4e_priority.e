indexing
	description: "A logging priority."
	project: "Project Goanna <http://sourceforge.net/projects/goanna>"
	library: "log4e"
	date: "$Date$"
	revision: "$Revision$"
	author: "Glenn Maughan <glennmaughan@goanna.info>"
	copyright: "Copyright (c) 2002 Glenn Maughan"
	license: "Eiffel Forum License v1 (see forum.txt)."
	
class L4E_PRIORITY
	
inherit
	
	COMPARABLE
		
create
	
	make
	
feature -- Initialisation
	
	make (new_level: INTEGER; desc: STRING) is
			-- Create new priority 
		require
			positive_level: new_level > 0
			desc_exists: desc /= Void	 
		do
			level := new_level
			level_str := desc
		end
	
feature -- Status Report
	
	level: INTEGER
			-- Level at which this priority is invoked.
	
	level_str: STRING
			-- String description of this priority
	
feature -- Comparison
	
	infix "<" (other: like Current): BOOLEAN is
			-- Is 'other' less than Current?
		do
			Result := level < other.level
		end

end -- class L4E_PRIORITY

						  
