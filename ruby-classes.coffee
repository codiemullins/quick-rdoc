root_url = "http://ruby-doc.org/core-2.0/";
version = "Ruby Core 2.0"
json_file = "ruby-classes.json"

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
        re = new RegExp query, 'gi'
        e if Object.prototype.toString.call(e.name.match(re)) == '[object Array]'
        
      callback window.test
  req.send null
  req
  
updateDefaultSuggestion = (element) ->
  url = "#{root_url}#{element['urlpath']}"
  chrome.omnibox.setDefaultSuggestion({
    description: set_description element['name'], url
  })
  
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

    console.log "Input Changed: #{text}"

# This event is fired when the user acceps the input in the omnibox
chrome.omnibox.onInputEntered.addListener (text) ->
  console.log text
  
  if text.indexOf("http") isnt -1
    navigate text
  else
    search text, (elements) ->
      element = elements[0]
      url = "#{root_url}#{element['urlpath']}"
      navigate url
