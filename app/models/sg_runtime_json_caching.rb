module SgRuntimeJsonCaching
  CACHE_DIR = "#{Rails.root.to_s}/public/"
  RUNTIME_TEMPLATE = "#{CACHE_DIR}/smartgraphs-runtime.html"

  def json_cache_path
    base = self.class.name.underscore.pluralize
    # to_param is part of hobo_model http://hobocentral.net/manual/model
    "#{CACHE_DIR}/#{base}/#{to_param}"
  end

  def cached_files
    %w[author_preview.html student_preview.html]
  end

  def delete_cache_entries
    cached_files.each do |file|
      path = "#{json_cache_path}/#{file}"
      File.delete(path) if File.exists?(path)
    end
  end

  def json
    JSON.pretty_generate(self.to_hash)
  end
  def runtime_json
    text= Converter.new().convert(json).output
    struct = JSON.parse(text)
    JSON.pretty_generate(struct)
  end

  def student_runtime_html
    runtime_html
  end

  def author_runtime_html
    runtime_html(true,true)
  end

  def runtime_html(show_outline = false, show_edit_button = false)
    authored_activity_json = runtime_json
    template = ERB.new(File.read(RUNTIME_TEMPLATE))
    result = template.result(binding)
    result
  end
end


