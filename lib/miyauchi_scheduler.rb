require "miyauchi_scheduler/version"
require "miyauchi_calendar"


class MiyauchiScheduler
  def initialize(params={})
  end

  def generate_calendar
    MiyauchiCalendar.new
  end

end
