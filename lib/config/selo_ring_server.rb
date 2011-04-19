Configuration.for('selo_ring') {
  daemon {
    dir_mode   :normal
    multiple   false
    backtrace  true
    monitor    true
    log_output true
  }

  server {
    safe_level 1
    verbose    true
    uri        "druby://localhost:9000"
  }
}
