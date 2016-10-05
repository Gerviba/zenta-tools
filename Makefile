prefix = /usr
bindir = $(prefix)/bin
jardir = $(prefix)/share/zenta-tools/
datadir = $(prefix)/share/zenta-tools/

all: zentaworkaround tests testmodel.compiled zenta-tools.compiled misc.compiled

ZENTATOOLS=$(shell pwd)

zenta-tools.jar: classes
	cp -r xslt classes
	cd classes ; zip -ro ../zenta-tools.jar .

model.rules: model.rules.in
	sed s,ZENTADATA,$(datadir), <$< >$@

install: zenta-tools.jar bin.install/zenta-xslt-runner bin.install/xpather model.rules
	install -d $(DESTDIR)$(datadir) $(DESTDIR)$(bindir)
	install zenta-tools.jar $(DESTDIR)$(jardir)
	install bin/csv2xml $(DESTDIR)$(bindir)
	install bin/getGithubIssues $(DESTDIR)$(bindir)
	install bin/getJiraIssues $(DESTDIR)$(bindir)
	install bin.install/zenta-xslt-runner $(DESTDIR)$(bindir)
	install bin.install/xpather $(DESTDIR)$(bindir)
	install bin/yml2xml $(DESTDIR)$(bindir)
	install bin/json2xml $(DESTDIR)$(bindir)
	install model.rules $(DESTDIR)$(datadir)
	install static/structured.css $(DESTDIR)$(datadir)
	install diagrams.style $(DESTDIR)$(datadir)

bin.install:
	mkdir -p bin.install

bin.install/%: bin/% bin.install
	sed s,ZENTAJAR,$(jardir)zenta-tools.jar, <$< >$@

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

cleanbuild:
	rm -rf classes zenta-tools.jar 

tests: rich.test richescape.test docbook.test objlist.test consistencycheck.test tabled.docbook.test compliance.test compliance.docbook.test testmodel.compliance.pdf

%.test: xslt/spec/%.xspec testmodel.%
	 zenta-xslt-runner -l -xsl:xslt/tester/test.xslt -s:testmodel.$(basename $@) tests=xslt/spec/$(basename $@).xspec sources=../../testmodel.zenta,../../testmodel.rich

testmodel.consistencycheck: testmodel.check testmodel.rich testmodel.objlist
	zenta-xslt-runner -xsl:xslt/consistencycheck.xslt -s:testmodel.check -o:testmodel.consistencycheck debug=true 2>&1 | sed 's/\//:/'  |sort --field-separator=':' --key=2

testenv:
	docker run --rm -p 5900:5900 -v $$(pwd):/zentatools -it magwas/zenta-tools /bin/bash

inputs/testmodel.issues.xml:
	mkdir -p inputs
	./bin/getGithubIssues https://api.github.com label:auto_inconsistency+repo:magwas/zenta-tools >inputs/testmodel.issues.xml

inputs/misc.issues.xml:
	mkdir -p inputs
	echo '<none/>' >inputs/misc.issues.xml
inputs/zenta-tools.issues.xml: inputs/testmodel.issues.xml
	cp inputs/testmodel.issues.xml inputs/zenta-tools.issues.xml

testmodel.compliance: testmodel.rich inputs/testmodel.issues.xml
	bin/setupComplianceTestEnvironment
	zenta-xslt-runner -xsl:xslt/compliance.xslt -s:testmodel.compliance.config -o testmodel.compliance

testmodel.compliance.docbook: testmodel.compliance
	zenta-xslt-runner -xsl:xslt/compliance.docbook.xslt -s:testmodel.compliance -o testmodel.compliance.docbook

testmodel.compliance.pics:
	touch testmodel.compliance.pics

