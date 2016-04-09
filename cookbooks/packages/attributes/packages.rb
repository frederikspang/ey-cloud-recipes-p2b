# Specify packages and version numbers to be installed here
#
# Search for packages on instances using: eix <package name>
# Or go to the dashboard and edit the packages for an application to view *unmasked* packages
# Note that the dashboard view will not list masked packages
#
# Examples below:

default[:packages] = [
  {:name => "media-gfx/wkhtmltopdf-bin", :version => "0.12.2.1"},
  {:name => "media-fonts/corefonts", :version => "1-r4"},
  {:name => "media-fonts/roboto", :version => "20111129"},
  {:name => "dev-libs/openssl", :version => "1.0.1p"}
]
