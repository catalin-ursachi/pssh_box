require 'uuid'

module PsshBox
  class Builder
    # The logic in this method is based on the PSSH implementation at: https://github.com/google/shaka-packager/tree/master/packager/tools/pssh.
    def self.build_pssh_box(pssh_version, system_id, pssh_data, key_ids = [])
      unless pssh_version == 0 || pssh_version == 1
        raise ArgumentError, "PSSH version #{pssh_version} is not supported; allowed values are 0 and 1."
      end

      pssh_bytes = build_pssh_bytes(key_ids, pssh_data, pssh_version, system_id)

      base64_encode_bytes(pssh_bytes)
    end

    private

    def self.build_pssh_bytes(key_ids, pssh_data, pssh_version, system_id)
      pssh_bytes = 'pssh'.bytes
      pssh_bytes += int_to_four_bytes(pssh_version << 24).bytes
      pssh_bytes += uuid_to_bytes(system_id).bytes
      if pssh_version == 1
        pssh_bytes += int_to_four_bytes(key_ids.length).bytes
        key_ids.each do |key_id|
          pssh_bytes += uuid_to_bytes(key_id).bytes
        end
      end
      pssh_bytes += int_to_four_bytes(pssh_data.length).bytes
      pssh_bytes += pssh_data

      length_including_prefix = 4 + pssh_bytes.length
      length_prefix_bytes = int_to_four_bytes(length_including_prefix).bytes

      length_prefix_bytes + pssh_bytes
    end

    def self.base64_encode_bytes(pssh_bytes)
      Base64.strict_encode64(pssh_bytes.pack('c*'))
    end

    def self.int_to_four_bytes(int)
      (int >> 24).chr + ((int >> 16) & 0xff).chr + ((int >> 8) & 0xff).chr + (int & 0xff).chr
    end

    def self.uuid_to_bytes(uuid_string)
      UUID.parse(uuid_string).raw_bytes
    end
  end
end
