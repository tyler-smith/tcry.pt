#!/usr/bin/env ruby

require 'json'

MODULE_NAME = "module.tcrypt"

INDENT_ENTRY = "    "
INDENT_VALUE = INDENT_ENTRY+"  "

STORAGE_VOLUMES = {
  "compute_worker_1" => "scsi-0DO_Volume_storage-1"
}

def state
  JSON.parse(ARGF.read)['values']['root_module']['child_modules']
end

def compute_instances
  state
    .find{|m| m['address'] == MODULE_NAME }['resources']
    .select{|m| m['type'] == "digitalocean_droplet" }
end

puts "---\nall:\n  hosts:\n"

compute_instances.each do |m|
  name = m['name']
  v = m['values']

  entry = [
    "region: #{v['region']}",
    "ansible_host: #{v['ipv4_address']}",
    "ip_v4: #{v['ipv4_address']}",
    "ip_v6: #{v['ipv6_address']}",
    "ip_vpc_v4: #{v['ipv4_address_private']}",
  ]

  volume = STORAGE_VOLUMES[name]
  if volume != nil
    entry << "storage_volume_id: #{volume}"
  end

  puts "#{INDENT_ENTRY}#{name.gsub(/_/,"-")}:"
  puts INDENT_VALUE+entry.join("\n#{INDENT_VALUE}")
end

