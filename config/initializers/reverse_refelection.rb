class ActiveRecord::Base
  class << self
    def reverse_association_of(association, reverse_association)
      rev_klass, rev_association = reverse_association.split('#')
      @reverse_reflection_map ||= {}
      @reverse_reflection_map[association] = {
        :klass => rev_klass,
        :association => rev_association.to_sym
        }
    end

    def reverse_reflection_with_explicit(association)
      if @reverse_reflection_map && rev_reflection = @reverse_reflection_map[association.to_sym]
        rev_reflection[:klass].constantize.reflections[rev_reflection[:association]]
      else
        self.reverse_reflection_without_explicit(association)
      end
    end

    def hobo_model_with_explicit_reversing
      hobo_model_without_explicit_reversing
      # this has to be here after the hobo_model call
      # otherwise the reverse_reflection method
      # won't exist yet
      class << self
        alias_method_chain :reverse_reflection, :explicit
      end
    end

    alias_method_chain :hobo_model, :explicit_reversing
  end
end