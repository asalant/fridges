(function($) {

  $.fn.annotateHandler = function(options) {
    return this.each(function() {
      var $image = $(this);
      var fridge_id = $image.attr('data-id');
      var $details = $(options.target);
      var next_id = 0;

      $image.bind('notes_available', function(event, data) {
        next_id = data.notes.length + 1;
        $.each(data.notes, function(index, value) {
          $details.append(createNoteDiv($image, value));
        });
      });

      $image.bind('note_added', function(event, data) {
        var new_note = data.note;
        if (options.ajax) {
          ajaxCreate(fridge_id, new_note, function(data) {
            new_note.id = data.note.id;
            $details.append(createNoteDiv($image, data.note));
          });
        }
        else {
          $details.append(createNoteDiv($image, data.note));
          data.note.id = next_id++;
        }
      });

      $image.bind('note_updated', function(event, data) {
        var updated_note = data.note;
        if (options.ajax) {
          ajaxDelete(fridge_id, updated_note, function() {
            ajaxCreate(fridge_id, updated_note, function(data) {
              $('#note_' + updated_note.id).replaceWith(createNoteDiv($image, data.note));
            });
          });
        }
        else {
          $('#note_' + updated_note.id).replaceWith(createNoteDiv($image, updated_note));
        }
      });

      $image.bind('note_deleted', function(event, data) {
        if (options.ajax) {
          ajaxDelete(fridge_id, data.note, function() {
            $('#note_' + data.note.id).remove();
          });
        }
        else {
          $('#note_' + data.note.id).remove();
        }
      });

      if (options.ajax) {
        $.ajax({
          url: "/fridges/" + fridge_id + "/notes",
          success: function(data) {
            $image.trigger('notes_available', { notes: $.map(data, function(item) {
              item.note.editable = true;
              return item.note;
            }) });
          }
        });
      }
    });

    function createNoteDiv(image, note) {
      var thumb = $("<div class='note_image'/>").css('height', note.height).css('width', note.width)
        .css('background-image', "url(" + image.attr('src') + ")")
        .css('background-position', (image.width() - note.left) + "px " + (image.height() - note.top) + "px");
      var text = $("<p>" + note.text + "</p>");
      return $("<div class='note_detail clearfix'/>").attr('id', 'note_' + note.id).append(thumb).append(text);
    }

    function ajaxCreate(fridge_id, note, successHandler) {
      $.ajax({
        url: "/fridges/" + fridge_id + "/notes",
        type: "POST",
        data: {
          note: {
            top: note.top,
            left: note.left,
            width: note.width,
            height: note.height,
            text: note.text
          }
        },
        success: successHandler
      });
    }

    function ajaxDelete(fridge_id, note, successHandler) {
      $.ajax({
        url: "/fridges/" + fridge_id + "/notes/" + note.id,
        type: "POST",
        data: {
          _method: 'DELETE'
        },
        success: successHandler
      });
    }
  }
})(jQuery);