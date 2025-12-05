class Project < ApplicationRecord
  has_many :documents, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[draft active archived] }

  scope :active, -> { where(status: 'active') }
  scope :recent, -> { order(updated_at: :desc) }

  def document_count
    documents.count
  end

  def latest_document
    documents.order(updated_at: :desc).first
  end
end
