//
//  Values are 32 bit values layed out as follows:
//
//   3 3 2 2 2 2 2 2 2 2 2 2 1 1 1 1 1 1 1 1 1 1
//   1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0
//  +---+-+-+-----------------------+-------------------------------+
//  |Sev|C|R|     Facility          |               Code            |
//  +---+-+-+-----------------------+-------------------------------+
//
//  where
//
//      Sev - is the severity code
//
//          00 - Success
//          01 - Informational
//          10 - Warning
//          11 - Error
//
//      C - is the Customer code flag
//
//      R - is a reserved bit
//
//      Facility - is the facility code
//
//      Code - is the facility's status code
//
//
// Define the facility codes
//


//
// Define the severity codes
//


//
// MessageId: LOG4E_NT_FATAL
//
// MessageText:
//
//  Fatal
//
#define LOG4E_NT_FATAL                   0x00000001L

//
// MessageId: LOG4E_NT_ERROR
//
// MessageText:
//
//  Error
//
#define LOG4E_NT_ERROR                   0x00000002L

//
// MessageId: LOG4E_NT_WARN
//
// MessageText:
//
//  Warn
//
#define LOG4E_NT_WARN                    0x00000003L

//
// MessageId: LOG4E_NT_INFO
//
// MessageText:
//
//  Info
//
#define LOG4E_NT_INFO                    0x00000004L

//
// MessageId: LOG4E_NT_DEBUG
//
// MessageText:
//
//  Debug
//
#define LOG4E_NT_DEBUG                   0x00000005L

//
// MessageId: LOG4E_NT_MESSAGE
//
// MessageText:
//
//  %1
//
#define LOG4E_NT_MESSAGE                 0x000003E8L

