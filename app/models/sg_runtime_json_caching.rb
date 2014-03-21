module SgRuntimeJsonCaching
  CACHE_DIR = "#{Rails.root.to_s}/public/"
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
end


