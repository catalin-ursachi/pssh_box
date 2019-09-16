require 'uuid'

module PsshBox
  class Builder
    # Build a PSSH box using the given parameters.
    # The logic in this method is based on the PSSH implementation at:
    # https://github.com/google/shaka-packager/tree/master/packager/tools/pssh.
    #
    # Params:
    # - pssh_version: 0 or 1; for version 1, the key IDs will be included in the PSSH box.
    # - system_id: the DRM provider system ID
    # - pssh_data: a byte array containing the DRM-specific data (e.g. an encoded protocol buffer for Widevine, or a WRMHEADER for PlayReady)
    # - key_ids: the key IDs to be included in a version 1 box; ignored for version 0 boxes.
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
      pssh_bytes += version_bytes(pssh_version)
      pssh_bytes += system_id_bytes(system_id)
      if pssh_version == 1
        pssh_bytes += key_id_bytes(key_ids)
      end
      pssh_bytes += pssh_data_bytes(pssh_data)

      length_prefix_bytes(pssh_bytes.length) + pssh_bytes
    end

    def self.version_bytes(pssh_version)
      int_to_four_bytes(pssh_version << 24).bytes
    end

    def self.system_id_bytes(system_id)
      uuid_to_bytes(system_id).bytes
    end

    def self.key_id_bytes(key_ids)
      key_id_bytes = int_to_four_bytes(key_ids.length).bytes
      key_ids.each do |key_id|
        key_id_bytes += uuid_to_bytes(key_id).bytes
      end
      key_id_bytes
    end

    def self.pssh_data_bytes(pssh_data)
      int_to_four_bytes(pssh_data.length).bytes + pssh_data
    end

    def self.length_prefix_bytes(length)
      length_including_prefix = 4 + length
      int_to_four_bytes(length_including_prefix).bytes
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
