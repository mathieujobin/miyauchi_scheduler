class MiyauchiCalendar
  def initialize(number_of_days, default_workers=[])
    @number_of_days = number_of_days
    @data = number_of_days.times.inject({}) {|t,x| t[x+1] = default_workers.dup; t }
  end

  def days
    @data
  end

  def worker_on(day_of_month)
    days[day_of_month]
  end

  def add_worker(worker_name, day=nil)
    if day
      unless days[day].include? worker_name
        days[day] << worker_name
      end
    else
      @number_of_days.times do |d|
        add_worker(worker_name, d+1)
      end
    end
  end

  def remove_worker(worker_name, day=nil)
    if day
      days[day] -= [worker_name]
    else
      @number_of_days.times do |d|
        remove_worker(worker_name, d+1)
      end
    end
  end

  def days_for(worker_name)
    result = []
    @data.each do |day, names|
      if names.include? worker_name
        result << day
      end
    end
    result
  end
end

