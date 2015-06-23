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
    expect(subject.workers).to eq(["worker 1", "worker 2", "worker 3", "worker 4"])
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
      expect(off_cal.days_for(worker).size).to eq(9) # be >= 8
    end
  end

  it 'each worker should not work twice on the same day' do
    work_cal = subject.generate_calendar
    subject.workers do |worker|
      days = work_cal.days_for(worker)
      expect(days.size).to eq(days.sort.uniq.size)
    end
  end

  it 'each worker should not work more than 5 days in a row (100 times)' do
    100.times do
      cal = subject.generate_calendar
      subject.workers.each do |worker|
        days = cal.days_for(worker)
        (days.size - 1).times do |i|
          # x0 .. x4 + 1,2,3,4 = sum of continuous numbers.
          continuous_sum = days[i] * 5 + 10
          actual_sum = days[i..(i+5)].inject(0) { |t, x| t += x }
          # if they are sorted and there is no duplicates, it can't possibly be the same for a non-continuous series.
          expect(actual_sum).not_to eq continuous_sum
        end
      end
    end
  end

  it 'each worker should not work more than (31 - 8) days' do
    100.times do
      work_cal = subject.generate_calendar
      subject.workers.each do |worker|
        days = work_cal.days_for(worker)
        expect(days.size).to be <= 22
      end
    end
  end

end

