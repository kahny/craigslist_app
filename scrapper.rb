# scrapper.rb
require 'nokogiri'
require 'open-uri'
require 'awesome_print'


def get_dog_rows(rows, regex) #  matches = row.match(\b(dog|pup|puppies|dog)\b)

  # takes in rows and returns uses
  # regex to only return links
  # that have "pup", "puppy", or "dog"
  # keywords
  # get_page_results()
  rows.css(".hdrlnk").select do |row|
    matches = row.text.match(regex)
  end
end


def get_todays_rows(doc, date_str)
  #  1.) open chrome console to look in inside p.row to see
  #  if there is some internal date related content
  #  2.) figure out the class that you'll need to select the
  #   date from a row
  results = []
  doc.css(".row").each do |row|
    matches = row.css(".date").text.match(date_str)
    if matches && matches.length == 1
     results.push(row)
    end
  end
  results
end

def get_page_results
  url = "http://sfbay.craigslist.org/sfc/pet/"
  Nokogiri::HTML(open(url))
end

def search(date_str)

  doc = get_page_results()
  rows = get_todays_rows(doc, date_str)
  # puts rows
  regex =  /\b(puppy|pup|puppies|dog)\b/     #(\b(dog|pup|puppies|dog)\b)
  dog_rows = get_dog_rows(doc, regex)
  # puts dog_rows
  dogresults = []
  dog_rows.each do |row|
    linkanddescription = {link: row["href"], description: row.text}
    dogresults.push(linkanddescription)
  end
  ap dogresults
end

# want to learn more about
# Time in ruby??
#   http://www.ruby-doc.org/stdlib-1.9.3/libdoc/date/rdoc/Date.html#strftime-method
today = Time.now.strftime("%b %d")
search(today)
