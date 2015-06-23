require 'spec_helper'

describe MiyauchiScheduler do
  it 'has a version number' do
    expect(MiyauchiScheduler::VERSION).not_to be nil
  end

  it 'does generate a calendar' do
    expect(subject.generate_calendar.class).to eq(MiyauchiCalendar)
  end

  it 'each days should have two workers by default' do
    cal = subject.generate_calendar
    cal.days.each do |day, workers|
      expect(workers.size).to eq(2)
    end
  end

  it 'should be able to return a list of workers' do
    expect(subject.workers).to eq([])
  end

  it 'each day should have two different workers' do
    cal = subject.generate_calendar
    cal.days.each do |day, workers|
      expect(workers.sort.uniq.size).to eq(2)
    end
  end

  it 'each worker should have at least 8 days off (by default)' do
    work_cal = subject.generate_calendar
    off_cal = subject.days_off
    subject.workers do |worker|
      expect(off_cal.days_for(worker).size).to eq(8) # be >= 8
    end
  end

  it 'each worker should not work twice on the same day' do
    work_cal = subject.generate_calendar
    subject.workers do |worker|
      days = work_cal.days_for(worker)
      expect(days.size).to eq(days.sort.uniq.size)
    end
  end

  it 'each worker should not work more than 5 days in a row' do
    cal = subject.generate_calendar
    subject.workers.each do |worker|
      days = cal.days_for(worker)
      (days.size - 1).times do |i|
        # x0 .. x4 + 1,2,3,4 = sum of continuous numbers.
        continuous_sum = days[i] * 5 + 10
        actual_sum = days[i..(i+5)].inject(0) { |t, x| t += x }
        # if they are sorted and there is no duplicates, it can't possibly be the same for a non-continuous series.
        expect(actual_sum).to be != continuous_sum
      end
    end
  end

  it 'each worker should not work more than (31 - 8) days' do
    work_cal = subject.generate_calendar
    subject.workers do |worker|
      days = work_cal.days_for(worker)
      expect(days.size).to eq(23) # be <= 23
    end
  end

end

