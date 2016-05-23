package net.sf.saxon.trans;

import java.io.File;
import java.io.InputStream;

import javax.xml.transform.Source;
import javax.xml.transform.TransformerException;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;

import net.sf.saxon.StandardURIResolver;

public class RelativeUriResolver implements URIResolver {

	@SuppressWarnings("deprecation")
	public final URIResolver baseResolver = new StandardURIResolver();
	@Override
	public Source resolve(String href, String base) throws TransformerException {
		File localfile = new File(href);
		if (localfile.exists()) {
			return baseResolver.resolve(localfile.getAbsolutePath(),localfile.getAbsolutePath());
		}
		InputStream stream = this.getClass().getClassLoader().getResourceAsStream(href);
		if (stream != null) {
			return new StreamSource(stream, href);
		}

		return null;
	}

}
