package org.rulez.magwas.zentatools;

import static org.junit.Assert.*;

import javax.xml.transform.stream.StreamSource;

import org.junit.Test;

public class FromAsciiDocTest extends MarkupTest {

	@Test
	public void testFromAsciidoc() throws Exception{
		String testString = "short example\n\nin two paragraphs";
		
		StreamSource foo = XPathFunctions.fromMediaWiki(testString);
		
		String baz = evaluateXpathOnSource(foo, "/book/para[2]");
		assertEquals("in two paragraphs",baz);
	}

}
