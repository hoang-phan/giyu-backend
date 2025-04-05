class User < ApplicationRecord
  validates :phone, :code, presence: true, uniqueness: true

  before_validation :generate_code

  def self.ransackable_attributes(auth_object = nil)
    [ "birth_day", "birth_month", "birth_year", "code", "created_at", "email", "first_name", "id", "id_value", "last_active_at", "last_name", "phone", "registration_date", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

  def generate_code
    return if code.present?

    id_s = id.to_s.split("")
    id_digits = id_s.size
    random_s = rand(10 ** id_digits).rjust(id_digits, "0").to_s.split("")
    self.code = id_s.zip(random_s).join
  end
end
