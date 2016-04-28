Documentation tools for zenta models.


usage:
include $(ZENTATOOLS)/model.rules in your makefile
have a docbook.local.xslt stylesheet in the project directory. You can override templates and write functions used in consistencycheck here.

export ZENTATOOLS=/directory/of/zenta-tools
export PATH=$ZENTATOOLS/bin:$PATH

make <modelname>.compiled

The following files are created in the <modelname> directory:

- index.html: model documentation
- pics: the images of model diagrams
- structured.css: a css for the html files
- tabled.html: model documentation in old tabled format
- <modelname>.pdf: pdf model documentation

