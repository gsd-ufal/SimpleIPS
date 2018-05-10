using Logging
@Logging.configure(level=DEBUG)

#basic_config(DEBUG, log; date_format::String="%Y-%m-%d %H:%M:%S", file_mode::String="a")

#basic_config(level::LogLevel, file_name::String; date_format::String="%Y-%m-%d %H:%M:%S",
# file_mode::String="a")

function macro_log_test()
    @debug("debug message")
    @info("info message")
    @warn("warning message")
    @err("error message")
    @critical("critical message")
end
