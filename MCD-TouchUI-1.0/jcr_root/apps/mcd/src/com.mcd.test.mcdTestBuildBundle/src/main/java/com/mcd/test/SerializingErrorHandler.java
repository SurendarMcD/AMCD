package com.mcd.test;

import java.util.Collection;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public abstract class SerializingErrorHandler
{
  private final Logger log = LoggerFactory.getLogger(SerializingErrorHandler.class);
  protected Collection<String> srcFiles;
  protected String output;
  protected String version;
  protected int errors;
  protected int warnings;

  SerializingErrorHandler(Collection<String> srcFiles, String output, String version)
  {
    this.srcFiles = srcFiles;
    this.output = output;
    this.version = version;
    this.errors = 0;
    this.warnings = 0; }

  abstract void start() throws Exception;

  abstract void reportProblem(String paramString1, String paramString2, int paramInt1, int paramInt2, boolean paramBoolean) throws Exception;

  abstract void end() throws Exception;

  int getNumErrors() {
    return this.errors;
  }

  int getNumWarnings() {
    return this.warnings;
  }

  public void onError(String msg, String sourceFile, int line, int position)
  {
    this.errors += 1;
    try {
      reportProblem(msg, sourceFile, line, position, false);
    } catch (Exception e) {
      this.log.error("failed to report propblem", e);
    }
  }

  public void onWarning(String msg, String sourceFile, int line, int position)
  {
    this.warnings += 1;
    try {
      reportProblem(msg, sourceFile, line, position, true);
    } catch (Exception e) {
      this.log.error("failed to report propblem", e);
    }
  }
}