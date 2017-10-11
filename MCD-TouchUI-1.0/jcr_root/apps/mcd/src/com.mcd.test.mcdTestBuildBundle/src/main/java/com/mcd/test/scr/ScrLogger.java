package com.mcd.test.scr;

import com.mcd.test.SerializingErrorHandler;
import org.apache.felix.scrplugin.Log;
import org.slf4j.Logger;

public class ScrLogger
  implements Log
{
  private final Logger log;
  private final SerializingErrorHandler errorHandler;

  public ScrLogger(Logger log, SerializingErrorHandler errorHandler)
  {
    this.log = log;
    this.errorHandler = errorHandler;
  }

  public boolean isDebugEnabled() {
    return this.log.isDebugEnabled();
  }

  public void debug(String content) {
    this.log.debug(content);
  }

  public void debug(String content, Throwable error) {
    this.log.debug(content, error);
  }

  public void debug(Throwable error) {
    this.log.debug(error.toString(), error);
  }

  public boolean isInfoEnabled() {
    return this.log.isInfoEnabled();
  }

  public void info(String content) {
    this.log.info(content);
  }

  public void info(String content, Throwable error) {
    this.log.info(content, error);
  }

  public void info(Throwable error) {
    this.log.info(error.toString(), error);
  }

  public boolean isWarnEnabled() {
    return this.log.isWarnEnabled();
  }

  public void warn(String content) {
    this.log.warn(content);
    this.errorHandler.onWarning(content, "", 0, 0);
  }

  public void warn(String content, Throwable error) {
    this.log.warn(content, error);
    this.errorHandler.onWarning(content + ": " + error, "", 0, 0);
  }

  public void warn(String content, String location, int lineNumber) {
    if (isWarnEnabled()) {
      String message = formatMessage(content, location, lineNumber);
      this.log.warn(message);
    }
    this.errorHandler.onWarning(content, location, lineNumber, 0);
  }

  public void warn(Throwable error) {
    this.log.warn(error.toString(), error);
    this.errorHandler.onWarning(error.toString(), "", 0, 0);
  }

  public boolean isErrorEnabled() {
    return this.log.isErrorEnabled();
  }

  public void error(String content) {
    this.log.error(content);
    this.errorHandler.onError(content, "", 0, 0);
  }

  public void error(String content, Throwable error) {
    this.log.error(content, error);
    this.errorHandler.onError(content + ": " + error, "", 0, 0);
  }

  public void error(String content, String location, int lineNumber) {
    if (isErrorEnabled()) {
      String message = formatMessage(content, location, lineNumber);
      this.log.warn(message);
    }
    this.errorHandler.onError(content, location, lineNumber, 0);
  }

  public void error(Throwable error) {
    this.log.error(error.toString(), error);
    this.errorHandler.onError(error.toString(), "", 0, 0);
  }

  private String formatMessage(String content, String location, int lineNumber) {
    return content + " at " + location + ":" + lineNumber;
  }
}