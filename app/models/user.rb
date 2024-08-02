class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :links, dependent: :destroy
  has_many :achievements, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :full_name, presence: true

  before_validation :set_default_username, on: :create

  serialize :tags, JSON

  def parsed_tags
    if tags.is_a?(String)
      begin
        JSON.parse(tags)
      rescue JSON::ParserError
        []
      end
    else
      tags
    end
  end

  private

  def set_default_username
    self.username ||= email.split('@').first
  end
end
