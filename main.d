import obi.obicc : obicc;
import obi.obirqlist;
import obi.obiregs : cpu;
import std.stdio : writefln, File;
import std.file : exists;


void main(string[] args) {
  if (!exists(args[1])) {
    writefln("openLUD-OBI(main): file does not exist");
    return;
  }
  
  obicc c;

  c.start();  
  c.add_builtin();

  File n = File(args[1], "rb");
  
  byte[] bytes = new byte[1024];

  n.rawRead(bytes);
  c.native(bytes);

  n.close();
}
