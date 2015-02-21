class EventsScreenStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed,
  # example: include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb

    @width = rmq.device.width
  end

  def root_view(st)
    st.background_color = color.white
  end

  def table(st)
    st.background_color = color.gray
  end

  def table_cell(st)
    st.background_color = color.white
    st.frame = {height: events_cell_height}
  end

  def events_cell_height
    80
  end

  def cell_label(st)
    st.frame = {top: 4, left: 12, width: @width, height: 20}
  end

  def detail_label(st)
    st.text = "details"
    st.frame = {top: 20, left: 12, width: @width, height: 18}
    st.font = font.small
  end

  def attendee_label(st)
    st.text = "attendees"
    st.frame = {top: 35, left: 12, width: @width, height: 18}
    st.font = font.small
  end
end
