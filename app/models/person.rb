class Person
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter
  include MotionModel::Formotion
  include MotionModel::Validatable
  include Comparable

  columns     first_name: :string,
              original_name: :string,
              last_name: :string,
              checked_in: {type: :integer, default: 0},
              people_attending: {type: :integer, default: 1},
              vip: {type: :boolean, default: false}
  belongs_to  :event

  validate :first_name, :presence => true
  validate :last_name,  :presence => true

  def full_name
    name = "#{last_name}, #{first_name}"
    name += " (#{original_name})" unless last_name.empty? || original_name.empty? || last_name == original_name
    name.gsub(/^[ ,]*/, '')
  end

  def vip?
    vip == true
  end

  def compact_full_name
    full_name.gsub(/,| |\(|\)/, '')
  end

  def percent_checked_in
    return 0 if people_attending == 0 || checked_in == 0
    checked_in.to_f / people_attending.to_f * 100.0
  end

  def <=> (o)
    compact_full_name <=> o.compact_full_name
  end

  def compare(o)
    compact_full_name <=> o.compact_full_name
  end

  def to_s
    """
    Last name:        #{last_name}
    First name:       #{first_name}
    Original name:    #{original_name}
    Checked in:       #{checked_in}
    People attending: #{people_attending}
    """
  end
end
