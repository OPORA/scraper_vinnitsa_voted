require_relative 'lib/voted'
require_relative 'lib/scrape_all_page'
desc 'Create databases'
task :create_db do
  DataMapper.auto_migrate!
end
desc 'Scrape voted'
task :scrape_voted, [:start_date, :end_date] do |t, arg|
 if arg[:start_date].nil?
   GetPages.new.get_all_votes
 elsif !arg[:end_date].nil?

 else

 end
end
