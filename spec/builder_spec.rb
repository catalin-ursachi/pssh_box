RSpec.describe PsshBox::Builder do
  WIDEVINE_SYSTEM_ID = 'edef8ba9-79d6-4ace-a3c8-27dcd51d21ed'

  it 'correctly generates a v0 PSSH box' do
    # Given
    pssh_version = 0

    pssh_data_bytes = Base64.strict_decode64('EhBAMOBs3NhPLa/biRaQtcQo').bytes

    # This is the Widevine PSSH Box v0 built by the Shaka-Packager PSSH tool
    # (https://github.com/google/shaka-packager/tree/master/packager/tools/pssh)
    # for key ID '4030e06c-dcd8-4f2d-afdb-891690b5c428' (which produces the input PSSH data above).
    expected_pssh_box = 'AAAAMnBzc2gAAAAA7e+LqXnWSs6jyCfc1R0h7QAAABISEEAw4Gzc2E8tr9uJFpC1xCg='

    # When
    pssh_box = PsshBox::Builder.build_pssh_box(pssh_version, WIDEVINE_SYSTEM_ID, pssh_data_bytes)

    # Then
    expect(pssh_box).to eql(expected_pssh_box)
  end

  it 'correctly generates a v1 PSSH box with a single key ID' do
    # Given
    pssh_version = 1

    key_id = '4030e06c-dcd8-4f2d-afdb-891690b5c428'

    pssh_data_bytes = Base64.strict_decode64('EhBAMOBs3NhPLa/biRaQtcQo').bytes

    # This is the Widevine PSSH Box v1 built by the Shaka-Packager PSSH tool
    # (https://github.com/google/shaka-packager/tree/master/packager/tools/pssh)
    # for the given key ID (which produces the input PSSH data above).
    expected_pssh_box = 'AAAARnBzc2gBAAAA7e+LqXnWSs6jyCfc1R0h7QAAAAFAMOBs3NhPLa/biRaQtcQoAAAAEhIQQDDgbNzYTy2v24kWkLXEKA=='

    # When
    pssh_box = PsshBox::Builder.build_pssh_box(pssh_version, WIDEVINE_SYSTEM_ID, pssh_data_bytes, [key_id])

    # Then
    expect(pssh_box).to eql(expected_pssh_box)
  end

  it 'correctly generates a v1 PSSH box with multiple key IDs' do
    # Given
    pssh_version = 1

    first_key_id = '4030e06c-dcd8-4f2d-afdb-891690b5c428'
    second_key_id = '2b00c64d-5cc7-4cad-8ebb-d1560399d67e'

    pssh_data_bytes = Base64.strict_decode64('EhBAMOBs3NhPLa/biRaQtcQoEhArAMZNXMdMrY670VYDmdZ+').bytes

    # This is the Widevine PSSH Box v1 built by the Shaka-Packager PSSH tool
    # (https://github.com/google/shaka-packager/tree/master/packager/tools/pssh)
    # for the given key IDs (which produce the input PSSH data above).
    expected_pssh_box = 'AAAAaHBzc2gBAAAA7e+LqXnWSs6jyCfc1R0h7QAAAAJAMOBs3NhPLa/biRaQtcQoKwDGTVzHTK2Ou9FWA5nWfgAAACQSEEAw4Gzc2E8tr9uJFpC1xCgSECsAxk1cx0ytjrvRVgOZ1n4='

    # When
    pssh_box = PsshBox::Builder.build_pssh_box(
        pssh_version,
        WIDEVINE_SYSTEM_ID,
        pssh_data_bytes,
        [first_key_id, second_key_id])

    # Then
    expect(pssh_box).to eql(expected_pssh_box)
  end

  it 'rejects versions other than 0 and 1' do
    # Given
    invalid_pssh_version = 2

    # Then
    expect { PsshBox::Builder.build_pssh_box(invalid_pssh_version, WIDEVINE_SYSTEM_ID, []) }.to raise_error(ArgumentError)
  end
end
