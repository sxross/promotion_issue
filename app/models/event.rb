class Event
  include MotionModel::Model
  include MotionModel::ArrayModelAdapter
  include MotionModel::Formotion
  include MotionModel::Validatable
  include Comparable

  columns  :event_name     => :string,
           :event_location => {:type => :text, :formotion => {:row_height => 100, :text_alignment => :right}},
           :event_date     => {:type => :date, :formotion => {:picker_mode => :date}},
           :event_time     => {:type => :time, :formotion => {:picker_mode => :time, :minute_interval => 15}},
           :contact_person => :string,
           :contact_email  => {:type => :string, :formotion => {:type => :email}},
           :contact_phone  => {:type => :string, :formotion => {:type => :phone}}
  has_many :people, :dependent => :destroy

  validate :event_name, :presence => true

  def before_save(obj)
    self.contact_phone = self.contact_phone.to_us_phone unless contact_phone.nil?
    true
  end

  def all_people
    self.people.all
  end

  def registered
    all_people.map{|o| o.people_attending.nil? ? 0 : o.people_attending}.reduce(:+) || 0
  end

  def registered_in_words
    registered.to_countable_s('person', 'nobody')
  end

  def average_per_party
    return 0 if self.people.count == 0
    (all_people.map{|o| o.people_attending}.reduce(:+)) / self.people.count
  end

  def checked_in
    all_people.map{|o| o.checked_in.nil? ? 0 : o.checked_in}.reduce(:+) || 0
  end

  def checked_in_in_words
    checked_in.to_countable_s('person', 'nobody')
  end

  def percent_here
    return registered > 0 ? (checked_in.to_f * 100 / registered.to_f).round : 0
  end

  def number_of_attendees_in_words
    "registered: #{registered_in_words}/checked in: #{checked_in_in_words} (#{percent_here}%)"
  end

  def <=> (o)
    self.event_date <=> o.event_date
  end

  def compare(o)
    self.event_date <=> o.event_date
  end

  def to_s
    """
    Event name:      #{event_name}
    Event location:  #{event_location}
    Event date:      #{event_date}
    Contact person:  #{contact_person}
    Contact email:   #{contact_email}
    Contact phone:   #{contact_phone}
    """
  end
end
