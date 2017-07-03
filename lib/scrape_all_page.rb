require_relative 'get_page'
require_relative 'scrape_all_votes'
require_relative 'get_mps'


class GetPages
  def initialize
    $all_mp = GetMp.new
    @all_page = []
    url = "http://www.vmr.gov.ua/Lists/CityCouncil/ShowContent.aspx?ID=55"
    page = GetPage.page(url)
    page.css('.content-inner div a').each do |a|
      next unless a.text[/^Результати/]
      @all_page << { caden: a.text, url: a[:href] }
    end
  end
  def get_all_votes
    @all_page.each do |p|
      next if p[:caden] == "Результати поіменного голосування 19 сесії  7 скликання.pdf"
      next if p[:caden] == "Результати поіменного голосування 18 сесії  7 скликання.pdf"
      next if p[:caden] == "Результати поіменного голосування 17 сесії  7 скликання.pdf"
      p p[:caden]
      GetAllVotes.votes(p[:url], p[:caden])
    end
  end
end
