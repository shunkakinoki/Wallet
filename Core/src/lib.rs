pub fn rust_greeting(to: String) -> String {
    return format!("Hello, {}!", to);
}

uniffi_macros::include_scaffolding!("LightWalletCore");
