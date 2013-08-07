# Saves options to localStorage.
save_options = ->
  select = document.getElementById 'ruby-version';
  ruby_version = select.children[select.selectedIndex].value
  localStorage['ruby_version'] = ruby_version

  # Update status to let user know options were saved.
  status = document.getElementById 'status'
  status.innerHTML = 'Options Saved.'

  setTimeout () ->
    status.innerHTML = ""
  , 750

# Restores select box state to saved value from localStorage.
restore_options = ->
  ruby_version = localStorage['ruby_version']
  return if not ruby_version

  select = document.getElementById 'ruby-version'

  for child in select.children
    if child.value == ruby_version
      child.selected = 'true'
      break

document.addEventListener 'DOMContentLoaded', restore_options
document.querySelector('#save').addEventListener 'click', save_options
