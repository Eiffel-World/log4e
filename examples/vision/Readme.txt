$Id$

Log4E Vision Example
--------------------

This example provides a GUI logging event viewer that listens on a socket
for logging events. The application provides customisable filtering of events
and the ability to export events to a file.

Once compiled, start logvision by specifying the port to listen to.
Eg:

	logvision 9000

You can then execute a remote application that uses a L4E_SOCKET_APPENDER to
write events to the socket that logvision is listening on. For example, you can
compile and run the 'socket/client' example to demonstrate the ability.
For example, running:

	log4e_socket_client localhost 9000

will send a series of logging events to port 9000 on the localhost that will be 
received by logvision and displayed.

Additional Requirements
-----------------------

ISE Eiffel 5.1 or greater.
ISE EiffelNet library.
ISE Vision2.


