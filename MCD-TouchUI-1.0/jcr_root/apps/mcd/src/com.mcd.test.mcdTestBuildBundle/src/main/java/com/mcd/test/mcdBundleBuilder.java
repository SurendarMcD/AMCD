package com.mcd.test;

import aQute.lib.osgi.Builder;
import aQute.lib.osgi.Jar;
import com.day.crx.ide.scr.BundleJavaClassDescriptorManager;
import com.mcd.test.scr.ScrLogger;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.jar.Attributes;
import java.util.jar.Manifest;
import javax.jcr.Item;
import javax.jcr.Node;
import javax.jcr.NodeIterator;
import javax.jcr.Property;
import javax.jcr.RepositoryException;
import javax.jcr.Session;
import javax.jcr.Workspace;
import javax.jcr.query.Query;
import javax.jcr.query.QueryManager;
import javax.jcr.query.QueryResult;
import org.apache.commons.io.IOUtils;
import org.apache.felix.scrplugin.JavaClassDescriptorManager;
import org.apache.felix.scrplugin.Log;
import org.apache.felix.scrplugin.SCRDescriptorException;
import org.apache.felix.scrplugin.SCRDescriptorFailureException;
import org.apache.felix.scrplugin.SCRDescriptorGenerator;
import org.apache.jackrabbit.util.ISO9075;
import org.apache.sling.api.resource.ResourceResolver;
import org.apache.sling.commons.compiler.CompilationResult;
import org.apache.sling.commons.compiler.CompilerMessage;
import org.apache.sling.commons.compiler.Options;
import org.apache.sling.jcr.compiler.JcrJavaCompiler;
import org.osgi.framework.BundleContext;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

class mcdBundleBuilder
  implements com.day.crx.ide.BundleConstants
{
  private final Logger log = LoggerFactory.getLogger(mcdBundleBuilder.class);
  private final ResourceResolver resolver;
  private final Session session;
  private final Node srcFolder;
  private final Node bundleHomeNode;
  private final JcrJavaCompiler compiler;
  private final ClassLoader dynamicClassLoader;
  private final BundleContext bundleCtx;
  private final Collection<String> sourceFilePaths;
  private String buildOutput;
  private String manifest;
  private String descriptor;
  private String version;
  private final File tmpDir;

  public mcdBundleBuilder(ResourceResolver resolver, Node srcFolder, Node bundleHomeNode, JcrJavaCompiler compiler, ClassLoader dynamicClassLoader, BundleContext bundleCtx)
    throws RepositoryException
  {
    this.resolver = resolver;
    this.session = ((Session)resolver.adaptTo(Session.class));
    this.srcFolder = srcFolder;
    this.bundleHomeNode = bundleHomeNode;
    this.compiler = compiler;
    this.dynamicClassLoader = dynamicClassLoader;
    this.bundleCtx = bundleCtx;
    this.sourceFilePaths = collectSourceFilePaths();
    setJavaVersion(null);
    this.tmpDir = createWorkingDirectory();
  }

  public void build(SerializingErrorHandler handler)
    throws Exception, IOException
  {
    Iterator iter;
    CompilerMessage msg;
    Item repItem;
    String bundleFileName;
    if ((this.manifest == null) && (this.descriptor == null))
      throw new IllegalStateException("Either manifest or descriptor must be set");

    File compilerOutputDir = new File(this.tmpDir, "classes");
    String compilerOutput = "file://" + compilerOutputDir.getCanonicalPath();

    File resourcesDir = new File(this.tmpDir, "resources");
    resourcesDir.mkdirs();
    String[] arrFolders = BUNDLE_RES_FOLDERS; int lenFolders = arrFolders.length; for (int i$ = 0; i$ < lenFolders ; ++i$) { String relPath = arrFolders[i$];
      if (this.bundleHomeNode.hasNode(relPath)) {
        Node resNode = this.bundleHomeNode.getNode(relPath);
        if (resNode.isNodeType("nt:folder"))
          copyNode2File(resNode, resourcesDir);
      }

    }

    File libsDir = new File(this.tmpDir, "libs");
    libsDir.mkdirs();
    if (this.bundleHomeNode.hasNode("libs")) {
      Node libsNode = this.bundleHomeNode.getNode("libs");
      if (libsNode.isNodeType("nt:folder")) {
        copyNode2File(libsNode, libsDir);
      }

    }

    List urls = new ArrayList();
    File[] arr$ = libsDir.listFiles(); int len$ = arr$.length; for (int i$ = 0; i$ < len$; ++i$) { File f = arr$[i$];
      if (f.getName().endsWith(".jar"))
        urls.add(f.toURI().toURL());
    }

    ClassLoader complementaryClassLoader = new URLClassLoader((URL[])urls.toArray(new URL[urls.size()]), getDynamicClassLoader());

    String[] srcFilePathArray = (String[])getSourceFilePaths().toArray(new String[getSourceFilePaths().size()]);

    Options options = new Options();
    options.put("generateDebugInfo", Boolean.valueOf(true));
    options.put("sourceVersion", this.version);
    options.put("targetVersion", this.version);
    options.put("classLoader", complementaryClassLoader);
    CompilationResult result = this.compiler.compile(srcFilePathArray, compilerOutput, options);

    if (result.getErrors() != null)
      for (iter = result.getErrors().iterator(); iter.hasNext(); ) { msg = (CompilerMessage)iter.next();
        handler.onError(msg.getMessage(), msg.getFile(), msg.getLine(), msg.getColumn());
      }

    if (result.getWarnings() != null)
      for (iter = result.getWarnings().iterator(); iter.hasNext(); ) { msg = (CompilerMessage)iter.next();
        handler.onWarning(msg.getMessage(), msg.getFile(), msg.getLine(), msg.getColumn());
      }

    if (handler.getNumErrors() > 0)
    {
      return;
    }

    File descriptorFile = null;
    File manifestFile = null;
    Manifest manifestObject = null;
    if (this.manifest != null) {
      repItem = this.session.getItem(this.manifest);
      if ((repItem.isNode()) && (((Node)repItem).isNodeType("nt:file"))) {
        manifestFile = new File(this.tmpDir.getCanonicalFile() + "/MANIFEST.MF");
        copyNode2File((Node)repItem, manifestFile);
        FileInputStream fin = new FileInputStream(manifestFile);
        try {
          manifestObject = new Manifest(fin);
        } finally {
          IOUtils.closeQuietly(fin);
        }
      }
    }
    else {
      repItem = this.session.getItem(this.descriptor);
      if ((repItem.isNode()) && (((Node)repItem).isNodeType("nt:file"))) {
        descriptorFile = new File(this.tmpDir.getCanonicalFile() + "/" + repItem.getName());
        copyNode2File((Node)repItem, descriptorFile);
      }

    }

    String scrHeader = generateScrDescriptors(this.resolver, srcFilePathArray, compilerOutputDir, complementaryClassLoader, handler);

    Builder bldr = new Builder();
    if (manifestFile != null)
      bldr.setProperty("-manifest", manifestFile.getCanonicalPath());
    else
      bldr.setProperties(descriptorFile);

    bldr.setClasspath(new File[] { compilerOutputDir });

    String bsn = bldr.getProperty("Bundle-SymbolicName");

    if (bsn == null)
      if (descriptorFile != null) {
        String name = descriptorFile.getName();
        bundleFileName = name.substring(0, name.length() - ".bnd".length()) + ".jar";
      } else {
        bsn = manifestObject.getMainAttributes().getValue("Bundle-SymbolicName");
        bundleFileName = (bsn != null) ? bsn + ".jar" : "bundle.jar";
      }
    else {
      bundleFileName = bldr.getProperty("Bundle-SymbolicName") + ".jar";
    }

    String incRes = bldr.getProperty("Include-Resource");
    if ((incRes == null) || (incRes.length() == 0))
      incRes = "resources";
    else {
      incRes = incRes + ", resources";
    }

    String bcp = bldr.getProperty("Bundle-ClassPath", ".");
    File[] arrFiles = libsDir.listFiles(); int lenFiles = arrFiles.length; for (int i$ = 0; i$ < lenFiles; ++i$) { File f = arrFiles[i$];
      if (f.getName().endsWith(".jar"))
      {
        incRes = incRes + ", " + f.getName() + "=libs/" + f.getName();
        bcp = bcp + "," + f.getName();
      }
    }
    bldr.setProperty("Bundle-ClassPath", bcp);

    if (scrHeader != null)
      incRes = incRes + ", " + scrHeader + "=classes/" + scrHeader;

    bldr.setProperty("Include-Resource", incRes);

    if (scrHeader != null) {
      bldr.setProperty("Service-Component", scrHeader);
    }

    Jar jar = bldr.build();

    List<String> errors = bldr.getErrors();
    List<String> warnings = bldr.getWarnings();
    for (String err : errors)
      handler.onError(err, (this.descriptor != null) ? this.descriptor : this.manifest, 0, 0);

    for (String warn : warnings) {
      handler.onWarning(warn, (this.descriptor != null) ? this.descriptor : this.manifest, 0, 0);
    }

    if (errors.size() == 0) {
      jar.setName(bundleFileName);
      File bundleFile = new File(this.tmpDir, bundleFileName);
      jar.write(bundleFile);

      Node buildOutputNode = null;
      if ((this.buildOutput == null) || (this.buildOutput.length() == 0))
      {
        for (Node parent = this.bundleHomeNode; parent.getDepth() > 0; parent = parent.getParent())
          if (parent.hasNode("install")) {
            buildOutputNode = parent.getNode("install");
            break;
          }


        if (buildOutputNode == null) {
          buildOutputNode = this.bundleHomeNode.addNode("install", "nt:folder");
          this.bundleHomeNode.save();
        }
      } else {
        buildOutputNode = mkNodes(this.session, this.buildOutput, "nt:folder");
      }

      if (buildOutputNode.hasNode(bundleFileName))
        buildOutputNode.getNode(bundleFileName).remove();

      Node fileNode = buildOutputNode.addNode(bundleFileName, "nt:file");
      Node resourceNode = fileNode.addNode("jcr:content", "nt:resource");

      resourceNode.setProperty("jcr:mimeType", "application/java-archive");
      InputStream fin = new FileInputStream(bundleFile);
      try {
        resourceNode.setProperty("jcr:data", fin);
      } finally {
        IOUtils.closeQuietly(fin);
      }
      resourceNode.setProperty("jcr:lastModified", Calendar.getInstance());

      buildOutputNode.save();
    }

    bldr.close();
  }

  public void dispose()
  {
    delete(this.tmpDir);
  }

  public String getBuildOutput()
  {
    return this.buildOutput;
  }

  public void setBuildOutput(String buildOutput)
  {
    this.buildOutput = buildOutput;
  }

  public String getManifest()
  {
    return this.manifest;
  }

  public void setManifest(String manifest)
  {
    this.manifest = manifest;
  }

  public String getDescriptor()
  {
    return this.descriptor;
  }

  public void setDescriptor(String descriptor)
  {
    this.descriptor = descriptor;
  }

  public String getJavaVersion()
  {
    return this.version;
  }

  public void setJavaVersion(String version)
  {
    if (version != null)
      this.version = version;
    else
      this.version = System.getProperty("java.specification.version");
  }

  public Collection<String> getSourceFilePaths()
  {
    return Collections.unmodifiableCollection(this.sourceFilePaths);
  }

  public String getCompilerOutput()
    throws IOException
  {
    return "file://" + new File(this.tmpDir, "classes").getCanonicalPath();
  }

  private ClassLoader getDynamicClassLoader()
  {
    return this.dynamicClassLoader;
  }

  private File createWorkingDirectory()
  {
    File tmpDir = new File(System.getProperty("java.io.tmpdir", "tmp"));
    tmpDir = new File(tmpDir, Long.toString(System.currentTimeMillis()));
    tmpDir.mkdirs();
    return tmpDir;
  }

  private void copyNode2File(Node src, File dest)
    throws IllegalArgumentException, RepositoryException, IOException
  {
    if (src == null)
      throw new IllegalArgumentException("src cannot be null");

    if (dest == null) {
      throw new IllegalArgumentException("dest cannot be null");
    }

    if (src.isNodeType("nt:file"))
    {
      if (dest.isDirectory()) {
        dest.mkdirs();
        dest = new File(dest, src.getName());
      }
      InputStream in = src.getProperty("jcr:content/jcr:data").getStream();
      OutputStream out = null;
      try {
        out = new FileOutputStream(dest);
        IOUtils.copy(in, out);
      } finally {
        IOUtils.closeQuietly(in);
        IOUtils.closeQuietly(out); }
    } else {
      NodeIterator it;
      if (src.isNodeType("nt:folder"))
      {
        if (dest.isFile())
          throw new IllegalArgumentException("dest: directory expected");

        dest.mkdirs();

        for (it = src.getNodes(); it.hasNext(); ) {
          Node n = it.nextNode();
          if (n.isNodeType("nt:file")) {
            copyNode2File(n, new File(dest, n.getName()));
          } else if (n.isNodeType("nt:folder")) {
            File dir = new File(dest, n.getName());
            dir.mkdirs();
            copyNode2File(n, dir);
          }
        }
      } else {
        throw new IllegalArgumentException("src: nt:folder or nt:file expected");
      }
    }
  }

  private void delete(File target)
  {
    File[] arr$;
    int i$;
    if (target.getParentFile() == null)
      throw new IllegalArgumentException("Can not delete root!");
    if (!(target.exists()))
      return;

    if (target.isDirectory()) {
      File[] sub = target.listFiles();
      arr$ = sub; int len$ = arr$.length; for (i$ = 0; i$ < len$; ++i$) { File s = arr$[i$];
        delete(s); }
    }
    target.delete();
  }

  private String generateScrDescriptors(ResourceResolver resolver, String[] sourcePaths, File outputDirectory, ClassLoader complementaryClassLoader, SerializingErrorHandler errorHandler)
  {
    ClassLoader parentCL;
    String finalName = "serviceComponents.xml";
    String metaTypeName = "metatype.xml";
    Log scrLog = new ScrLogger(this.log, errorHandler);

    /*if (complementaryClassLoader != null)
      parentCL = new ClassLoader(getDynamicClassLoader(),complementaryClassLoader) {
        protected Class<?> findClass() throws ClassNotFoundException {
          return complementaryClassLoader.loadClass(name);
        }

        protected URL findResource() {
          return complementaryClassLoader.getResource(name);
        }
      };
    else
    */
      parentCL = getDynamicClassLoader();
    try
    {
      ClassLoader loader = new URLClassLoader(new URL[] { outputDirectory.toURI().toURL() }, parentCL);

      JavaClassDescriptorManager jManager = new BundleJavaClassDescriptorManager(this.bundleCtx, resolver, scrLog, loader, sourcePaths, outputDirectory.getAbsolutePath());

      SCRDescriptorGenerator generator = new SCRDescriptorGenerator(scrLog);

      generator.setOutputDirectory(outputDirectory);
      generator.setDescriptorManager(jManager);

      generator.setFinalName(finalName);
      generator.setMetaTypeName(metaTypeName);

      generator.setGenerateAccessors(true);

      generator.setStrictMode(true);

      if (generator.execute()) {
        File descriptorFile = new File(new File(outputDirectory, "OSGI-INF"), finalName);

        if (descriptorFile.exists())
          return "OSGI-INF/" + finalName;
      }
    }
    catch (IOException ioe)
    {
      scrLog.error("Failed creating classloader for output directory", outputDirectory.toString(), 0);
    }
    catch (SCRDescriptorException sde)
    {
      scrLog.error(sde.getMessage(), sde.getSourceLocation(), sde.getLineNumber());
    }
    catch (SCRDescriptorFailureException sde)
    {
      scrLog.error(sde.getMessage(), "", 0);
    }

    return null;
  }

  private Collection<String> collectSourceFilePaths()
    throws RepositoryException
  {
    QueryManager qm = this.session.getWorkspace().getQueryManager();
    Query query = qm.createQuery("/jcr:root" + ISO9075.encodePath(this.srcFolder.getPath()) + "//element(*,nt:file)", "xpath");

    QueryResult result = query.execute();

    List srcFilePaths = new ArrayList();
    NodeIterator srcFiles = result.getNodes();
    while (srcFiles.hasNext()) {
      Node srcNode = srcFiles.nextNode();
      if (srcNode.getName().endsWith(".java"))
        srcFilePaths.add(srcNode.getPath());
    }

    return srcFilePaths;
  }

  private Node mkNodes(Session session, String path, String nodeType)
    throws RepositoryException
  {
    String[] names = path.split("/");
    Node node = session.getRootNode();
    for (int i = 1; i < names.length; ++i)
      if (node.hasNode(names[i])) {
        node = node.getNode(names[i]);
      } else {
        node = node.addNode(names[i], nodeType);
        node.getParent().save();
      }

    return node;
  }
}