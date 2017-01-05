package org.rulez.magwas.zentatools;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.xml.sax.InputSource;

public class MarkupTest {

	protected static String readFile(String path) throws IOException {
	  byte[] encoded = Files.readAllBytes(Paths.get(path));
	  return new String(encoded);
	}

	public MarkupTest() {
		super();
	}

	protected String evaluateXpathOnSource(StreamSource foo, String xpathExpression) throws XPathExpressionException {
		XPathExpression expr = compileXpath(xpathExpression);
		InputSource bar = new InputSource( foo.getReader());
		String baz = expr.evaluate(bar);
		return baz;
	}

	private XPathExpression compileXpath(String xpathExpression) throws XPathExpressionException {
		XPathFactory xPathfactory = XPathFactory.newInstance();
		XPath xpath = xPathfactory.newXPath();
		XPathExpression expr = xpath.compile(xpathExpression);
		return expr;
	}

}