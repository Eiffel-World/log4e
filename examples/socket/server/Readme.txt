$Id$

Log4E Socket Server Example
---------------------------

This example listens to a socket for logging events and writes them to
stdout as they arrive. The port that the server will listen to must be 
specified on the command line.

Once compiled, start the server by specifying the port to listen
on. Eg:

	log4e_socket_server 9000

Additional Requirements
-----------------------

ISE Eiffel 5.1 or greater.
ISE EiffelNet library.
