module obi.obicc;

import obi.obiregs : cpu;
import obi.obireg : register;
import obi.obirqlist;
import std.stdio : writefln, writef;
import core.exception : ArrayIndexError;

/*

obicc - OBI CPU Controller
takes a chunk of bytes and binds each of their functionality to the
corresponding OBI Request

*/

/** ECHO - prints a byte as a character */
int __builtin_echo(byte[] input, cpu* c)
{
  writef("%c", cast(char) input[0]);
  return 0;
}

/** NULL - terminates a statement */

/** INIT - initializes a register */
int __builtin_init(byte[] input, cpu* c)
{
  int reg_num = cast(int) input[0];
  c.initialize(reg_num);

  return 0;
}

/** MOVE - moves a value to a register */
int __builtin_move(byte[] input, cpu* c)
{
  int reg_num = cast(int) input[0];
  byte b = input[1];

  c.addi(b, reg_num);

  return (0);
}

/** EACH - prints out each byte in a register */
int __builtin_each(byte[] input, cpu* c)
{
  int reg_num = cast(int) input[0];
  byte[] bytes = c.r[reg_num].get();
  for (int i = 0; i < bytes.length; i++)
  {
    if (bytes[i] != NULL)
      writef("%c", cast(char) bytes[i]);
  }
  writefln("");
  return 0;
}

/** RESET - resets a register */
int __builtin_reset(byte[] input, cpu* c)
{
  int reg_num = cast(int) input[0];
  c.r[reg_num].reset();
  return 0;
}

/** CLEAR - clears all registers */
int __builtin_clear(byte[] input, cpu* c)
{
  for (int i = 0; i < 256; i++) {
    c.r[i].clear();
  }
  return 0;
}

/** PUT - puts VALUE into REGISTER at POSITION */
int __builtin_put(byte[] input, cpu* c)
{
  int reg_num = cast(int) input[0];
  byte b = input[1];
  int pos = cast(int) input[2];
  c.r[reg_num].set(pos, b);
  return 0;
}

/** GET - gets VALUE from REGISTER at POSITION */
int __builtin_get(byte[] input, cpu* c)
{
  int reg_num = cast(int) input[0];
  int pos = cast(int) input[1];

  byte b = c.r[reg_num].get()[pos];

  int reg_storage = cast(int) input[2];

  c.r[reg_storage].add(b);
  
  return 0;
}

struct obicc
{
  cpu c;
  int function(byte[] inp, cpu* cp)[byte] cc; // bindings for each function for OBI CPU Controller

  void define(byte b, int function(byte[] inp, cpu* cp) fn)
  {
    cc[b] = fn;
  }

  void start()
  {
    c.start();
  }

  int native(byte[] bytecode)
  { // natively run the bytecode
    int pos = 0;
    byte[] inp = [];
    bool ended = false;

    for (int i = 0; i < bytecode.length; i++)
    {
      byte b = bytecode[i];
      if (b == END && !ended)
      {
        ended = true;
      }
      else if (b == END && ended)
      {
        writefln("openLUD-OBI(native): duplicate END");
        return -1;
      }
    }
    if (!ended)
    {
      writefln("openLUD-OBI(native): missing END, invalid bytecode");
      return -1;
    }

    for (int i = 0; i < bytecode.length; i++)
    {
      pos++;
      byte b = bytecode[i];
      if (b == END)
        break;
      if (b == NULL)
      {
        inp ~= b;
        if (inp[0] in cc)
        {

          byte[] by = [];

          if (inp.length > 1)
          {
            by = inp[1 .. $];
          }
          try {
            cc[inp[0]](by, &c);
          } catch (ArrayIndexError e) {
            writefln("openLUD-OBI(native): native could not execute bytecode because of errors in call `%s'", inp[0]);
            writefln("openLUD-OBI(native): internal error message: %s", e.msg);
            return -1;
          }
        }
        inp = [];
      }
      else
      {
        inp ~= b;
      }
    }
    return 0;
  }

  void add_builtin()
  {
    define(ECHO, &__builtin_echo);
    define(INIT, &__builtin_init);
    define(MOVE, &__builtin_move);
    define(EACH, &__builtin_each);
    define(RESET, &__builtin_reset);
    define(CLEAR, &__builtin_clear);
    define(PUT, &__builtin_put);
    define(GET, &__builtin_get);
  }
}
