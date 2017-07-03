require 'pdf-reader'
require_relative 'get_mps'

class ReadFile
  def pdf(file_name)
    votes = []
    reader = PDF::Reader.new(file_name)
    # pages = []
    reader.pages.each do |page|
      page.text.split(/\n/).each do |row|
        next if row == ""
        next if row[/Прізвище, Ім'я, По-батькові/]
        next if row[/PD-OOS/]
        next if row[/Click to\.buy NOW!/]
        str = row.strip.gsub(/\s{2,}/, ' ')
        next if str[/^Рішення ухвалює/]
        next if str == "СКЛАДУ"
        if str[/(^В С Ь О Г:О|^УСЬОГО:|^ВСЬОГО:|^ВСЬО Г О :|ВС Ь О Г :|ВСЬ О Г О:|ВСЬОГ О:)/]
          votes.last[:result] = 1
        end
        if str == "місто"
          votes << {}
        end
        next if votes.empty?
        if votes.last[:result].nil? and str[/(ВСЬОГО ПРОГОЛОСУВАЛО:|УСЬОГО ПРОГОЛОСУВАЛО:)/]
          votes.last[:result] = 1
        end
        if str[/^від.+/] and votes.last.empty?
          votes.last[:datetime] = str[/^від.+/].gsub(/від/,'').strip
        elsif str[/(Питання №|Питання№|Пииання №)/]
          votes.last[:vote] = []
        elsif votes.last[:datetime] and votes.last[:vote].nil?
          next if str[/^\d{1,2}\.\d{1,2}\.\d{4}/] and votes.last[:name].nil?
          if votes.last[:name].nil?
            votes.last[:name] = str
          else
            votes.last[:name] = votes.last[:name] + " " + str
          end
        elsif votes.last[:result] == 1 and str[/^РІШЕННЯ/]
          votes.last[:result] = str
        end
        if votes.last[:vote] and votes.last[:result].nil?
          result = str[/(ЗА|ПРОТИ|відсутній|УТРИМАВСЯ|НЕ ГОЛОСУВАВ)/]
          name = str.gsub(/(ЗА|ПРОТИ|відсутній|УТРИМАВСЯ|НЕ ГОЛОСУВАВ)/,'')[/[[:upper:]].+[[:upper:]].+[[:upper:]].+/]
          unless name.nil?
            voter_id = $all_mp.serch_mp(name.strip)
            votes.last[:vote] << { voter_id: voter_id}
          end
          unless result.nil?
            votes.last[:vote].last[:result] = short_voted_result(result)
          end
        end
        p str
        p votes
        p ">>>"
      end
       p ""
    end
    return votes
  end
  def short_voted_result(result)
    hash = {
        "НЕ ГОЛОСУВАВ":  "not_voted",
        відсутній: "absent",
        ПРОТИ:  "against",
        ЗА: "aye",
        УТРИМАВСЯ: "abstain"
    }
    hash[:"#{result}"]
  end
end
