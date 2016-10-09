package org.rulez.magwas.zentatools;

import java.io.IOException;
import java.io.StringReader;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

class UnescapeException extends Exception {

	private static final long serialVersionUID = 1L;
	
	UnescapeException(String string) {
		super("Bad xml: "+string);
	}
	
}

public class XPathFunctions {
	
	public static Source unescape(String str) throws Exception {
		str = str.replaceAll("&lt;", "<");
		str = str.replaceAll("&gt;", ">");
		str = str.replaceAll("&quot;", "\"");
		str = "<root>"+str+"</root>";
			try {
				loadXMLFromString(str);
			} catch (SAXException e) {
				throw new UnescapeException(str);
			} catch (Exception e) {
				throw e;
			}
		 {
		}
		return new StreamSource(new StringReader(str));
	}

	private static Document loadXMLFromString(String xml) throws ParserConfigurationException, SAXException, IOException
	{
	    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder builder = factory.newDocumentBuilder();
	    InputSource is = new InputSource(new StringReader(xml));
	    return builder.parse(is);
	}
}
