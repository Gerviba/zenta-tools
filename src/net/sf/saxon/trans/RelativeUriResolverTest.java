package net.sf.saxon.trans;

import static org.junit.Assert.*;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;

import org.junit.Test;

import net.sf.saxon.Configuration;

public class RelativeUriResolverTest {

	@Test
	public void test() throws TransformerException, MalformedURLException  {
		Configuration config = new Configuration();
		URIResolver uriResolver=null;
		try {
			uriResolver = config.makeURIResolver("net.sf.saxon.trans.RelativeUriResolver");
		} catch (TransformerException e) {
			e.printStackTrace();
		}
		assertNotNull(uriResolver);
		assertNotNull(uriResolver.resolve("/etc/passwd", "/etc/passwd"));
		assertNull(uriResolver.resolve("/passwd", "/passwd"));
		URL[] url={new URL("file://usr/local/lib/saxon9.jar")};
		URLClassLoader loader = new URLClassLoader(url);
		Thread.currentThread().setContextClassLoader(loader);
		assertNotNull(uriResolver.resolve("META-INF/services/javax.xml.transform.TransformerFactory", "META-INF/services/javax.xml.transform.TransformerFactory"));
		assertNull(uriResolver.resolve("/none", "META-INF/services/javax.xml.transform.TransformerFactory"));
	}

}
