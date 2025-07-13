module HasNanoid
  extend ActiveSupport::Concern

  included do
    before_create :generate_nanoid
    validates :nanoid, uniqueness: true, allow_nil: true
    validates :nanoid, presence: true, on: :update
  end

  private

  def generate_nanoid
    return if nanoid.present?
    
    loop do
      self.nanoid = Nanoid.generate(size: 12)
      break unless self.class.exists?(nanoid: nanoid)
    end
  end
end 