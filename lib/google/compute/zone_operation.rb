# Copyright 2013 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Google compute engine, operation resource reference

require 'timeout'

module Google
  module Compute
    class ZoneOperation < Resource

      attr_reader :zone, :client_operation_id, :operation_type
      attr_reader :target_link, :target_id, :status
      attr_reader :status_message, :user, :progress
      attr_reader :insert_time, :start_time, :end_time
      attr_reader :error, :warnings, :http_error_status_code
      attr_reader :http_error_message, :region

      def from_hash(data)
        super(data)
        @zone = data["zone"]
        @client_operation_id =  data["clientOperationId"]
        @operation_type = data["operationType"]
        @target_link= data["targetLink"]
        @target_id = data["targetId"]
        @status =  data["status"]
        @status_message = data["statusMessage"]
        @user = data["user"]
        @progress =  data["progress"]
        @insert_time = Time.parse( data["insertTime"] ) if data.key?("insertTime")
        @start_time = Time.parse( data["startTime"] ) if data.key?("startTime")
        @end_time = Time.parse( data["endTime"] ) if data.key?("endTime")
        @error = data["error"]
        @warnings = data["warnings"]
        @http_error_status_code = data["httpErrorMessage"]
        @http_error_message = data["httpErrorMessage"]
        @region = data["region"]
      end

      def wait_for_completion!(options={})
        timeout = options[:timeout] || 60
        status = Timeout::timeout(timeout, OperationTimeout) do
          until  progress==100
            sleep 2
            progress= get_self.progress
          end  
        end
      end
    end
  end
end
