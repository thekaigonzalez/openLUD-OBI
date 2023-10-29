module obi.obireg;

import std.stdio : writefln;

/*

Handles OBI registers

Each register can hold up to 256 bytes of data. a register can only be added to
if it is initialized.

*/

struct register {
private:
  byte[] r; // register data
  int size = -1;
  bool initialized = false;

public:
  /** Initialize the register */
  void initialize() {
    r = new byte[256];
    size = 0;
    initialized = true;
  }

  /** Clear the register */
  void clear() {
    initialized = false; // clear the initialized flag
    size = -1; // reset the size
    destroy(r); // delete the data
  }

  void add(byte b) {
    if (!initialized) { // we have to be initialized before we can add data
      writefln("openLUD-OBI(add): register is not initialized");
      return;
    }
    r[size] = b;
    size++;
  }

  void set(int n, byte b) {
    if (!initialized) {
      writefln("openLUD-OBI(set): register is not initialized");
      return;
    }
    r[n] = b;
  }

  bool available() {
    return this.initialized;
  }

  void reset () {
    size = 0;

    for (int i = 0; i < 256; i++) {
      r[i] = 0;
    }
  }

  byte[] get() {
    if (!initialized) {
      writefln("openLUD-OBI(get): register is not initialized");
      return [];
    }
    return r;
  }

  byte at(int i) {
    if (!initialized) {
      writefln("openLUD-OBI(at): register is not initialized");
      return 0;
    }
    return r[i];
  }
}
