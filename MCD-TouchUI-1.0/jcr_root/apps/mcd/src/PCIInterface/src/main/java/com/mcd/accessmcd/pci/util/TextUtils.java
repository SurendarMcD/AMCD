package com.mcd.accessmcd.pci.util;

import java.io.UnsupportedEncodingException;

/**
Custom text utilities. <br>

Erik Wannebo 1/5/09
 */ 
public class TextUtils {

    /**
    Return the String encoded as UTF-8. <br>

    Erik Wannebo 1/5/09
     */ 
    public static String toUTF8(String str) 
    {
        try{
            return (new String(str.getBytes(),"UTF-8"));
        }catch(UnsupportedEncodingException uee){
            uee.printStackTrace();
        }
        return "";
    }
    
    /**
    Return the bytes as Hexadecimal String. <br>
    For debugging character encoding issues.

    Erik Wannebo 1/5/09
     */     
    public static String byteArrayToHexString(byte in[]) {
         
        byte ch = 0x00;
        int i = 0; 
        if (in == null || in.length <= 0)
            return null;
        
        String pseudo[] = {"0", "1", "2",
    "3", "4", "5", "6", "7", "8",
    "9", "A", "B", "C", "D", "E",
    "F"};
        StringBuffer out = new StringBuffer(in.length * 2);
        StringBuffer hexline = new StringBuffer(8 * 3);
        StringBuffer asciiline = new StringBuffer(8 * 3);
        int charcount=0;
        while (i < in.length) {
            ch = (byte) (in[i] & 0xF0); // Strip off high nibble
            ch = (byte) (ch >>> 4);
         // shift the bits down
            ch = (byte) (ch & 0x0F);    
//     must do this is high order bit is on!
            hexline.append(pseudo[ (int) ch]); // convert thenibble to a String Character
            ch = (byte) (in[i] & 0x0F); // Strip offlow nibble 
            hexline.append(pseudo[ (int) ch]); // convert thenibble to a String Character
            hexline.append(" ");
            asciiline.append(((char)in[i])+"  ");
            i++;
            charcount++;
            if(charcount>24){
                charcount=0;
                out.append(asciiline.toString()+'\n');
                out.append(hexline.toString()+'\n');
                hexline = new StringBuffer(8 * 3);
                asciiline = new StringBuffer(8 * 3);
            }
        }
        String rslt = new String(out);
        return rslt;
    }    
     public static String charToHexString( char c )
       {
          byte [] twoBytes = { (byte)(c & 0xff), (byte)(c >> 8 & 0xff) };
          return toHexString(twoBytes);
       }
     
     public static String toHexString ( byte[] b )
     {
         char[] hexChar = {
             '0' , '1' , '2' , '3' ,
             '4' , '5' , '6' , '7' ,
             '8' , '9' , 'a' , 'b' ,
             'c' , 'd' , 'e' , 'f'};
     StringBuffer sb = new StringBuffer( b.length * 2 );
     for ( int i=0; i<b.length; i++ )
     {
//    look up high nibble char
     sb.append( hexChar [( b[i] & 0xf0 ) >>> 4] );

//    look up low nibble char
     sb.append( hexChar [b[i] & 0x0f] );
     }
     return sb.toString();
     }
    
    
}
