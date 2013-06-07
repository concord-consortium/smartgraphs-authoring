module SmartGraphs
  module Generators
    class SequenceTitleGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def instruction_sequence_title
        InstructionSequence.all.each do |is|
          # set the title attribute from the first 5 words of the text
          # if the title does *not* exist.
          if is.title.blank?
            # title =  ActionView::Base.full_sanitizer.sanitize(is.text)[/(\w*\W+){#{5}}/] if is.text.present?
            title =  ActionView::Base.full_sanitizer.sanitize(is.text).split[0..5].join(" ") if is.text.present?
            puts "Generating a title \"#{title}\" for InstructionSequence with id = \"#{is.id}\""
            is.title = title
            is.save!
          end
        end
      end
    end
  end
end
