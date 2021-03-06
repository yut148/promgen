# The MIT License (MIT)
#
# Copyright (c) 2016 LINE Corporation
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# frozen_string_literal: true
# configuration for prometheus

require 'will_paginate'
require 'will_paginate/sequel'

class Promgen
  class Repo
    class AuditRepo
      def initialize(logger:, db:)
        raise ArgumentError, 'DB must not be null' if db.nil?
        @logger = logger
        @db = db
      end

      def log(entry:)
        raise ArgumentError, 'entry must not be null' if entry.nil?

        @db[:audit_log].insert(
          entry: entry,
          timestamp: Time.now.getutc.to_i
        )
      end

      def all
        @db[:audit_log].order(Sequel.desc(:id)).map do |entry|
          entry
        end
      end

      def paginate(page:, per_page:)
        @db[:audit_log].order(Sequel.desc(:id)).extension(:pagination).paginate(page.to_i, per_page.to_i)
      end
    end
  end
end
