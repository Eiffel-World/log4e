$Id$

Log4E Configuration Servlet Example
-----------------------------------

This example privides a servlet that can be used to dynamically configure a
the log4e subsystem of a web application. The servlet presents the current 
log3e configuration and allows each logger to be configured individually.

Once compiled, start the web application by specifying the document root path
and port listen for HTTP requests on. Eg:

	log4e_servlet c:\temp 9000

Note: the document root is not used to serve pages but must exist as a valid
directory on your file system.

Once running, open a browser and navigate to the URL:

	http://localhost:9000/servlet/log4e

You can insert this servlet into your own Goanna web applications to provide 
online configuration of your log4e components.

Additional Requirements
-----------------------

Goanna Web Services library. The environment variable GOANNA must be set.
