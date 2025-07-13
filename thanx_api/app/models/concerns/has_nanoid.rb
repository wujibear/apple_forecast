module HasNanoid
  extend ActiveSupport::Concern

  included do
    before_create :generate_nanoid
    validates :nanoid, presence: true, uniqueness: true
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