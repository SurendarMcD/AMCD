package com.mcd.accessmcd.cq.migration.util;

/* 
class taken from cq4
*/

import java.text.FieldPosition;
import java.text.Format;
import java.text.ParsePosition;

public class AutoFormatter extends Format
{
 public static final long serialVersionUID = 9869594;
  /**
   * @deprecated
   */
  public static final int FORMAT_NOISODEC = 256;

  /**
   * @deprecated
   */
  public static final int FORMAT_ISOENC = 512;
  public static final int FORMAT_AUTOLISTS = 2048;

  /**
   * @deprecated
   */
  public static final int FORMAT_AUTOLINK = 4096;
  public static final int FORMAT_BR = 8192;

  /**
   * @deprecated
   */
 public static final int FORMAT_URLENC = 16384;
  public static final int FORMAT_AUTOBR = 10240;
//  private static final String DEFAULT_BR = "<br>";
//  private static final String DEFAULT_TAG_OL_OPEN = "<ol start=\"%s\">";
 // private static final String DEFAULT_TAG_OL_CLOSE = "</ol>";
 // private static final String DEFAULT_TAG_OL_ITEM_OPEN = "<li>";
 // private static final String DEFAULT_TAG_OL_ITEM_CLOSE = "</li>";
//  private static final String DEFAULT_TAG_UL_OPEN = "<ul>";
 // private static final String DEFAULT_TAG_UL_CLOSE = "</ul>";
//  private static final String DEFAULT_TAG_UL_ITEM_OPEN = "<li>";
  //private static final String DEFAULT_TAG_UL_ITEM_CLOSE = "</li>";
 // private static final int STATE_NORMAL = 1;
 // private static final int STATE_OL = 3;
  //private static final int STATE_UL = 4;
  private final String tagBr;
  private final String tagOlOpen;
  private final String tagOlClose;
  private final String tagOlItemOpen;
  private final String tagOlItemClose;
  private final String tagUlOpen;
  private final String tagUlClose;
  private final String tagUlItemStart;
  private final String tagUlItemClose;
  //private final int DEFAULT_MODS = 10240;
  public static final AutoFormatter DEFAULT_FORMATTER = new AutoFormatter();

  
  

  public AutoFormatter()
  {
    //this.DEFAULT_MODS = 10240;

    /*if ((config != null) && 
      (!("auto".equals(config.getName())))) {
      config = config.getChild("auto");
    }

    if (config == null) {
      //config = new DefaultConfig();
    }
   

    this.tagBr = config.getProperty("/br.begin", "<br>");
    this.tagOlOpen = config.getProperty("/ol.begin", "<ol start=\"%s\">");
    this.tagOlClose = config.getProperty("/ol.end", "</ol>");
    this.tagOlItemOpen = config.getProperty("/ol/item.begin", "<li>");
    this.tagOlItemClose = config.getProperty("/ol/item.end", "</li>");
    this.tagUlOpen = config.getProperty("/ul.begin", "<ul>");
    this.tagUlClose = config.getProperty("/ul.end", "</ul>");
    this.tagUlItemStart = config.getProperty("/ul/item.begin", "<li>");
    this.tagUlItemClose = config.getProperty("/ul/item.end", "</li>");
     */
    this.tagBr = "<br>";
    this.tagOlOpen = "<ol start=\"%s\">";
    this.tagOlClose = "</ol>";
    this.tagOlItemOpen = "<li>";
    this.tagOlItemClose =  "</li>";
    this.tagUlOpen = "<ul>";
    this.tagUlClose =  "</ul>";
    this.tagUlItemStart = "<li>";
    this.tagUlItemClose = "</li>";
  }

  public StringBuffer format(Object obj, StringBuffer toAppendTo, FieldPosition pos)
  {
    return format((String)obj, toAppendTo, 10240);
  }

  public Object parseObject(String source, ParsePosition status)
  {
    throw new UnsupportedOperationException("parse not implemented yet");
  }

  public String format(String str, int mods)
  {
    return format(str, new StringBuffer(), mods).toString();
  }

  public StringBuffer format(String str, StringBuffer toAppendTo, int mods)
  {
    int beginCopy = 0;
    int state = 1;
    boolean lineStart = true;
    char[] buffer = str.toCharArray();
    int bufferLen = buffer.length;

    if (toAppendTo == null) toAppendTo = new StringBuffer();

    for (int i = 0; i < bufferLen; ) {
      char c = buffer[i];

      if ((lineStart) && ((mods & 0x800) != 0))
      {
        lineStart = false;

        int ignore = 0;
        if ((c == '-') && (i + 1 < bufferLen) && (buffer[(i + 1)] == ' '))
        {
          if (state == 3) {
            toAppendTo.append(this.tagOlItemClose);
            toAppendTo.append(this.tagOlClose);
          }

          if (state != 4) {
            toAppendTo.append(this.tagUlOpen);
            state = 4;
          } else {
            toAppendTo.append(this.tagUlItemClose);
          }

          toAppendTo.append(this.tagUlItemStart);

          ignore = 2;
        }
        else
        {
          StringBuffer start = new StringBuffer();
          int j=0;
          for (j = i; (j + 2 < bufferLen) && (c >= '0') && (c <= '9'); c = buffer[(++j)]) {
            start.append(c);
          }

          if ((j > i) && (j + 1 < bufferLen) && (buffer[j] == '.') && (buffer[(j + 1)] == ' '))
          {
            if (state == 4) {
              toAppendTo.append(this.tagUlItemClose);
              toAppendTo.append(this.tagUlClose);
            }
 
            if (state != 3) {
              //toAppendTo.append(Text.sprintf(this.tagOlOpen, start.toString()));
              toAppendTo.append(this.tagOlOpen.replaceAll("%s", start.toString()));
              state = 3;
            } else {
              toAppendTo.append(this.tagOlItemClose);
            }

            //toAppendTo.append(Text.sprintf(this.tagOlItemOpen, Integer.valueOf(start.toString())));
            toAppendTo.append(this.tagOlItemOpen);
            ignore = j - i + 2;
          }
          else if (state == 4) {
            toAppendTo.append(this.tagUlItemClose);
            toAppendTo.append(this.tagUlClose);
            state = 1;
          } else if (state == 3) {
            toAppendTo.append(this.tagOlItemClose);
            toAppendTo.append(this.tagOlClose);
            state = 1;
          }

        }

        beginCopy += ignore;
        i += ignore;
      }
      else if ((c == '\r') || (c == '\n'))
      {
        toAppendTo.append(buffer, beginCopy, i - beginCopy);

        if ((i + 1 < bufferLen) && (c == '\r') && (buffer[(i + 1)] == '\n'))
          i += 2;
        else {
          ++i;
        }

        lineStart = true;
        beginCopy = i;

        if ((state == 1) && ((mods & 0x2000) != 0))
          toAppendTo.append(this.tagBr);
      }
      else
      {
        ++i;
      }

    }

    if (beginCopy < bufferLen) {
      toAppendTo.append(buffer, beginCopy, bufferLen - beginCopy);
    }

    if (state == 4) {
      toAppendTo.append(this.tagUlItemClose);
      toAppendTo.append(this.tagUlClose);
      state = 1;
    } else if (state == 3) {
      toAppendTo.append(this.tagOlItemClose);
      toAppendTo.append(this.tagOlClose);
      state = 1;
    }

    return toAppendTo;
  }
}