pub fn timed_log<T>(prefix: &str, action: impl FnOnce() -> T) -> T {
    let start = std::time::Instant::now();
    let result = action();
    let duration = start.elapsed();
    tracing::info!("{prefix} took {}ms", duration.as_millis());
    result
}
