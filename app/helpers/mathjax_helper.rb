module MathjaxHelper
  def mathjax_tags
    return <<-EOF
      <script type="text/javascript"
              src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
      </script>
    EOF
  end
  def tinymce_tags
    return <<-EOF
      <script src="/javascripts/tinymce/tinymce.min.js"></script>
      <script>
              tinymce.init({
                plugins: [ "image", "link", "maths"],
                menu: {},
                toolbar: "undo redo | bullist numlist | outdent indent blockquote " +
                         "| bold italic | subscript superscript | " +
                         "| mathblock sqrt prod sum fraction | link image",
                selector:'textarea'
              });
      </script>
    EOF
  end
end
