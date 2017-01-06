package org.rulez.magwas.zentatools;

import static org.junit.Assert.*;

import javax.xml.transform.stream.StreamSource;

import org.junit.Test;

public class FromMediaWikiTest extends MarkupTest {

	@Test
	public void testFromMediaWikiToXhtml() throws Exception{
		String testString = "short example\n\nin two paragraphs";
		
		StreamSource foo = XPathFunctions.fromMediaWikiToXhtml(testString);
		
		String baz = evaluateXpathOnSource(foo, "/root/para[2]");
		assertEquals("in two paragraphs",baz);
	}

}
