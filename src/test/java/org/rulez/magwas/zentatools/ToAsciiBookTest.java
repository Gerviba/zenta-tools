package org.rulez.magwas.zentatools;

import static org.junit.Assert.*;

import javax.xml.transform.stream.StreamSource;

import org.junit.Test;

public class ToAsciiBookTest extends MarkupTest {

	@Test
	public void testFromAsciidoc() throws Exception{
		String testString = "short example\n\nin two paragraphs";
		
		StreamSource foo = (StreamSource) fromAsciidoc(testString);
		
		String baz = evaluateXpathOnSource(foo, "/root/para[2]");
		assertEquals("in two paragraphs",baz);
	}

	private StreamSource fromAsciidoc(String testString) {
		
		return null;
	}

}
