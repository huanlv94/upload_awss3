App.transcoding = App.cable.subscriptions.create( 
  { 
    channel: "TranscodingChannel", 
    user_upload: 'huanlv'
  }, 
  {
    connected: function () {
      console.log('Conected');
    },
    disconnected: function () {
      console.log('Disconnected');
    },
    received: function (job) {
      $(".state-shower").each(function (object) {
        var file_name = $(this).attr('data-source');
        file_name = nomalize_string(file_name);

        if( job.key.indexOf(file_name) != -1 ) {
          var current_object = $(this).find('.progress-bar');
          var content_object = $(this).find('.state-content');

          current_object.removeClass('progressing');
          current_object.removeClass('error');
          current_object.removeClass('completed');

          if( job.message != null ) {
            content_object.text(job.message);
          }

          switch(job.status) {
            case "PROGRESSING":
              current_object.addClass('progressing');

              current_object.text('PROGRESSING');
              break;
            case "ERROR":
              current_object.addClass('error');

              current_object.text('ERROR');
              break;
            case "WARNING":
              current_object.addClass('completed');
              current_object.text('COMPLETED');
              
              break;
            case "COMPLETED":
              current_object.addClass('completed');

              current_object.text('COMPLETED');
              break;
            default: 
              break;
          }
        }
      })
    },
    rejected: function () {
      console.log('done');
    }
  }
)