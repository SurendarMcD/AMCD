package com.mcd.accessmcd.cq.migration.util;


import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;

public class BaseFlex
{
  
  public static final String base64Table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  public static final String url64Table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-";
  public static final char base64Pad = 61;
  public static final char url64Pad = 126;

  public static String encodeBase64(String in)
  {
    return encode("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", '=', in);
  }

  public static String decodeBase64(String in)
  {
    return decode("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/", '=', in);
  }

  public static String encode(String encodingTable, char padChar, String srcString)
  {
    try
    {
      return encode(encodingTable, padChar, srcString.getBytes("utf-8"));
    } catch (UnsupportedEncodingException e) {
      throw new InternalError("System should have UTF8: " + e.toString());
    }
  }

  public static String encode(String encodingTable, char padChar, byte[] src)
  {
    if ((encodingTable == null) || (encodingTable.length() == 0)) return "";
    if ((src == null) || (src.length == 0)) return "";

    int srcsize = src.length;
    int tbllen = encodingTable.length();

    if ((tbllen != 2) && (tbllen != 4) && (tbllen != 8) && (tbllen != 16) && (tbllen != 32) && (tbllen != 64) && (tbllen != 128))
      return "";

    StringBuffer result = new StringBuffer(srcsize);

    int tblpos = 0;
    int bitpos = 0;
    int bitsread = -1;
    int inpos = 0;
    int pos = 0;

    while (inpos <= srcsize)
    {
      if (bitsread < 0) {
        if (inpos >= srcsize) break;
        pos = src[(inpos++)];

        bitsread = 7;
      }

      tblpos = 0;
      bitpos = tbllen / 2;
      while (bitpos > 0) {
        if (bitsread < 0) {
          pos = (inpos < srcsize) ? src[inpos] : 0;
          ++inpos;
          bitsread = 7;
        }

        if ((1 << bitsread & pos) != 0) tblpos += bitpos;

        bitpos /= 2;
        --bitsread;
      }

      result.append(encodingTable.charAt(tblpos));
    }

    while (bitsread != -1) {
      bitpos = tbllen / 2;
      while (bitpos > 0) {
        if (bitsread < 0) bitsread = 7;
        bitpos /= 2;
        --bitsread;
      }

      result.append(padChar);
    }

    return result.toString();
  }

  public static byte[] decodeToBytes(String decodingTable, char padChar, String srcString)
  {
    int[] x;
    int j;
    if ((decodingTable == null) || (decodingTable.length() == 0) || (srcString == null) || (srcString.length() == 0))
    {
      return new byte[0];
    }

    int srcsize = srcString.length();
    int tbllen = decodingTable.length();

    int shift = 1;
    for (; (shift < 8) && (1 << shift != tbllen); ++shift);
    if (shift == 8) {
      System.out.println("Deconding table size must be a power of two");
      return new byte[0];
    }

    char[] decTable = new char[256];
    for (int i = 0; i < tbllen; ++i) {
      if (decTable[decodingTable.charAt(i)] > 0) {
        System.out.println("Multiply defined codes are not allowed.");
        return new byte[0];
      }
      decTable[decodingTable.charAt(i)] = (char)i;
    }

    ByteArrayOutputStream result = new ByteArrayOutputStream(srcsize);
    int inpos = 0;

    char pos = srcString.charAt(inpos++);
    long incoming = 0L;
    int bitsread = 0;
    while (inpos <= srcsize)
    {
      incoming = (incoming << shift) + decTable[pos];
      bitsread += shift;
      if (bitsread % 8 == 0) {
        x = new int[8];

        j = 0;
        while (j < bitsread >> 3) {
          x[j] = (int)(incoming & 0xFF);
          incoming >>= 8;
          ++j;
        }
        bitsread = 0;
        while (true) {
          do if (j <= 0) break;
          while (x[(--j)] == 0); result.write(x[j]);
        }

      }

      pos = (inpos < srcsize) ? srcString.charAt(inpos) : ' ';
      ++inpos;
    }

    if (bitsread > 0) {
      x = new int[8];

      incoming >>= bitsread % 8;

      j = 0;
      while (j < bitsread >> 3) {
        x[j] = (int)(incoming & 0xFF);
        incoming >>= 8;
        ++j;
      }
      while (true) {
        do {if (j <= 0) break;}
        while (x[(--j)] == 0); result.write(x[j]);
      }
    }

    return result.toByteArray();
  }

  public static String decode(String decodingTable, char padChar, String srcString)
  {
    try
    {
      return new String(decodeToBytes(decodingTable, padChar, srcString), "utf-8");
    }
    catch (UnsupportedEncodingException e) {
      throw new InternalError("System should have UTF8: " + e.toString());
    }
  }
}