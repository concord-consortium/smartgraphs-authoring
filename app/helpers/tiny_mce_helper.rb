module TinyMceHelper
  def tinymce_tags
    return <<-EOF
      <script src="/javascripts/tinymce/tinymce.min.js"></script>
      <script>
              tinymce.init({
                plugins: [ "image", "link", "paste", "code"],
                menu: {},
                toolbar: " styleselect | bullist numlist | outdent indent " +
                         "| bold italic | subscript superscript " +
                         "| pastetext pasteword | link image | > code ",
                statusbar : false,
                style_formats: [
                        {title: 'regular', block: 'p'},
                        {title: 'big', block: 'h2'},
                        {title: 'huge', block: 'h1'},
                ],
                selector:'textarea:not(.data-tag)'
              });
      </script>
    EOF
  end
end
