//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .
//= require bootstrap
//= require jquery-fileupload

$(document).ready(function () {
  // Initialize the jQuery File Upload widget:
  var create_upload = function (params) {
    $.ajax({
      url: "/uploads/create",
      type: 'POST',
      dataType: 'json',
      data: params, // send the file name to the server so it can generate the key param
      async: false,
      success: function(data) {
        console.log('Upload success, wait transcoder.');
      },
      fail: function(e, data) {
        console.log('Fail !');
      }
    })
  }

  var bind_upload_data = function (user_uploader, signature, file_name) {
    // file_name = nomalize_string(file_name);
    label_name = 'huanlv';
    return {
      'content-type': signature['content-type'],
      'success_action_status': signature['success_action_status'],
      'acl': signature['acl'],
      'x-amz-credential': signature['x-amz-credential'],
      'x-amz-algorithm': signature['x-amz-algorithm'],
      'x-amz-date': signature['x-amz-date'],
      'x-amz-signature': signature['x-amz-signature'],
      'policy': signature['policy'],
      'key': user_uploader + '/' + signature['short_date'] + '-' + label_name + '/' + file_name
    }
  }

  $('#fileupload').fileupload({
    maxFileSize: 9999999999999,
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png|mp4|flv|avi|mov|quicktime|mp3|wav|zip|rar|pdf|docx|doc|ppt|pptx)$/i,
    dataType: 'json',
    complete: function (e, data) {
      if( e.status == 201 ) {
        var user_uploader = 'huanlv';
        var label_name = 'huanlv';

        params = {
          aws_response: e.responseText,
          user_uploader: user_uploader,
          label_name: label_name
        };

        create_upload(params);
      }
    }
  }).on('fileuploadadd', function (e, data) {
    var signature_json = $('#fileupload').attr('data');
    var signature = JSON.parse(signature_json);
    var file = data.files[0];

    var user_uploader = 'huanlv';
    var media_type = file.type;

    var form_data;
    var url;

    if( media_type.indexOf('video') != -1 ) {
      form_data = bind_upload_data(user_uploader, signature.video, file.name);
      url = "https://zofy-lecture-video.s3-ap-southeast-1.amazonaws.com";
    }
    else if( media_type.indexOf('image') != -1 ) {
      form_data = bind_upload_data(user_uploader, signature.image, file.name);
      url = "https://zofy-image.s3-ap-southeast-1.amazonaws.com";
    }
    else if( media_type.indexOf('audio') != -1 ) {
      form_data = bind_upload_data(user_uploader, signature.audio, file.name);
      url = "https://zofy-audio.s3-ap-southeast-1.amazonaws.com";
    }
    else if( media_type.indexOf('application') != -1 ) {
      form_data = bind_upload_data(user_uploader, signature.document, file.name);
      url = "https://zofy-document.s3-ap-southeast-1.amazonaws.com";
    }

    data.url = url;
    data.formData = form_data;
  });

  $(window).bind('beforeunload', function(){
    var is_uploading = $(".fileupload-progress").css('opacity');

    if( is_uploading != undefined && is_uploading != 0 ) {
      return 'Your files are uploading, Do you want to exit?';
    }
  });
})
