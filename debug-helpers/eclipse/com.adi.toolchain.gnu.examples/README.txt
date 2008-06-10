this is stored "incomplete" in svn.  you need to execute generate-plugin.sh and
give it the full path to the examples directory.  this will generate the needed
files for eclipse to enumerate example projects.  for example:
 $ ./generate-plugin.sh ../../../examples/


http://help.eclipse.org/help33/topic/org.eclipse.cdt.doc.isv/guide/projectTemplateEngine/index.html
(note: the documentation reflects CDT-4.0, not CDT-5.0 ... many things are outdated)

todo: set default cpu for toolchain
