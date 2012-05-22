#
# Author:: Chirag Jog (<chiragj@websym.com>)
# Copyright:: Copyright (c) 2012 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require 'open3'

require 'chef/knife'
require 'chef/json_compat'
require 'chef/knife/google_base'

class Chef
  class Knife
    class GoogleServerDelete < Knife

      include Knife::GoogleBase
      banner "knife google server delete SERVER (options)"

      option :project_id,
        :short => "-p PROJECTNAME",
        :long => "--project_id PROJECTNAME",
        :description => "Your Google Compute Project Name",
        :proc => Proc.new { |project| Chef::Config[:knife][:project] = project } 

      def run 
        unless Chef::Config[:knife][:project]
          ui.error("Project ID is a compulsory parameter")
          exit 1
        end

        $stdout.sync = true
        project_id = Chef::Config[:knife][:project]
        validate_project(project_id) 

      @name_args.each do |server| 
        confirm("Do you really want to delete the server - #{server} ?")
        stdin, stdout, stderr = Open3.popen3("gcompute deleteinstance #{server} --print_json --project_id=#{project_id} -f")
        error = stderr.read
        if not error.downcase.scan("error").empty?
          ui.error("Failed to delete server. Error: #{error}")
          exit 1
        end
 
        stdin, stdout, stderr = Open3.popen3("gcompute deletefirewall #{server} --print_json --project_id=#{project_id} -f")
        error = stderr.read
        if not error.downcase.scan("error").empty?
          ui.error("Failed to delete firewall. Error: #{error}")
          exit 1
        end
          ui.warn("Deleted server #{server}")
        end
      end
    end
  end
end
