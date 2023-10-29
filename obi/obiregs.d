module obi.obiregs;

/*

256 registers are held
each register is uninitialized, to initialize them use INIT <register number>
this file contains the OBI register holder struct

*/

import obi.obireg : register;
import std.stdio : writefln;

struct cpu
{
  register[] r;
  int size = -1;
  int index = -1;

  void start()
  {
    r = new register[256];
    size = 0;
    index = 0;
  }

  void initialize(int reg_num)
  {
    index = reg_num;
    r[index].initialize();
  }

  void add(byte b)
  {
    if (!r[index].available())
    {
      writefln("openLUD-OBI(add): register is not available");
      return;
    }

    r[index].add(b);

    index++;
  }

  void addi(byte b, int i)
  {
    if (!r[index].available())
    {
      writefln("openLUD-OBI(addi): register is not available");
      return;
    }

    r[i].add(b);
  }

  void clear()
  {
    r[index].clear();
  }

  void remove_cpu()
  {
    for (int i = 0; i < 256; i++)
    {
      r[i].clear();
    }
  }

  register at(int reg_num)
  {
    return r[reg_num];
  }
}
