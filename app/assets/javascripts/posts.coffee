# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Shows the chosen file in the post form's drop zone before it is uploaded.
window.loadFile = (event) ->
  file = event.target.files[0]
  return unless file
  preview = document.getElementById('image-preview')
  URL.revokeObjectURL(preview.src) if preview.src.startsWith('blob:')
  preview.src = URL.createObjectURL(file)
  preview.hidden = false
  event.target.closest('.dropzone').classList.add('has-image')
