require_relative 'get_page'
require_relative 'read_file'
require_relative 'voted'



class GetAllVotes
  def self.votes(url, cadent)

    file_path = "http://www.vmr.gov.ua#{url}"

     p file_path
     file_name = "#{File.dirname(__FILE__)}/../files/download/#{cadent.gsub(' ', '_')}"
     if (!File.exists?(file_name) || File.zero?(file_name))
        puts ">>>>  File not found, Downloading...."
        File.write(file_name, open(file_path).read)
        p "end load"
     end

       ReadFile.new.pdf(file_name).each_with_index do |vot, ind|
          number = ind + 1
          event = VoteEvent.first(name: vot[:name], date_vote: vot[:datetime], number: number, date_caden: cadent, rada_id: 5, option: vot[:result])
          if event.nil?
            events = VoteEvent.new(name: vot[:name], date_vote: vot[:datetime], number: number, date_caden: cadent, rada_id: 5, option: vot[:result])
            events.date_created = Date.today
            events.save
          else
            events = event
            events.votes.destroy!
          end
          unless vot[:vote].empty?
            vot[:vote].each do |v|
              vote = events.votes.new
              vote.voter_id = v[:voter_id]
              vote.result = v[:result]
              vote.save
            end
          end
       end
  end
end
# $all_mp = GetMp.new
# ReadFile.new.pdf("#{File.dirname(__FILE__)}/../files/download/Результати_поіменного_голосування.​pdf")