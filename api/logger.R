library(logger)

# Log format (structured-like)
log_layout(layout_glue_generator(
  format = '{time} | {level} | {msg}'
))

# Log to console (Cloud Run captures this automatically)
log_appender(appender_console)

# Log level
log_threshold(INFO)

log_info("Logger initialized")