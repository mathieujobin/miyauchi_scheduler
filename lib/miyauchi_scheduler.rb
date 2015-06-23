require "miyauchi_scheduler/version"
require "miyauchi_calendar"

DaysPerMonth = {
  1 => 31,
  2 => 29, # ouch, fix this
  3 => 31,
  4 => 30,
  5 => 31,
  6 => 30,
  7 => 31,
  8 => 31,
  9 => 30,
  10 => 31,
  11 => 30,
  12 => 31
}

class MiyauchiScheduler

  def initialize(params={})
    # setting defaults for Otousan
    params[:worker_per_day]     ||= 2
    params[:available_workers]  ||= 4
    params[:days_off_per_month] ||= 8
    params[:days_off_per_year]  ||= 19
    params[:current_month]      ||= current_month
    @params = params
    @working_schedule = MiyauchiCalendar.new(days)
    @days_off = MiyauchiCalendar.new(days)
  end

  def generate_calendar
    days.times do |d|
      while @working_schedule.worker_on(d+1).size < worker_per_day
        @working_schedule.add_worker(random_worker, d+1)
      end
    end
    @working_schedule
  end

private

  attr_reader :params

  def days
    DaysPerMonth[current_month]
  end

  def workers
    @workers ||= available_workers.times.map { |x| "worker #{x+1}" }
  end

  def random_worker
    workers[(rand * available_workers).to_i]
  end

  def worker_per_day
    params[:worker_per_day]
  end

  def available_workers
    params[:available_workers]
  end

  def days_off_per_month
    params[:days_off_per_month]
  end

  def days_off_per_year
    params[:days_off_per_year]
  end

  def current_month
    Time.now.strftime('%m').to_i
  end

  def next_month
    r = current_month + 1
    r > 12 ? 1 : r
  end
end

