module SgSequencePrompts

  def add_visual_prompt(definition,p_name=nil)
    klass_name  = definition['type']
    klass       = klass_name.constantize
    klass_name.underscore.pluralize
    prompt      = klass.from_hash(definition)
    method_name = klass_name.underscore.pluralize
    method_name = "#{p_name}_#{method_name}" unless p_name.nil?
    self.send(method_name) <<  prompt
  end

  def add_visual_prompts(definition,p_name)
    return unless definition['visualPrompts']
    definition['visualPrompts'].each do |d|
      add_visual_prompt(d,p_name)
    end
  end

  def initial_prompt_from_hash(defs)
    self.initial_prompt = defs['text']
    self.title          = defs['text']
    add_visual_prompts(defs,'initial')
  end

  def give_up_from_hash(defs)
    self.give_up = defs['text']
    add_visual_prompts(defs,'give_up')
  end

  def confirm_correct_from_hash(defs)
    self.confirm_correct = defs['text']
    add_visual_prompts(defs,'confirm_correct')
  end
  # unless sequence_hints.empty?
  #   hash['hints'] = sequence_hints.map do |sequence_hint|
  #     sequence_hint.hint.to_hash
  #   end
  # end
  #
  #   has_many :text_hints, :through => :sequence_hints, :source => :hint, :source_type => 'TextHint'
  #
  def hints_from_hash(defs)
    defs.each do |definition|
      self.text_hints << TextHint.from_hash(definition)
    end
  end

  def visual_prompts_from_hash(defs)
    defs.each do |definition|
      add_visual_prompt(definition,nil)
    end
  end
end