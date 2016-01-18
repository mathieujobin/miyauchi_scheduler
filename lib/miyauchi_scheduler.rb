require "miyauchi_scheduler/version"
require "miyauchi_calendar"

COMMON_YEAR_DAYS_IN_MONTH = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

def days_in_month(month, year = Time.now.year)
   return 29 if month == 2 && Date.gregorian_leap?(year)
   COMMON_YEAR_DAYS_IN_MONTH[month]
end

class MiyauchiScheduler

  attr_reader :days_off, :working_schedule

  def initialize(params={})
    # setting defaults for Otousan
    params[:worker_per_day]     ||= 2
    params[:available_workers]  ||= 4
    params[:days_off_per_month] ||= 8
    params[:days_off_per_year]  ||= 19
    @params = params
    @working_schedule = MiyauchiCalendar.new(days)
    reset_days_off
    @maxdays ||= {}
  end

  def reset_days_off
    @days_off = MiyauchiCalendar.new(days)
  end

  def generate_or_setup_days_off
    workers.each do |worker|
      while days_off.days_for(worker).size < days_off_per_month
        day = (rand * days).to_i + 1
        if worker_per_day <= (available_workers - days_off.worker_on(day).size)
          puts "Adding a day off to #{worker} on #{day}" if ENV['DEBUG']
          raise if worker.to_s.empty?
          days_off.add_worker(worker, day)
        end
      end
    end
  end

  def generate_calendar
    generate_or_setup_days_off
    days.times do |d|
      random_workers = workers.shuffle
      while working_schedule.worker_on(d+1).size < worker_per_day
        name = random_workers.pop
        unless has_no_more_working_days(name)
          puts "Worker #{name} set to work on #{d+1}" if ENV['DEBUG']
          raise if name.to_s.empty?
          working_schedule.add_worker(name, d+1)
        end
      end
    end
    working_schedule
  end

  def add_worker(name, maxdays)
    @workers ||= []
    @workers << name
    @maxdays[name] = maxdays
  end

  def set_workers(list)
    @workers = list
  end

  def workers
    @workers ||= available_workers.times.map { |x| "worker #{x+1}" }
  end

  def format_calendar(offset, month_length, days=nil)
    days ||= (1..month_length)

    [
      * %w{Mon Tue Wed Thu Fri Sat Sun},
      * Array.new(offset),
      * days,
    ].each_slice(7).map{ |week|
      week.map{ |date| "%3s" % date }.join " "
    }
  end

  def print
    puts to_s
  end

  def to_s
    out = []
    workers.each do |worker|
      out << "================= Schedule ====================="
      out << "Worker: #{worker} (Total working days: #{working_days_for(worker).size})"
      out << "Working on: #{working_days_for(worker).join(', ')}"
      out << "OFF on: #{days_off.days_for(worker)}"
      out << format_calendar(first_day_of_month, days, working_days_with_spaces_for(worker))
    end
    out << "================= per days ====================="
    days.times do |d|
      out << "#{d+1}: #{working_schedule.worker_on(d+1).join(', ')}"
    end
    out.join("\n")
  end

  def max_days_for(worker)
    @maxdays[worker] || (days-days_off_per_month)
  end

  private

  attr_reader :params

  def first_day_of_month
    Time.local(current_year, current_month, 1).wday
  end

  def days
    days_in_month current_month
  end

  def random_worker
    raise 'deprecated'
    workers[(rand * available_workers).to_i]
  end

  def has_no_more_working_days(worker)
    working_days_for(worker).size >= max_days_for(worker)
  end

  def working_days_for(worker)
    working_schedule.days_for(worker)
  end

  def working_days_with_spaces_for(worker)
    result = Array.new(days)
    working_days_for(worker).each do |d|
      result[d-1] = d
    end
    result
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

  def current_year
    params[:current_year] ||= Time.now.strftime('%Y').to_i
  end

  def current_month
    params[:current_month] ||= Time.now.strftime('%m').to_i
  end

  def next_month
    r = current_month + 1
    r > 12 ? 1 : r
  end
end

