package org.rulez.magwas.zentatools;

import java.io.StringReader;

import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;

public class XPathFunctions {
	
	public static Source unescape(String str) {
		str = str.replaceAll("&lt;", "<");
		str = str.replaceAll("&gt;", ">");
		str = str.replaceAll("&quot;", "\"");
		str = "<root>"+str+"</root>";
		System.out.println(str);
		return new StreamSource(new StringReader(str));
	}

}
