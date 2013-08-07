# README
Quick RDoc is a Chrome Extension which makes it easier to search the ruby-doc.org
repository.

### Usage

Example usage: `rdoc (press tab) ar`

After pressing enter you are taken to the Array page in Ruby-Doc.

### Installation
Download the file `compiled.crx` from this repo to your computer. In chrome open 
a new tab and navigate to `chrome://extensions/`. Drag the file from the 
download location into the Extensions page. This will install the Extension.

### Options
Open the options page to set the version of Ruby you are searching for. Once 
saved Quick RDoc will only display classes for your version of ruby.

### Why
I love ruby-doc.org, it makes it easy to pull up documentation on the Core Ruby 
classes easy. However, after using ruby-doc.org multiple times per day I wanted 
a better way to quickly search the documentation.

## TODO
- ~~Create settings page with options:~~ DONE
  - ~~Set default Ruby version~~ DONE
- Add Std-lib classes to the search
- Allow user to change version in Omnibox (need to come up with syntax)
