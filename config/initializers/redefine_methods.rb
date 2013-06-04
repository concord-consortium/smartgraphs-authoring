if File.basename($0) == "rake"
  # only for rake tasks
  if ARGV.grep(/^db\:.*/)
    # that start with db:, db:migrate, db:load, etc.

    # this is a problem with the csv_pirate gem
    # it blows up when the a model's table doesn't exist in the DB
    module CsvPirate::PirateShip::ActMethods
      puts 'WARNING: removed method "prevent_from_fail_pre_migration for rake tasks'
      def prevent_from_failing_pre_migration
        return false
      end
    end
  end
end
