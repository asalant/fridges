class Timer
  def self.timer(what)
    Rails.logger.info "#{what} started"
    start = Time.now
    yield
    Rails.logger.info "  #{what} executed in #{Time.now - start} sec"
  end
end

module Paperclip::Storage::S3
  def create_bucket_with_timing
    Timer.timer("Paperclip::Storage::S3#create_bucket") do
      create_bucket_without_timing
    end
  end

  alias_method_chain :create_bucket, :timing

  def flush_writes_with_timing
    Timer.timer("Paperclip::Storage::S3#flush_writes") do
      flush_writes_without_timing
    end
  end

  alias_method_chain :flush_writes, :timing
end

require 'aws/s3'
module AWS::S3
  class S3Object
    class << self
      def store_with_timing(key, data, bucket = nil, options = {})
        Timer.timer("AWS::S3::S3Object#store") do
          store_without_timing(key, data, bucket, options)
        end
      end

      alias_method_chain :store, :timing

    end
  end

  class Base
    class << self
      def request_with_timing(verb, path, options = {}, body = nil, attempts = 0, &block)
        Timer.timer("AWS::S3::Base#request") do
          request_without_timing(verb, path, options = {}, body = nil, attempts = 0, &block)
        end
      end

      alias_method_chain :request, :timing

    end
  end
end

