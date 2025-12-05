class Document < ApplicationRecord
  belongs_to :project
  has_many :versions, dependent: :destroy

  validates :title, presence: true
  validates :document_type, presence: true, inclusion: { 
    in: %w[specification feature component page api database] 
  }

  scope :recent, -> { order(updated_at: :desc) }
  scope :by_type, ->(type) { where(document_type: type) }

  after_create :create_initial_version

  def current_version
    versions.order(version_number: :desc).first
  end

  def version_count
    versions.count
  end

  def create_new_version(commit_message:)
    next_version_number = versions.maximum(:version_number).to_i + 1
    versions.create!(
      version_number: next_version_number,
      content: content,
      commit_message: commit_message,
      committed_at: Time.current,
      status: 'committed'
    )
  end

  private

  def create_initial_version
    versions.create!(
      version_number: 1,
      content: content,
      commit_message: 'Initial version',
      committed_at: Time.current,
      status: 'draft'
    )
  end
end
