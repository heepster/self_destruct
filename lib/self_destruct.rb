module SelfDestruct

  class Agent

    DEFAULT_RATIO_THRESHOLD = 5
    DEFAULT_GRACE_PERIOD    = 60 # in seconds
    DEFAULT_MIN_ATTEMPTS    = 20
    DEFAULT_FAILURE_LAMBDA  = lambda { abort "Too many failures" }
    DEFAULT_MAX_COUNT       = 1000000

    def initialize(opts = {})
      @success_count   = 0
      @failure_count   = 0
      @start_time      = nil
      @ratio_threshold = opts[:ratio_threshold] || DEFAULT_RATIO_THRESHOLD
      @grace_period    = opts[:grace_period]    || DEFAULT_GRACE_PERIOD
      @min_attempts    = opts[:min_attempts]    || DEFAULT_MIN_ATTEMPTS
      @failure_func    = opts[:failure_lambda]  || DEFAULT_FAILURE_LAMBDA
      @max_count       = opts[:max_count]       || DEFAULT_MAX_COUNT
    end

    def inc_successes
      @success_count += 1
      check_ratio!
    end

    def inc_failures
      @failure_count += 1
      check_ratio!
    end

    def reset!
      @success_count = 0 
      @failure_count = 0
      @start_time    = nil
    end

    private

    def set_start_time
      @start_time ||= Time.now
    end

    def check_ratio!
      ratio = get_ratio
      if (ratio < @ratio_threshold) and grace_period_has_passed? and minimum_attempts_reached?
        do_failure
      end
      check_total_num
    end

    def check_total_num
      reset! if get_total > @max_count
    end

    def minimum_attempts_reached?
      get_total >= @min_attempts 
    end

    def grace_period_has_passed?
      set_start_time
      (Time.now - @start_time) > @grace_period
    end

    def get_total
      @success_count + @failure_count
    end

    def get_ratio
      @success_count.to_f / @failure_count.to_f
    end

    def do_failure
      @failure_func.call
    end

  end
end
