/*Copyright 2019-2023 Kai D. Gonzalez*/

module obirqlist;

// contains a list of OBI requests

/*

each OBI ByteCode is list of bytes, each statement separated by a NULL byte.

OBI ByteCode Reference
-----------------------
NULL = 0x00   - NULL will terminate a statement, passing control to the statement before it
ECHO = 0x40   - ECHO will print out a byte as a character
MOVE = 0x41   - MOVE will move a value to a register, will error if register is not initialized
EACH = 0x42   - EACH will print out each byte in a register if it isn't 0
RESET = 0x43  - RESET will reset a register
CLEAR = 0x44  - CLEAR will clear all registers
PUT = 0x45    - PUT will put VALUE into REGISTER at POSITION
GET = 0x46    - GET will get VALUE from REGISTER at POSITION and store it in REGISTER
INIT = 0x100  - INIT will initialize a register
END = 0x43    - marks the end of a bytecode

*/

/** 0 */
const byte NULL = 00; // ...
/** 40 */
const byte ECHO = 40; // [ byte ]
/** 41 */
const byte MOVE = 41; // [ register ] [ byte ]
/** 42 */
const byte EACH = 42; // [ register ]
/** 43 */
const byte RESET = 43; // [ register ]
/** 44 */
const byte CLEAR = 44; // ...
/** 45 */
const byte PUT = 45; // [ register ] [ byte ] [ position ]
/** 46 */
const byte GET = 46; // [ register ] [ position ] [ register ]
/** 100 */
const byte INIT = 100; // [ register number ]
/** 43 */
const byte END = 12; // ...
