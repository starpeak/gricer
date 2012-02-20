namespace :db do
  namespace :migrate do
    desc 'Migrate all databases for test' 
    task :test => [:environment] do
      puts Gricer::config.table_name_prefix
      
      [:test, :test_pg].each do |db_config|
        puts "\n\nUsing #{db_config}\n\n"
        ActiveRecord::Base.establish_connection db_config
        Rake::Task["app:db:migrate"].reenable
        Rake::Task["app:gricer:db:migrate"].reenable
        Rake::Task["app:gricer:db:prepare_namespace"].reenable
        Rake::Task["app:gricer:db:remove_namespace"].reenable
        Rake::Task["app:db:migrate"].invoke
        Rake::Task["app:db:test:prepare"].execute
      end
    end
  end
end
