class Link < ActiveRecord::Base
  # Relations
  belongs_to :compilation

  # Validations
  validates :url, presence: true

  # Scopes
  scope :approved, -> { where(approved: true) }
  scope :unused, -> { where(compilation_id: nil) }

  # Callback. 
  after_update :publish_tweet, if: Proc.new { |link| 
    Rails.configuration.tweet_approved_links &&
    link.approved_changed? && 
    link.approved == true
  }

  def self.discover(unknown_url)
    inspector = MetaInspector.new(unknown_url, allow_redirections: :all)
    {
      url: inspector.url, 
      title: inspector.title,
      description: inspector.meta['description']
    }
  end

  def publish_tweet
    TweetLinkWorker.perform_async(self.id)
  end
end
