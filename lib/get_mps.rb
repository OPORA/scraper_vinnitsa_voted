require 'open-uri'
require 'json'
class GetMp
  def initialize
    @data_hash = JSON.load(open('https://scrapervinnitsadeputy.herokuapp.com/'))
  end
  def serch_mp(full_name)
    p full_name
   name =full_name.gsub(/[[:upper:]]/){|s|" "+s}.split(' ').join(' ').gsub(/[[:space:]][[:lower:]]/){|s| s.gsub(/\s/,'')}.gsub(/[a-zA-Z]/,'').gsub(/-$/,'')

    if name == "Базелюк Володимир Васильович"
      return 149
      #"Базелюк Володимир Васильович"
   elsif name == "Зєрщиков Олександр Володимирович" or name == "Зєрщиков Олесандр Володимирович"
      return 150
      #"Зєрщиков Олександр Володимирович"
   elsif name == "Іорданов Юрій Іванович" or name == "Іорданов Юрій Івичо" or name == "Іорданов Юрій Іович" or name == "Іорданов Юрій Іванчви" or name == "Іорданов Юрій Івавич" or name == "Іорданов Юрій Іввич" or name == "Іорданов Юрій Іанович" or name == "Іорданов Юрій Іваичв" or name == "Іорданов Юрі Іванович"
      return 151
      #"Іорданов Юрій Іванович"
   elsif name == "Кучерук Юрій Юрійович"
      return 1004
   elsif name == "Ткачук Ігор Вітаичйов" or name == "Ткачук Ігор Віович" or name == "Ткачук Ігор Віталчйови"
      return 119
   elsif name == "Мартинюк Віктор Миколвич" or name == "Мартинюк Віктор Миайович" or name == "Мартинюк Віктор Микйович" or name == "Мартинюк Віктор Микоович"
      return 105
   elsif name == "Алекса Олег Юрівич" or name == "Алекса Олег Юрійич" or name == "Алекса Олег Юрійочи" or name == "Алекса Олег Юріович" or name == "Алекса Олег Юрійовч"
      return 153
   elsif name == "Онофрійчук Водимир Володимирович" or name == "Онофрійчук Волдимир Володимирович"
      return 90
   elsif name == "Кудіяров Вадим Іович" or name == "Кудіяров Вадим Ігович"
      return 104
   elsif name == "Андронйічук Роман Степанович"
      return 92
   elsif name == "Гройсман Борис Іакович" or name == "Гройсман Борис Ісакович"
      return 141
   elsif name == "Моргунов Сергій Анатолійовичwwm"
      return 1111
   end
   data = @data_hash.find {|k| k["full_name"] == name  }
   unless data.nil?
     return data["deputy_id"]
   else
     raise name
   end
  end
end
