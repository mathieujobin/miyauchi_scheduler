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
    cal.days.each do |workers|
      expect(workers.size).to eq(2)
    end
  end
end
