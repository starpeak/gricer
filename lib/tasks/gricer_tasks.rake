namespace :gricer do  
  if Gricer.config.model_type == :ActiveRecord and defined?(::ActiveRecord) 
    namespace :db do
      desc "Migrate the database through scripts in db/migrate and update db/schema.rb by invoking db:schema:dump. Target specific version with VERSION=x. Turn off output with VERBOSE=false."
      task :migrate => [:environment, :prepare_namespace] do
        ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
        ActiveRecord::Migrator.migrate("#{File.dirname(__FILE__)}/../../db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
        Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
      end
    
      task :prepare_namespace do
        require 'active_record'
        puts 'prepage gricer table_name_prefix'
        # ActiveRecord::Base.configurations = Rails::Application.config.database_configuration
      
        class ActiveRecord::Base
          self.table_name_prefix = "#{::ActiveRecord::Base.table_name_prefix}#{Gricer::config.table_name_prefix}"
        end
      end
    
      task :remove_namespace do
        puts 'remove gricer table_name_prefix'
      
        class ActiveRecord::Base
          self.table_name_prefix = "#{::ActiveRecord::Base.table_name_prefix[Gricer::config.table_name_prefix.length,1000]}"
        end
      end
  
      namespace :migrate do
        desc 'Rollbacks the database one migration and re migrate up. If you want to rollback more than one step, define STEP=x. Target specific version with VERSION=x.'
        task :redo => [:environment, :prepare_namespace] do
          if ENV["VERSION"]
            Rake::Task["gricer:db:migrate:down"].invoke
            Rake::Task["gricer:db:migrate:up"].invoke
          else
            Rake::Task["gricer:db:rollback"].invoke
            Rake::Task["gricer:db:migrate"].invoke
          end
        end

        desc 'Runs the "up" for a given migration VERSION.'
        task :up => [:environment, :prepare_namespace] do
          version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
          raise "VERSION is required" unless version
          ActiveRecord::Migrator.run(:up, "#{File.dirname(__FILE__)}/../../db/migrate/", version)
          Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
        end

        desc 'Runs the "down" for a given migration VERSION.'
        task :down => [:environment, :prepare_namespace] do
          version = ENV["VERSION"] ? ENV["VERSION"].to_i : nil
          raise "VERSION is required" unless version
          ActiveRecord::Migrator.run(:down, "#{File.dirname(__FILE__)}/../../db/migrate/", version)
          Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
        end
      end

      desc 'Rolls the schema back to the previous version. Specify the number of steps with STEP=n'
      task :rollback => [:environment, :prepare_namespace] do
        step = ENV['STEP'] ? ENV['STEP'].to_i : 1
        ActiveRecord::Migrator.rollback("#{File.dirname(__FILE__)}/../../db/migrate/", step)
        Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
      end

      desc 'Pushes the schema to the next version. Specify the number of steps with STEP=n'
      task :forward => [:environment, :prepare_namespace] do
        step = ENV['STEP'] ? ENV['STEP'].to_i : 1
        ActiveRecord::Migrator.forward("#{File.dirname(__FILE__)}/../../db/migrate/", step)
        Rake::Task["db:schema:dump"].invoke if ActiveRecord::Base.schema_format == :ruby
      end

      desc "Retrieves the current schema version number"
      task :version => [:environment, :prepare_namespace] do
        puts "Current version: #{ActiveRecord::Migrator.current_version}"
      end

      desc "Raises an error if there are pending migrations"
      task :abort_if_pending_migrations => [:environment, :prepare_namespace] do
        if defined? ActiveRecord
          pending_migrations = ActiveRecord::Migrator.new(:up, "#{File.dirname(__FILE__)}/../../db/migrate/").pending_migrations
          if pending_migrations.any?
            puts "You have #{pending_migrations.size} pending migrations:"
            pending_migrations.each do |pending_migration|
              puts '  %4d %s' % [pending_migration.version, pending_migration.name]
            end
            abort %{Run "rake gricer:db:migrate" to update your database then try again.}
          end
        end
      end
    end
  elsif Gricer.config.model_type == :Mongoid 
    desc 'There are no gricer:db tasks yet when running on MongoId.'
    task :db do
      abort %{There are no gricer:db tasks yet when running on MongoId.}
    end
  end
  
  namespace :mailer do
    desc 'There are no gricer:mailer tasks yet.'
    task :not_yet do
      abort %{There are no gricer:mailer tasks yet.}
    end
  end
  
  desc 'test'
  task Gricer.config.model_type do
  end
end

task :'db:migrate' => [:'gricer:db:migrate', :'gricer:db:remove_namespace'] if defined? ::ActiveRecord and Gricer.config.model_type == :ActiveRecord