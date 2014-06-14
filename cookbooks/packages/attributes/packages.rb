# Specify packages and version numbers to be installed here
#
# Search for packages on instances using: eix <package name>
# Or go to the dashboard and edit the packages for an application to view *unmasked* packages
# Note that the dashboard view will not list masked packages
#
# Examples below:

default[:packages] = [
  {:name => "app-text/pdftk", :version => "1.41"},
  {:name => "app-text/ghostscript-gpl", :version => "9.10-r2"},
  {:name => "net-print/cups-pdf", :version => "2.6.1"}
]
