require 'spec_helper'

describe MiyauchiCalendar do
  it 'can return the list of days for a worker' do
    expect(subject.days_for(worker)).to eq([1,2,3])
  end

  it 'can return all days with workers' do
    expect(subject.days).to eq({
      1=>["worker_1", "worker_2"], 2=>["worker_1", "worker_2"], 3=>["worker_1", "worker_2"], 4=>["worker_1", "worker_2"], 5=>["worker_1", "worker_2"], 6=>["worker_1", "worker_2"], 7=>["worker_1", "worker_2"], 8=>["worker_1", "worker_2"], 9=>["worker_1", "worker_2"], 10=>["worker_1", "worker_2"], 11=>["worker_1", "worker_2"], 12=>["worker_1", "worker_2"], 13=>["worker_1", "worker_2"], 14=>["worker_1", "worker_2"], 15=>["worker_1", "worker_2"], 16=>["worker_1", "worker_2"], 17=>["worker_1", "worker_2"], 18=>["worker_1", "worker_2"], 19=>["worker_1", "worker_2"], 20=>["worker_1", "worker_2"], 21=>["worker_1", "worker_2"], 22=>["worker_1", "worker_2"], 23=>["worker_1", "worker_2"], 24=>["worker_1", "worker_2"], 25=>["worker_1", "worker_2"], 26=>["worker_1", "worker_2"], 27=>["worker_1", "worker_2"], 28=>["worker_1", "worker_2"], 29=>["worker_1", "worker_2"], 30=>["worker_1", "worker_2"], 31=>["worker_1", "worker_2"]}
    )
  end

  it 'can return the worker for a specific date' do
    expect(subject.worker_on(10)).to eq(["worker_1", "worker_2"])
  end
end
