require 'spec_helper'

describe SelfDestruct do

  it "should abort" do
    expect(lambda do
      agent = Agent.new(grace_period: 0)
      successes = 1345
      failures  = 3324
      successes.times { agent.inc_successes } 
      failures.times  { agent.inc_failures } 
    end).to raise_error
  end

  it "should not abort" do
    expect(lambda do
      agent = Agent.new(grace_period: 0)
      successes = 50040
      failures  = 3404
      successes.times { agent.inc_successes } 
      failures.times  { agent.inc_failures } 
    end).not_to raise_error
  end

  it "should not abort because min attempts tried not reached" do
    expect(lambda do
      agent = Agent.new(grace_period: 0)
      successes = 2
      failures  = 17
      successes.times { agent.inc_successes }
      failures.times  { agent.inc_failures }
    end).not_to raise_error
  end

  it "should abort because min attempts tried reached and ratio is failing" do
    expect(lambda do
      agent = Agent.new(grace_period: 0)
      successes = 2
      failures  = 18
      successes.times { agent.inc_successes }
      failures.times  { agent.inc_failures }
    end).to raise_error
  end

  it "should call reset! after passing max count threshold" do
    agent     = Agent.new(grace_period: 0)
    successes = Agent::DEFAULT_MAX_COUNT
    failures  = 2
    successes.times { agent.inc_successes }
    failures.times  { agent.inc_failures  }
    result = agent.send(:get_total)
    expect(result).to eq(1)
  end

  it "should call user specified lambda" do
    word  = "die"
    opts  = { grace_period: 0, failure_func: Proc.new { word } }
    agent = Agent.new(opts) 
    res   = agent.send(:do_failure)
    expect(res).to eq(word)
  end

end
