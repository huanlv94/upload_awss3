$(document).bind('dragover', function (e){
  $('#fileupload').fileupload({
  dropZone: $('#dropzone')
  });

  var dropZone = $('#dropzone');
  var foundDropzone = {};
  var timeout = window.dropZoneTimeout;
  if (!timeout)
  {
    dropZone.addClass('in');
  }
  else
  {
    clearTimeout(timeout);
  }
  var found = false,
  node = e.target;

  do{
    if ($(node).hasClass('dropzone'))
    {
      found = true;
      foundDropzone = $(node);
      break;
    }

    node = node.parentNode;
  }while (node != null);

  dropZone.removeClass('in hover');

  if (found)
  {
      foundDropzone.addClass('hover');
  }

  window.dropZoneTimeout = setTimeout(function ()
  {
      window.dropZoneTimeout = null;
      dropZone.removeClass('in hover');
  }, 100);
});