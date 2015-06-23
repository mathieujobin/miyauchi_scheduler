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

  it 'should be able to set a list of workers with different maximum working days' do
    subject.add_worker "Hito 1", 22
    subject.add_worker "Hito 2", 22
    subject.add_worker "Hito 3", 13
    subject.add_worker "Hito 4", 13
    expect(subject.workers).to eq(["Hito 1", "Hito 2", "Hito 3", "Hito 4"])
  end

  context 'when setting workers with different amount of working days' do
    it 'should not schedule them for more than expected' do
      subject.add_worker "Hito 1", 22
      subject.add_worker "Hito 2", 22
      subject.add_worker "Hito 3", 13
      subject.add_worker "Hito 4", 13
      cal = subject.generate_calendar
      expect(work_cal.days_for("Hito 1").size).to be <= 22
      expect(work_cal.days_for("Hito 2").size).to be <= 22
      expect(work_cal.days_for("Hito 3").size).to be <= 13
      expect(work_cal.days_for("Hito 4").size).to be <= 13
      subject.print
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

  2.times do
    it 'each worker should have at least 8 days off (by default) (100 times)' do
      work_cal = subject.generate_calendar
      off_cal = subject.days_off
      subject.workers.each do |worker|
        expect(off_cal.days_for(worker).size).to be >= 8
      end
    end
  end

  it 'each worker should not work twice on the same day' do
    work_cal = subject.generate_calendar
    subject.workers do |worker|
      days = work_cal.days_for(worker)
      expect(days.size).to eq(days.sort.uniq.size)
    end
  end

  10.times do
    it 'each worker should not work more than 5 days in a row (100 times)' do
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

  10.times do
    it 'each worker should not work more than (31 - 8) days (100 times)' do
      work_cal = subject.generate_calendar
      subject.workers.each do |worker|
        days = work_cal.days_for(worker)
        expect(days.size).to be <= 22
      end
    end
  end

  it 'should be able to print the schedule' do
    work_cal = subject.generate_calendar
    expect(subject.print).to be nil
  end

end

