Goanna Log4e
------------
$Revision$

For documentation point your browser at doc/index.htm.

Notes
-----

Release 1.0

- Separated log4e library from Goanna libraries.

- Changed name of CATEGORY to LOGGER to match new Log4J naming.

- Added L4E_ prefix to all classes.

- Updated indexing clauses of all classes.

- Changed pattern escape character from '&' to '@' to simplify its use
  in XML config files.

- Fixed L4E_PRIORITY_MATCH_FILTER.

- Updated XML config to use new GOBO XML parser.

Known Issues for Release 1.0

- XML config only supports ASCII XML files. Unicode support is forthcoming.

- Unix syslog appender does not functioning correctly.