class User < ApplicationRecord
  belongs_to :role
  scope :clients, -> { joins(:role).where(roles: { name: "cliente" }) }
  scope :admins, -> { joins(:role).where(roles: { name: "Administrador SAGO" }) }
  scope :staff, -> { joins(:role).where.not(roles: { name: [ "cliente", "administrador" ] }) }
  has_many :pricings
  has_many :services, through: :pricings
  has_many :invoices, dependent: :restrict_with_error
  has_many :containers, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  # validates :password, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :username, presence: true, uniqueness: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  def full_name
    "#{first_name} #{last_name} #{second_last_name}"
  end
  def update_available_credit
    pending_total = invoices.where(status: "Pendiente").sum(:total)
    partial_total = invoices.where(status: "Parcial").sum { |invoice| invoice.total - invoice.payments.sum(:amount).to_f }

    self.available_credit = credit_limit - (pending_total + partial_total)
    save!
  end
end
