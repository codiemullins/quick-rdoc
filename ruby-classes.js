chrome.omnibox.onInputChanged.addListener(
  function(text, suggest) {
    search(text, function(elements) {
      var results = [];
      for (var i = 0, element; i < 5 && (element = elements[i]); i++) {
        url = "http://ruby-doc.org/core-2.0/" + element['urlpath'];
        results.push({
          content: url,
          description: "<match>"+element['name']+"</match> <dim>Core 2.0 - </dim><url>"+url+"</url>"
        });
      }
      suggest(results)
    });

    console.log('inputChanged: http://ruby-doc.org/core-2.0/' + text);
    // suggest([{content: "String", description: "Class - String"}]);
  });

function navigate(url) {
  chrome.tabs.query({active: true, currentWindow: true}, function(tabs) {
    chrome.tabs.update(tabs[0].id, {url: url});
  });
}

// This event is fired with the user accepts the input in the omnibox.
chrome.omnibox.onInputEntered.addListener(function(text) {
  navigate(text);
});

function search(query, callback) {
  var url = "ruby-classes.json";
  var req = new XMLHttpRequest();
  req.open("GET", url, true);
  req.setRequestHeader("GData-Version", "2");
  req.onreadystatechange = function() {
    if (req.readyState == 4) {
      json = JSON.parse(req.response);
      window.test = json["classes"].filter(function(e,i,a) {
        var re = new RegExp(query, "gi");
        if (Object.prototype.toString.call(e.name.match(re)) == '[object Array]') {
          return e;
        }
      });
      callback(window.test);
    }
  }
  req.send(null);
  return req;
}

// chrome.omnibox.onInputEntered.addListener(function(text) {
//   // TODO(aa): We need a way to pass arbitrary data through. Maybe that is just
//   // URL?
//   if (/@\d+\b/.test(text)) {
//     var chunks = text.split('@');
//     var path = chunks[0];
//     var line = chunks[1];
//     navigate(getUrl(path, line));
//   } else if (text == 'halp') {
//     // TODO(aa)
//   } else {
//     navigate("https://code.google.com/p/chromium/codesearch#search/&type=cs" +
//              "&q=" + text +
//              "&exact_package=chromium&type=cs");
//   }
// });
