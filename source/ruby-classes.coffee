ruby_version = root_url = version = json_file = ""

String.prototype.contains = (str, startIndex=0) ->
  -1 isnt String.prototype.indexOf.call @.toLowerCase(), str.toLowerCase(), startIndex

Array.prototype.contains = (str) ->
  -1 isnt Array.prototype.indexOf.call @, str

set_description = (name,url) ->
  "<match>#{name}</match> <dim>#{version} - </dim><url>#{url}</url>"

navigate = (url) ->
  chrome.tabs.query {active: true, currentWindow: true}, (tabs) ->
    chrome.tabs.update tabs[0].id, {url: url}

search = (query, callback) ->
  req = new XMLHttpRequest()
  req.open "GET", json_file, true
  req.setRequestHeader "GData-Version", "2"
  req.onreadystatechange = ->
    if req.readyState == 4
      json = JSON.parse req.response
      window.test = json['classes'].filter (e,i,a) ->
        e if find_match(e, query)

      callback window.test
  req.send null
  req

find_match = (element, query) ->
  element['name'].contains(query) and element['versions'].contains(ruby_version)
  
updateDefaultSuggestion = (element) ->
  url = "#{root_url}#{element['urlpath']}"
  chrome.omnibox.setDefaultSuggestion({
    description: set_description element['name'], url
  })

chrome.omnibox.onInputStarted.addListener ->
  ruby_version = if localStorage['ruby_version'] is undefined then '2.0' else localStorage['ruby_version']
  root_url = "http://ruby-doc.org/core-#{ruby_version}/";
  version = "Ruby Core #{ruby_version}"
  json_file = "ruby-classes.json"
  
chrome.omnibox.onInputChanged.addListener (text, suggest) ->
  search text, (elements) ->
    results = []
    for element, i in elements
      if i is 0
        updateDefaultSuggestion element
      else
        url = "#{root_url}#{element['urlpath']}"
        results.push {
          content: url
          description: set_description element['name'], url
        }
    suggest results

# This event is fired when the user acceps the input in the omnibox
chrome.omnibox.onInputEntered.addListener (text) ->

  if text.contains("http")
    navigate text
  else
    search text, (elements) ->
      element = elements[0]
      url = "#{root_url}#{element['urlpath']}"
      navigate url
