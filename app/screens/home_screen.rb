class OldEventsScreen < PM::TableScreen
  title "Events"
  searchable placeholder: "Search events"
  row_height :auto, estimated: 62

  def on_load
    Debug.log "!!!load"
    rmq.stylesheet = EventsControllerStylesheet
    @events = Event.all
  end

  def table_data
    @events ||= Event.all

    [
      {
        cells: @events.map do |event|
          {
            title: event.event_name,
            subtitle: event.event_location,
            cell_class: EventTableViewCell
          }
        end
      }
    ]

  end

  def on_load
    set_nav_bar_button :right, title: "Help", action: :show_help  # Boilerplate
  end

  # Boilerplate
  def show_help
    open HelpScreen
  end

end

class EventTableViewCell < PM::TableViewCell
  def rmq_build
    q = rmq(self.contentView)

    # Customize your cell: Add your subviews, init stuff here
    # @foo = q.append!(UILabel, :foo)

    # Or use the built-in table cell controls, if you don't use
    # these, they won't exist at runtime
    # @image = q.build!(self.imageView, :cell_image)
    # @detail = q.build!(self.detailTextLabel, :cell_label_detail)
    @event_name = q.build!(self.textLabel, :cell_label)
    @event_details = q.build!(self.detailTextLabel, :detail_label)
  end

end

class EventsCell < UITableViewCell
  def rmq_build
    q = rmq(self.contentView)

    # Customize your cell: Add your subviews, init stuff here
    # @foo = q.append!(UILabel, :foo)

    # Or use the built-in table cell controls, if you don't use
    # these, they won't exist at runtime
    # @image = q.build!(self.imageView, :cell_image)
    # @detail = q.build!(self.detailTextLabel, :cell_label_detail)
    @event_name = q.build!(self.textLabel, :cell_label)
    @event_details = q.build!(self.detailTextLabel, :detail_label)
  end

  def update(data)
    # Update data here
    @event_name.text = data.event_name
  end

end
