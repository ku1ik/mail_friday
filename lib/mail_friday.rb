require 'girl_friday'
require 'singleton'

module MailFriday
  class << self
    attr_reader :excluded_environments

    def excluded_environments=(envs)
      @excluded_environments = [*envs].map { |e| e.to_sym }
    end

    def included(base)
      base.extend(ClassMethods)
    end
  end

  self.excluded_environments = [:test]

  module ClassMethods

    def method_missing(method_name, *args)
      return super if environment_excluded?

      if action_methods.include?(method_name.to_s)
        Message.new(self, method_name, *args)
      else
        super
      end
    end

    def environment_excluded?
      !ActionMailer::Base.perform_deliveries || excluded_environment?(Rails.env)
    end

    # def queue
    #   @queue || ::Resque::Mailer.default_queue_name
    # end

    # def queue=(name)
    #   @queue = name
    # end

    def excluded_environment?(name)
      MailFriday.excluded_environments && MailFriday.excluded_environments.include?(name.try(:to_sym))
    end

    # def deliver?
    #   true
    # end
  end

  class Message
    # delegate :to_s, :to => :actual_message

    def initialize(mailer_class, action, *args)
      @mailer_class = mailer_class
      @action = action
      @args = *args
    end

    # def actual_message
    #   @actual_message ||= @mailer_class.send(:new, @action, *@args).message
    # end

    def deliver
      # if @mailer_class.deliver?
        Queue.push :mailer_class => @mailer_class,
                   :action => @action,
                   :args => @args
      # end
      self
    end

    def deliver!
      @mailer_class.send(:new, @action, *@args).message.deliver
    end

    # def method_missing(method_name, *args)
    #   actual_message.send(method_name, *args)
    # end
  end

  class Queue < GirlFriday::WorkQueue
    include Singleton

    def initialize
      super(:mail_friday_queue) do |msg|
        mailer = msg[:mailer_class].send(:new, msg[:action], *msg[:args])
        mailer.message.deliver
      end
    end

    def self.push *args
      instance.push *args
    end
  end
end
