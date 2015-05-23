class Document < ActiveRecord::Base
  belongs_to :user

  has_paper_trail

  # ensure that a user_id is present
  validates :user_id, presence: true
  # ensure that title is present and at least 2 chars long
  validates :title, length: { minimum: 2 }, presence: true
  # ensure that content is present and at between 10 and 10000 chars long
  validates :content, length: { minimum: 10, maximum: 10_000 }, presence: true
  def self.search(search)
    where("content LIKE ?", "%#{search}%")
  end

  def remove_html_tags
    re = /<("[^"]*"|'[^']*'|[^'">])*>/
    self.title.gsub!(re, '')
    self.description.gsub!(re, '')
  end

  #return the occurences of a word
  def self.count_occurences(key)
    re = /<("[^"]*"|'[^']*'|[^'">])*>/
    result = Hash.new(0)
    Document.all.find_each do |document|
      document.content.split.each do |word|
        word = word.downcase
        word = word.gsub(re,'')
        result[word] += 1 if word == key.downcase
      end
    end
    result[key]
  end
end
