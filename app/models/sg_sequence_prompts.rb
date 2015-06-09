module SgSequencePrompts

  def add_visual_prompt(definition,p_name=nil)
    # Hack! for confirm_correct:
    # asscns are confirm_visual_prompt_types not confirm_correct_vis..
    _p_name = p_name.gsub(/_correct/,"") unless p_name.nil?

    klass_name  = definition['type']
    klass       = klass_name.constantize
    klass_name.underscore.pluralize
    prompt      = klass.from_hash(definition,self.marshal_context)
    method_name = klass_name.underscore.pluralize
    method_name = "#{_p_name}_#{method_name}" unless _p_name.nil?
    self.send(method_name) <<  prompt
  end

  def add_visual_prompts(definition,p_name)
    return unless definition['visualPrompts']
    definition['visualPrompts'].each do |d|
      add_visual_prompt(d,p_name)
    end
  end

  def initial_prompt_from_hash(defs)
    if self.respond_to?(:answer_with_label) && defs['label']
      self.answer_with_label = true
    end
    prompt = defs['text']
    unless prompt.blank?
      self.initial_prompt = prompt
      if self.respond_to?(:title)
        if self.title.blank?
          # title is DB constrainted to 255 chars.
          self.title = prompt.runcate(255)
        end
      end
    end
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

  def hints_from_hash(defs)
    defs.each do |definition|
      self.text_hints << TextHint.from_hash(definition,self.marshal_context)
    end
  end

  def visual_prompts_from_hash(defs)
    defs.each do |definition|
      add_visual_prompt(definition,nil)
    end
  end

  def update_sequence_prompts(hash)
    unless hash['type'] == 'MultipleChoiceWithCustomHintsSequence' || hash['type'] == 'MultipleChoiceWithSequentialHintsSequence'
      hash['hints'] = sequence_hints.map do |sequence_hint|
        sequence_hint.hint.to_hash
      end
    end
    unless initial_prompt_prompts.empty?
      hash['initialPrompt']['visualPrompts'] = initial_prompt_prompts.map {|p| p.prompt.to_hash }
    end
    unless give_up_prompts.empty?
      hash['giveUp']['visualPrompts'] = give_up_prompts.map {|p| p.prompt.to_hash }
    end
    unless confirm_correct_prompts.empty?
      hash['confirmCorrect']['visualPrompts'] = confirm_correct_prompts.map {|p| p.prompt.to_hash }
    end
  end

end
