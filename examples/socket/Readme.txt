$Id$

Log4E Socket Examples
---------------------

The examples in this directory demonstrate the use of socket appenders 
that write and read logging events to and from sockets.

The example in the 'client' directory will write a series of logging
events to a socket as specified on the command line.

The 'server' example will listen to a specified socket and output a
textual representation of each logging event it receives.

Additional Requirements
-----------------------

ISE Eiffel 5.1 or greater.
ISE EiffelNet library.