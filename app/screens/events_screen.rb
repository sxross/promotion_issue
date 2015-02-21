class EventsScreen < PM::TableScreen
  title "Events"
  searchable placeholder: "Search events"
  # row_height :auto, estimated: 62
  row_height 62
  stylesheet EventsScreenStylesheet

  def on_load
    Debug.log "event screen load!"
    rmq(self.view).apply_style :root_view
    set_nav_bar_button :right, title: "Help", action: :show_help  # Boilerplate
    @events = Event.all
  end

  def table_data

    @events ||= Event.all
    [
      {
        cells: @events.map do |event|
          {
            properties: {
              event_name: event.event_name,
              event_details: date_time_label(event),
              event_attendees: event.number_of_attendees_in_words
            },
            search_text: "#{event.event_name} #{event.event_location}",
            cell_class: EventsCell
          }
        end
      }
    ]
  end

  def date_time_label(data_object)
    return "no date and time specified" if data_object.event_date.nil?
    label = "On #{data_object.event_date.strftime("%m/%d/%y")}" if data_object.event_date
    label += " @ #{data_object.event_time.strftime("%I:%M %p")}" if data_object.event_time
    label
  end

  # Remove the following if you're only using portrait

  # You don't have to reapply styles to all UIViews, if you want to optimize, another way to do it
  # is tag the views you need to restyle in your stylesheet, then only reapply the tagged views, like so:
  #   def logo(st)
  #     st.frame = {t: 10, w: 200, h: 96}
  #     st.centered = :horizontal
  #     st.image = image.resource('logo')
  #     st.tag(:reapply_style)
  #   end
  #
  # Then in will_animate_rotate
  #   find(:reapply_style).reapply_styles#
  def will_animate_rotate(orientation, duration)
    reapply_styles
  end
end

class EventsCell < UITableViewCell
  def on_load
    rmq(:table_cell).apply_style :table_cell

    find(self.contentView).tap do |q|
      @event_name = q.append!(UILabel, :cell_label)
      @event_details = q.append!(UILabel, :detail_label)
      @event_attendees = q.append!(UILabel, :attendee_label)
    end
    self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton
  end

  def event_name=(value)
    @event_name.text = value
  end

  def event_details=(value)
    @event_details.text = value
  end

  def event_attendees=(value)
    @event_attendees.text = value
  end

end
