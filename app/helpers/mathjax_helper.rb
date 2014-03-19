module MathjaxHelper
  def mathjax_tags
    return <<-EOF
      <script type="text/javascript"
              src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML">
      </script>
    EOF
  end
end
