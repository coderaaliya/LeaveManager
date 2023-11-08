class User < ApplicationRecord
  has_many :leaves
  has_many :attendances
  has_one :employee

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { manager: 0, team_lead: 1, HR: 2, employee: 3 }

  belongs_to :manager, foreign_key: 'manager_id', class_name: 'User', optional: true
  has_many :subordinates, class_name: 'User', foreign_key: 'manager_id'

  belongs_to :team_lead, foreign_key: 'team_lead_id', class_name: 'User', optional: true
  has_many :team_members, class_name: 'User', foreign_key: 'team_lead_id'

  before_validation :set_manager_id, if: -> { manager_role? && manager_id.nil? }
  before_validation :set_team_lead_id, if: -> { team_lead_role? && team_lead_id.nil? }

  private

  def manager_role?
    role == 'manager'
  end
 
  def set_manager_id
    self.manager_id = id if new_record?
  end

  def team_lead_role?
    role == 'team_lead'
  end
  
  def set_team_lead_id
    self.team_lead_id = id if new_record?
  end  
end
