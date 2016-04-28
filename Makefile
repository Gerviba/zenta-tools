
ZENTATOOLS=$(shell pwd)

all: zentaworkaround tests testmodel.compiled 

include model.rules

zentaworkaround:
	mkdir -p ~/.zenta/.metadata/.plugins/org.eclipse.e4.workbench/
	cp workbench.xmi ~/.zenta/.metadata/.plugins/org.eclipse.e4.workbench/
	touch zentaworkaround

classes: src/net/sf/saxon/trans/RelativeUriResolver.java
	mkdir -p classes
	javac -cp /usr/local/lib/saxon9.jar -d classes src/net/sf/saxon/trans/RelativeUriResolver.java

clean:
	git clean -fdx

tests: rich.test docbook.test objlist.test consistencycheck.test tabled.docbook.test

%.test: xslt/spec/%.xspec testmodel.%
	 saxon9 -l -xsl:xslt/tester/test.xslt -s:testmodel.$(basename $@) tests=$$(pwd)/xslt/spec/$(basename $@).xspec sources=../../testmodel.zenta,../../testmodel.rich

testmodel.consistencycheck: testmodel.check testmodel.rich testmodel.objlist
	saxon9 -xsl:xslt/consistencycheck.xslt -s:testmodel.check -o:testmodel.consistencycheck debug=true 2>&1 | sed 's/\//:/'  |sort --field-separator=':' --key=2

testenv:
	docker run --rm -p 5900:5900 -v $$(pwd):/zentatools -it magwas/edemotest:xslt /bin/bash

inputs/testmodel.issues.xml:
	mkdir -p inputs
	./bin/getGithubIssues https://api.github.com label:auto_inconsistency+repo:magwas/zenta-tools >inputs/testmodel.issues.xml
