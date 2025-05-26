default_platform(:ios)

platform :ios do
  lane :beta do
    increment_build_number
    build_app
    upload_to_testflight
  end

  lane :release do
    increment_build_number
    build_app
    upload_to_app_store
  end

  lane :build_app do
    build_ios_app(
      workspace: "StrangerChat.xcworkspace",
      scheme: "StrangerChat",
      configuration: "Release",
      export_method: "app-store",
      export_options: {
        method: "app-store",
        provisioningProfiles: {
          "com.strangerchat.app": "StrangerChat App Store"
        }
      }
    )
  end

  lane :upload_to_testflight do
    pilot(
      api_key_path: ENV["APP_STORE_CONNECT_API_KEY"],
      api_key_issuer_id: ENV["APP_STORE_CONNECT_API_ISSUER_ID"],
      api_key_key_id: ENV["APP_STORE_CONNECT_API_KEY_ID"],
      skip_waiting_for_build_processing: true,
      skip_submission: false,
      distribute_external: true
    )
  end

  lane :upload_to_app_store do
    deliver(
      api_key_path: ENV["APP_STORE_CONNECT_API_KEY"],
      api_key_issuer_id: ENV["APP_STORE_CONNECT_API_ISSUER_ID"],
      api_key_key_id: ENV["APP_STORE_CONNECT_API_KEY_ID"],
      skip_screenshots: true,
      skip_metadata: true,
      force: true
    )
  end
end
