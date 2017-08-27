require 'nokogiri'
require 'open-uri'
require 'scraper/extends'

module Scraper
  class CrawlRestaurants
    def exec
      for i in 1..3
        page = page.to_i + i
        index_html = Nokogiri::HTML.parse(open("https://tabelog.com/tokyo/A1303/A130301/R4698/rstLst/#{page}/?Srt=D&SrtT=rt&sort_mode=1&svd=20170827&svt=1900&svps=2"), nil, nil)
        results = []
        restaurants = index_html.css('.list-rst__wrap.js-open-new-window').map { |restaurant| [restaurant.css('.list-rst__rst-name-target.cpy-rst-name.js-ranking-num').text, restaurant.css('.list-rst__rst-name-target.cpy-rst-name.js-ranking-num').attr('href').text, restaurant.css('.list-rst__area-genre.cpy-area-genre').text]}
        restaurants.each do |restaurant|
          result = {}
          result['name'] = restaurant[0]
          show_url = restaurant[1]
          result['site_url'] = restaurant[1]
          show_html = Nokogiri::HTML.parse(open(show_url), nil, nil)
          result["telephone"] = show_html.css('.rstdtl-side-yoyaku__tel-number').text.clean_up
          results << result
        end
        results.each do |datum|
          ar = Restaurant.find_or_initialize_by(name: datum["title"])
          ar.update!(datum)
        end
      end
    end
  end
end
