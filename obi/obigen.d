module obi.obigen;

/*

The OBI ByteCode Generator
converts characters into OBI Bytes, stuff like that
use this module to generate OBI ByteCode most likely from a file
this module is meant to be a part of a bigger program

*/

import std.stdio : writefln;
import obi.obirqlist;

byte obi_to_byte(char n) {
  return cast(byte) n;
}

byte[] str_to_bytes(string s) {
  byte[] bytes = new byte[s.length];

  for (int i = 0; i < s.length; i++) {
    bytes[i] = obi_to_byte(s[i]);
  }

  return bytes;
}

string obi_to_string(byte req) {
  switch (req) {
    case ECHO:
      return "ECHO";
    case MOVE:
      return "MOVE";
    case EACH:
      return "EACH";
    case RESET:
      return "RESET";
    case CLEAR:
      return "CLEAR";
    case PUT:
      return "PUT";
    case GET:
      return "GET";
    case INIT:
      return "INIT";
    case END:
      return "END";
    default:
      return "UNKNOWN";
  }
}
