module SgActivityCaching
  CACHE_DIR = "#{Rails.root.to_s}/public/"
  RUNTIME_TEMPLATE = "#{CACHE_DIR}/smartgraphs-runtime.html"

  def cache_path(filename)
    base = self.class.name.underscore.pluralize
    # to_param is part of hobo_model http://hobocentral.net/manual/model
    "#{CACHE_DIR}/#{base}/#{to_param}/#{filename}"
  end

  def cached_files
    %w[author_preview.html student_preview.html]
  end

  def delete_cache_entries
    cached_files.each do |file|
      path = cache_path(file)
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

  def student_runtime_html(lang='en')
    result = runtime_html(false,false,lang)
    cache(result,"student_preview.#{lang}.html")
    result
  end

  def author_runtime_html(lang='en')
    result = runtime_html(true,true,lang)
    cache(result,"author_preview.#{lang}.html")
    result
  end

  def cache_runtimes(langs=['en','es'])
    langs.each do |lang|
      author_runtime_html(lang)
      student_runtime_html(lang)
    end
  end

  def runtime_html(show_outline = false, show_edit_button = false,lang='en')
    authored_activity_json = runtime_json
    template = ERB.new(File.read(RUNTIME_TEMPLATE))
    result = template.result(binding)
    result
  end

  def cache(content,name)
    path = cache_path(name)
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, 'w') do | file|
      file.write(content)
    end
  end
end


