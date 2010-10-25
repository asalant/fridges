module Paperclip
  module Storage
    module S3
      def create_bucket_with_timing
        timer(:create_bucket) do
          create_bucket_without_timing
        end
      end
      alias_method_chain :create_bucket, :timing

      def flush_writes_with_timing
        timer(:flush_writes) do
          flush_writes_without_timing
        end
      end
      alias_method_chain :flush_writes, :timing

      def timer(what)
        start = Time.now
        yield
        Rails.logger.info "#{what} executed in #{Time.now - start} sec"
      end

    end
  end
end
