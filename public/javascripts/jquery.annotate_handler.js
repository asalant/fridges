(function($) {

  $.fn.annotateHandler = function(options) {
    return this.each(function() {
      $image = $(this);
      var next_id = 0;
      
      $image.bind('notes_available', function(event, data) {
        next_id = data.notes.length + 1;
        $.each(data.notes, function(index, value) {
          $(options.target).append(createNote($image, value));
        });
      });

      $image.bind('note_added', function(event, data) {
        data.note.id = next_id++;
        $(options.target).append(createNote($image, data.note));
      });

      $image.bind('note_updated', function(event, data) {
        $('#note_' + data.note.id).replaceWith(createNote($image, data.note));
      });

      $image.bind('note_deleted', function(event, data) {
        $('#note_' + data.note.id).remove();
      });

      function createNote(image, note) {
        var thumb = $("<div class='note_image'/>").css('height', note.height).css('width', note.width)
          .css('background-image', "url(" + image.attr('src') + ")")
          .css('background-position', (image.width() - note.left) + "px " + (image.height() - note.top) + "px");
        var text = $("<p>" + note.text + "</p>");
        return $("<div class='note_detail clearfix'/>").attr('id', 'note_' + note.id).append(thumb).append(text);
      }
    });
  }
})(jQuery);