package org.rulez.magwas.zentatools;

import static org.junit.Assert.*;

import javax.xml.transform.stream.StreamSource;

import org.junit.Test;

public class UnescapeTest extends MarkupTest {

	@Test
	public void testUnescape() throws Exception{
		String testString = readFile("testdata.txt");
		
		StreamSource foo = (StreamSource) XPathFunctions.unescape(testString);
		
		String baz = evaluateXpathOnSource(
						foo,
						"/root/documentation/itemizedlist[2]/listitem/itemizedlist/listitem");
		assertEquals("embedded lists",baz);
	}
	
	@Test
	public void testUnescapeBadformatting() {
		String testString = "some </bad> markup";
		
		try {
			XPathFunctions.unescape(testString);
		} catch (Exception e) {
			assertTrue(e instanceof UnescapeException);
			assertEquals(e.getMessage(), "Bad xml: <root>some </bad> markup</root>");
			return;
		}
		fail();
	}

}
