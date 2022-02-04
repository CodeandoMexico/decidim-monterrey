require 'clockwork'
require 'rake'
require 'active_support/time'
require File.expand_path('../application.rb', __FILE__)

Rake::Task.clear
DecidimMonterrey::Application.load_tasks

module Clockwork
  # See  https://docs.decidim.org/en/install/#scheduled_tasks
  DECIDIM_TASKS = [
    'decidim:delete_data_portability_files',
    'decidim:metrics:all',
    'decidim:open_data:export',
    'decidim_meetings:clean_registration_forms',
    # NOTE: Reminders task is currently unavaliable in our Decidim version and
    #       it hasn't been relased in any officila version. To get it we'd
    #       need to point to master-branch, but we can hold as is for now.
    # 'decidim:reminders:all'
  ]

  every(1.day, 'midnight jobs', at: '**:00', tz: 'America/Mexico_City') do
    DECIDIM_TASKS.each do |task|
      puts "Starting: #{task}"
      Rake::Task[task].invoke
      puts "Finished: #{task}"
    end
  end
end
