require 'spec_helper'

describe MiyauchiCalendar do
  subject do
    MiyauchiCalendar.new(31, ['worker_1', 'worker_2'])
  end

  it 'requires an argument' do
    expect{MiyauchiCalendar.new}.to raise_error(ArgumentError)
  end

  it 'by default, it creates a hash of days with empty worker arrays' do
    expect(MiyauchiCalendar.new(2).days).to eq({1=>[], 2=>[]})
  end

  it 'can return the list of days for a worker (by default, all)' do
    worker = 'worker_1'
    expect(subject.days_for(worker)).to eq([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31])
  end

  it 'can return the list of days for a worker (specific)' do
    worker = 'worker_1'
    cal = MiyauchiCalendar.new(34, ['xyz'])
    cal.add_worker(worker, 6)
    cal.add_worker(worker, 12)
    cal.add_worker(worker, 18)
    cal.add_worker(worker, 25)
    cal.add_worker(worker, 31)
    expect(cal.days_for(worker)).to eq([6, 12, 18, 25, 31])
  end

  it 'can return all days with workers' do
    expect(subject.days).to eq({
      1=>["worker_1", "worker_2"], 2=>["worker_1", "worker_2"], 3=>["worker_1", "worker_2"], 4=>["worker_1", "worker_2"], 5=>["worker_1", "worker_2"], 6=>["worker_1", "worker_2"], 7=>["worker_1", "worker_2"], 8=>["worker_1", "worker_2"], 9=>["worker_1", "worker_2"], 10=>["worker_1", "worker_2"], 11=>["worker_1", "worker_2"], 12=>["worker_1", "worker_2"], 13=>["worker_1", "worker_2"], 14=>["worker_1", "worker_2"], 15=>["worker_1", "worker_2"], 16=>["worker_1", "worker_2"], 17=>["worker_1", "worker_2"], 18=>["worker_1", "worker_2"], 19=>["worker_1", "worker_2"], 20=>["worker_1", "worker_2"], 21=>["worker_1", "worker_2"], 22=>["worker_1", "worker_2"], 23=>["worker_1", "worker_2"], 24=>["worker_1", "worker_2"], 25=>["worker_1", "worker_2"], 26=>["worker_1", "worker_2"], 27=>["worker_1", "worker_2"], 28=>["worker_1", "worker_2"], 29=>["worker_1", "worker_2"], 30=>["worker_1", "worker_2"], 31=>["worker_1", "worker_2"]}
    )
  end

  ### worker_on

  it 'can return the worker for a specific date' do
    expect(subject.worker_on(10)).to eq(["worker_1", "worker_2"])
  end

  ### add_worker

  it 'should allow to set the workers for a specifc date' do
    subject.add_worker('worker_3', 26)
    expect(subject.worker_on(26)).to eq(["worker_1", "worker_2", 'worker_3'])
  end

  it 'when adding for a specifc date, it should not add to other days' do
    subject.add_worker('worker_3', 26)
    31.times do |d|
      if d == 25
        expect(subject.worker_on(26)).to eq(["worker_1", "worker_2", 'worker_3'])
      else
        expect(subject.worker_on(d+1)).to eq(["worker_1", "worker_2"])
      end
    end
  end

  it 'should not add a worker twice' do
    subject.add_worker('worker_2', 26)
    expect(subject.worker_on(26)).to eq(["worker_1", "worker_2"])
  end

  it 'should allow to add a worker to all days' do
    subject.add_worker('foo')
    31.times do |d|
      expect(subject.worker_on(d+1)).to eq(["worker_1", "worker_2", 'foo'])
    end
  end

  ### remove_worker

  it 'should allow to remove a worker for a specific date' do
    subject.remove_worker('worker_1', 13)
    31.times do |d|
      if d == 12
        expect(subject.worker_on(d+1)).to eq(["worker_2"])
      else
        expect(subject.worker_on(d+1)).to eq(["worker_1", "worker_2"])
      end
    end
  end

  it 'should allow to remove a worker from all days' do
    subject.remove_worker('worker_1')
    31.times do |d|
      expect(subject.worker_on(d+1)).to eq(["worker_2"])
    end
  end

end
