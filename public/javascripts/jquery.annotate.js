/**
 * Based on http://code.google.com/p/jquery-image-annotate/
 * Also see http://www.flipbit.co.uk/jquery-image-annotation.html
 */
(function($) {

  $.fn.annotateImage = function(options) {
    ///	<summary>
    ///		Creates annotations on the given image.
    ///     Images are loaded from the "getUrl" property passed into the options.
    ///	</summary>
    var opts = $.extend({}, { editable: false }, options);
    var $image = this;

    $image.image = this;
    $image.mode = 'view';

    // Assign defaults
    $image.editable = opts.editable;

    // Add the canvas
    $image.canvas = $('<div class="image-annotate-canvas"><div class="image-annotate-view"></div><div class="image-annotate-edit"><div class="image-annotate-edit-area"></div></div></div>');
    $image.canvas.children('.image-annotate-edit').hide();
    $image.canvas.children('.image-annotate-view').hide();
    $image.image.after($image.canvas);

    // Give the canvas and the container their size and background
    $image.canvas.height($image.height());
    $image.canvas.width($image.width());
    $image.canvas.css('background-image', 'url("' + $image.attr('src') + '")');
    $image.canvas.children('.image-annotate-view, .image-annotate-edit').height($image.height());
    $image.canvas.children('.image-annotate-view, .image-annotate-edit').width($image.width());

    // Add the behavior: hide/show the notes when hovering the picture
    $image.canvas.hover(function() {
      if ($(this).children('.image-annotate-edit').css('display') == 'none') {
        $(this).children('.image-annotate-view').show();
      }
    }, function() {
      $(this).children('.image-annotate-view').hide();
    });

    $image.canvas.children('.image-annotate-view').hover(function() {
      $(this).show();
    }, function() {
      $(this).hide();
    });

    // Add the "Add a note" button
    if ($image.editable) {
      $image.canvas.after('<a class="image-annotate-add" id="image-annotate-add" href="#">Add Note</a>');
    }
    $('.image-annotate-add').click(function() {
      $image.trigger('add_note');
    });

    // Register handlers
    $image.bind('notes_available', function(event, data) {
      $.fn.annotateImage.load($image, data.notes);
    });
    $image.bind('add_note', function(event, data) {
      $.fn.annotateImage.add($image);
    });
    $image.bind('cancel_note', function(event, data) {
      data.editable.destroy();
      $image.mode = 'view';
    });
    $image.bind('save_note', function(event, data) {
      var text = $('#image-annotate-text').val();
      $image.mode = 'view';

      // Add to canvas
      if (data.note) {
        data.note.resetPosition(data.editable, text);

        $image.trigger('note_updated', { note: data.editable.note });
      } else {
        data.editable.note.editable = true;
        data.note = new $.fn.annotateView($image, data.editable.note)
        data.note.resetPosition(data.editable, text);

        $image.trigger('note_added', { note: data.editable.note });
      }

      data.editable.destroy();
    });

    // Hide the original
    $image.hide();

    return $image;
  };

  $.fn.annotateImage.load = function(image, notes) {
    ///	<summary>
    ///		Loads the annotations from the notes property passed in on the
    ///     options object.
    ///	</summary>
    for (var i = 0; i < notes.length; i++) {
      new $.fn.annotateView(image, notes[i]);
    }

    image.trigger("notes_loaded", { notes: notes });
  };

  $.fn.annotateImage.add = function(image) {
    ///	<summary>
    ///		Adds a note to the image.
    ///	</summary>
    if (image.mode == 'view') {
      image.mode = 'edit';

      // Create/prepare the editable note elements
      var editable = new $.fn.annotateEdit(image);

      $.fn.annotateImage.createSaveButton(editable, image);
      $.fn.annotateImage.createCancelButton(editable, image);
    }
  };

  $.fn.annotateImage.createSaveButton = function(editable, image, note) {
    ///	<summary>
    ///		Creates a Save button on the editable note.
    ///	</summary>
    var ok = $('<a class="image-annotate-edit-ok">OK</a>');

    ok.click(function() {
      image.trigger('save_note', { note: note, editable: editable });
    });
    editable.form.append(ok);
  };

  $.fn.annotateImage.createCancelButton = function(editable, image) {
    ///	<summary>
    ///		Creates a Cancel button on the editable note.
    ///	</summary>
    var cancel = $('<a class="image-annotate-edit-close">Cancel</a>');
    cancel.click(function() {
      image.trigger('cancel_note', { editable: editable });
    });
    editable.form.append(cancel);
  };

  $.fn.annotateEdit = function(image, note) {
    ///	<summary>
    ///		Defines an editable annotation area.
    ///	</summary>
    this.image = image;

    if (note) {
      this.note = note;
    } else {
      var newNote = new Object();
      newNote.id = "new";
      newNote.top = 30;
      newNote.left = 30;
      newNote.width = 30;
      newNote.height = 30;
      newNote.text = "";
      this.note = newNote;
    }

    // Set area
    var area = image.canvas.children('.image-annotate-edit').children('.image-annotate-edit-area');
    this.area = area;
    this.area.css('height', this.note.height + 'px');
    this.area.css('width', this.note.width + 'px');
    this.area.css('left', this.note.left + 'px');
    this.area.css('top', this.note.top + 'px');

    // Show the edition canvas and hide the view canvas
    image.canvas.children('.image-annotate-view').hide();
    image.canvas.children('.image-annotate-edit').show();

    // Add the note (which we'll load with the form afterwards)
    var form = $('<div id="image-annotate-edit-form"><form><textarea id="image-annotate-text" name="text" rows="3" cols="30">' + this.note.text + '</textarea></form></div>');
    this.form = form;

    $('body').append(this.form);
    this.form.css('left', this.area.offset().left + 'px');
    this.form.css('top', (parseInt(this.area.offset().top) + parseInt(this.area.height()) + 7) + 'px');

    // Set the area as a draggable/resizable element contained in the image canvas.
    // Would be better to use the containment option for resizable but buggy
    area.resizable({
      handles: 'all',

      stop: function(e, ui) {
        form.css('left', area.offset().left + 'px');
        form.css('top', (parseInt(area.offset().top) + parseInt(area.height()) + 2) + 'px');
      }
    })
      .draggable({
                   containment: image.canvas,
                   drag: function(e, ui) {
                     form.css('left', area.offset().left + 'px');
                     form.css('top', (parseInt(area.offset().top) + parseInt(area.height()) + 2) + 'px');
                   },
                   stop: function(e, ui) {
                     form.css('left', area.offset().left + 'px');
                     form.css('top', (parseInt(area.offset().top) + parseInt(area.height()) + 2) + 'px');
                   }
                 });
    return this;
  };

  $.fn.annotateEdit.prototype.destroy = function() {
    ///	<summary>
    ///		Destroys an editable annotation area.
    ///	</summary>
    this.image.canvas.children('.image-annotate-edit').hide();
    this.area.resizable('destroy');
    this.area.draggable('destroy');
    this.area.css('height', '');
    this.area.css('width', '');
    this.area.css('left', '');
    this.area.css('top', '');
    this.form.remove();
  };

  $.fn.annotateView = function(image, note) {
    ///	<summary>
    ///		Defines a annotation area.
    ///	</summary>
    this.image = image;

    this.note = note;

    this.editable = (note.editable && image.editable);

    // Add the area
    this.area = $('<div class="image-annotate-area' + (this.editable ? ' image-annotate-area-editable' : '') + '"><div></div></div>');
    image.canvas.children('.image-annotate-view').prepend(this.area);

    // Add the note
    this.form = $('<div class="image-annotate-note">' + note.text + '</div>');
    this.form.hide();
    image.canvas.children('.image-annotate-view').append(this.form);
    this.form.children('span.actions').hide();

    // Set the position and size of the note
    this.setPosition();

    // Add the behavior: hide/display the note when hovering the area
    var annotation = this;
    this.area.hover(function() {
      annotation.show();
    }, function() {
      annotation.hide();
    });

    // Edit a note feature
    if (this.editable) {
      var form = this;
      this.area.click(function() {
        form.edit();
      });
    }
  };

  $.fn.annotateView.prototype.setPosition = function() {
    ///	<summary>
    ///		Sets the position of an annotation.
    ///	</summary>
    this.area.children('div').height((parseInt(this.note.height) - 2) + 'px');
    this.area.children('div').width((parseInt(this.note.width) - 2) + 'px');
    this.area.css('left', (this.note.left) + 'px');
    this.area.css('top', (this.note.top) + 'px');
    this.form.css('left', (this.note.left) + 'px');
    this.form.css('top', (parseInt(this.note.top) + parseInt(this.note.height) + 7) + 'px');
  };

  $.fn.annotateView.prototype.show = function() {
    ///	<summary>
    ///		Highlights the annotation
    ///	</summary>
    this.form.fadeIn(250);
    if (!this.editable) {
      this.area.addClass('image-annotate-area-hover');
    } else {
      this.area.addClass('image-annotate-area-editable-hover');
    }
  };

  $.fn.annotateView.prototype.hide = function() {
    ///	<summary>
    ///		Removes the highlight from the annotation.
    ///	</summary>
    this.form.fadeOut(250);
    this.area.removeClass('image-annotate-area-hover');
    this.area.removeClass('image-annotate-area-editable-hover');
  };

  $.fn.annotateView.prototype.destroy = function() {
    ///	<summary>
    ///		Destroys the annotation.
    ///	</summary>
    this.area.remove();
    this.form.remove();
  }

  $.fn.annotateView.prototype.edit = function() {
    ///	<summary>
    ///		Edits the annotation.
    ///	</summary>
    if (this.image.mode == 'view') {
      this.image.mode = 'edit';
      var annotation = this;

      // Create/prepare the editable note elements
      var editable = new $.fn.annotateEdit(this.image, this.note);

      $.fn.annotateImage.createSaveButton(editable, this.image, annotation);

      // Add the delete button
      var del = $('<a class="image-annotate-edit-delete">Delete</a>');
      del.click(function() {
        annotation.image.mode = 'view';
        editable.destroy();
        annotation.destroy();

        annotation.image.trigger('note_deleted', { note: annotation.note });
      });
      editable.form.append(del);

      $.fn.annotateImage.createCancelButton(editable, this.image);
    }
  };

  $.fn.annotateView.prototype.resetPosition = function(editable, text) {
    ///	<summary>
    ///		Sets the position of an annotation.
    ///	</summary>
    this.form.html(text);
    this.form.hide();

    // Resize
    this.area.children('div').height(editable.area.height() + 'px');
    this.area.children('div').width((editable.area.width() - 2) + 'px');
    this.area.css('left', (editable.area.position().left) + 'px');
    this.area.css('top', (editable.area.position().top) + 'px');
    this.form.css('left', (editable.area.position().left) + 'px');
    this.form.css('top', (parseInt(editable.area.position().top) + parseInt(editable.area.height()) + 7) + 'px');

    // Save new position to note
    this.note.top = editable.area.position().top;
    this.note.left = editable.area.position().left;
    this.note.height = editable.area.height();
    this.note.width = editable.area.width();
    this.note.text = text;
    this.note.id = editable.note.id;
    this.editable = true;
  };

})(jQuery);