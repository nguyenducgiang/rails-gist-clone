class Gist < ActiveRecord::Base
  validates :content, :description, presence: true

  default_scope  { order(created_at: :desc) }
  scope :opened, -> { where(private: false) }
  scope :closed, -> { where(private: true) }

  belongs_to :user
  has_many :comments

  def highlighted(lines: :all)
    code = if lines == :all
      content
    else 
      content.split("\n").take(lines).join("\n")
    end

    if language.blank?
      Pygments.highlight(code, options: {encoding: 'utf-8'}).html_safe
    else
      Pygments.highlight(code, 
        lexer: Pygments.lexers[language][:aliases][0], 
        options: {encoding: 'utf-8'}).html_safe
    end
  end
end
