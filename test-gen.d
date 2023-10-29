module test_gen;

import obi.obicc : obicc;
import obi.obirqlist;
import obi.obiregs : cpu;
import std.stdio : writefln, File;


void main() {
  obicc c;

  c.start();  
  c.add_builtin();

  byte[] bytecode = [
    INIT, 1, NULL, // initialize register 1
    INIT, 2, NULL, // initialize register 2

    PUT, 1, 0x41, 7, NULL, // put 0x41 into register 1 at position 0

    EACH, 1, NULL, // print out each byte in register 1

    GET, 1, 7, 2, NULL, // get byte at position 7 from register 1 and put into register 2

    EACH, 2, NULL, // print out each byte in register 2 (should be 0x41)

    END // end
  ];

  File n = File("testes/get-test.obi", "wb");
  n.rawWrite(bytecode);
  n.close();

  c.native(bytecode);
}
