module Padlock
  class ComponentNotFound < StandardError
  end

  class Component
    def self.add(name, envs, disabled=false)
      @components ||= {}
      @components[name] = new(name, envs, disabled)
    end

    def self.get(name)
      (@components ||= {})[name] || raise(Padlock::ComponentNotFound.new("#{name} is not a valid component."))
    end

    def initialize(name, envs, disabled)
      @name, @envs, @disabled = name, envs, disabled
    end

    def enabled?
      result = true if @envs == :all
      result ||= Array(@envs).map { |env| env.to_sym }.include?(Padlock.environment.to_sym)
      @disabled ? (!result) : result
    end
  end

  def self.environment=(env)
    @environment = env
  end

  def self.environment
    @environment
  end

  def self.components(&block)
    @block = block
    instance_eval(&block)
  end

  def self.reset!
    if block = @block
      components(&block)
    else
      raise "No padlock block defined!"
    end
  end

  def self.enable(name, options={})
    Padlock::Component.add(name, (options[:in] || :all))
  end

  def self.disable(name, options={})
    Padlock::Component.add(name, (options[:in] || :all), :disabled)
  end

  def component(name)
    enabled = Padlock::Component.get(name).enabled?
    enabled && yield if block_given?
    enabled
  end
end

def Padlock(env, &block)
  if block_given?
    ::Padlock.environment = env
    ::Padlock.components(&block)
  else
    ::Padlock
  end
end
