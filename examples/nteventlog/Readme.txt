$Id$

Log4E NT Event Log Example
----------------------------------

This example configures a logger that will write events to the NT 
event log.

You will need to compile the external C library in 
$LOG4e/library/appenders/nt/lib using a C compiler.
Try running the make.bat file in that directory. This will create 
a file NTEventLogAppender.dll which must be available on your path. 
Either copy the DLL to a directory on your path, such as, c:\winnt 
or add $LOG4E/library/appenders/nt/lib to your path.

After compiling, run the example using:

	nteventlog

You will find series of log messages in the NT event log application 
section.

Additional Requirements
-----------------------

Windows NT 4 or Windows 2000
ISE Eiffel 5.1 or greater.
C compiler to build the external library.

