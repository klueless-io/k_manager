# frozen_string_literal: true

module KManager
  module Resources
    require 'handlebars/helpers/string_formatting/dasherize'

    # A web resource represents content that is loaded via a web URI.
    #
    # Web resources do not support watchers and so if you want to handle
    # content changes then you will either need to poll the resource periodically
    # or have a server with open channel for web-hooks.
    class WebResource < KManager::Resources::BaseResource
      include KLog::Logging

      def initialize(uri, **opts)
        warn('URI::HTTP/HTTPS type is expected for Web Resource') unless uri.is_a?(URI::HTTP)
        super(uri, **opts)
        log_any_messages unless valid?
      end

      # Infer key is the file name without the extension stored in dash-case
      def infer_key
        last_segment = uri.path.split('/').last
        Handlebars::Helpers::StringFormatting::Snake.new.parse(last_segment)
      end

      def default_scheme
        :https
      end

      def resource_path
        @resource_path ||= source_path
      end

      def resource_relative_path
        uri.path
      end

      def resource_valid?
        return @resource_valid if defined? @resource_valid

        @resource_valid = url_exist?(source_path)
      end

      def load_content
        if resource_valid?
          begin
            @content = fetch(source_path)
          rescue StandardError => e
            log.error e
          end
        else
          guard("Source url not valid: #{resource_path}")
        end
      end

      def attribute_values(prefix = nil)
        result = super(prefix)
        result["#{prefix}path".to_sym]          = resource_path
        result["#{prefix}relative_path".to_sym] = resource_relative_path
        result["#{prefix}exist".to_sym]         = resource_valid?
        result
      end

      def debug
        super do
          log.kv 'infer_key'        , infer_key         , 20
          log.kv 'url'              , source_path       , 20
          log.kv 'resource_path'    , resource_path     , 20
          log.kv 'resource_valid?'  , resource_valid?   , 20
        end
      end

      private

      # rubocop:disable  Metrics/AbcSize
      def url_exist?(url_str, limit = 10)
        raise ArgumentError, 'too many HTTP redirects' if limit.zero?

        url = URI.parse(url_str)
        req = Net::HTTP.new(url.host, url.port)
        req.use_ssl = (url.scheme == 'https')
        res = req.request_head(url.path || '/')
        if res.is_a?(Net::HTTPRedirection)
          url_exist?(res['location'], limit - 1) # Go after any redirect and make sure you can access the redirected URL
        else
          !%w[4 5].include?(res.code[0]) # Not from 4xx or 5xx families
        end
      rescue Errno::ENOENT
        false # false if can't find the server
      end
      # rubocop:enable  Metrics/AbcSize

      def fetch(url_str, limit = 10)
        raise ArgumentError, 'too many HTTP redirects' if limit.zero?

        url = URI.parse(url_str)
        res = Net::HTTP.get_response(url)

        case res
        when Net::HTTPSuccess
          res.body
        when Net::HTTPRedirection
          location = res['location']
          puts "redirected to #{location}"
          fetch(location, limit - 1)
        else
          res.value
        end
      end
    end
  end
end
