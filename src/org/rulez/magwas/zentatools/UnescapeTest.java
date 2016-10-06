package org.rulez.magwas.zentatools;

import static org.junit.Assert.*;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.junit.Test;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class UnescapeTest {

	static String readFile(String path) 
			  throws IOException 
			{
			  byte[] encoded = Files.readAllBytes(Paths.get(path));
			  return new String(encoded);
			}

	@Test
	public void testUnescape() throws IOException, XPathExpressionException, ParserConfigurationException, SAXException{
		String testString = readFile("testdata.txt");
		
		StreamSource foo = (StreamSource) XPathFunctions.unescape(testString);
		
		String xpathExpression = "/root/documentation/itemizedlist[2]/listitem/itemizedlist/listitem";
		String baz = evaluateXpathOnSource(foo, xpathExpression);
		assertEquals("embedded lists",baz);
	}

	private String evaluateXpathOnSource(StreamSource foo, String xpathExpression) throws XPathExpressionException {
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
