use extism_pdk::*;

// start with something simple
#[plugin_fn]
pub fn greet(name: String) -> FnResult<String> {
    Ok(format!("Hello, {}!", name))
}

#[plugin_fn]
pub fn add(left: i32) -> FnResult<i32> {
    Ok(left + left)
}
