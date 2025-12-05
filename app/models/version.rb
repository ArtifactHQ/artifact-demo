class Version < ApplicationRecord
  belongs_to :document

  validates :version_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[draft committed deployed rolled_back] }
  validates :version_number, uniqueness: { scope: :document_id }

  scope :committed, -> { where(status: 'committed') }
  scope :deployed, -> { where(status: 'deployed') }
  scope :ordered, -> { order(version_number: :desc) }

  def deploy!
    update!(status: 'deployed', committed_at: Time.current) unless deployed?
  end

  def deployed?
    status == 'deployed'
  end

  def rollback!
    update!(status: 'rolled_back') if deployed?
  end
end
