package org.rulez.magwas.zentatools;

import static org.junit.Assert.*;

import javax.xml.transform.stream.StreamSource;

import org.apache.commons.io.IOUtils;
import org.junit.Test;

public class FromVerbatimTest extends MarkupTest {

	@Test
	public void testFromverbatim() throws Exception{
		String testString = "short example\n\nin two paragraphs";
		
		StreamSource foo = XPathFunctions.fromVerbatim(testString);
		String target = IOUtils.toString(foo.getReader());
		assertEquals("<screen><![CDATA[short example\n\nin two paragraphs]]></screen>", target);
	}
}
