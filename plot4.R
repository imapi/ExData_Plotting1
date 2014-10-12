data_file <- "household_power_consumption.txt"

# Read first row to get start datetime, column classes, column names

first_row <- read.table(data_file, header = TRUE,
                        sep = ";", na.strings = "?", stringsAsFactors = FALSE,
                        nrows = 1)

attach(first_row)

# Save column names for later

column_names <- colnames(first_row)

# First datetime in file; there's one row for each minute

file_start_datetime <- strptime(paste(Date, Time, sep = " "),
                                format = "%d/%m/%Y %H:%M:%S")

# Column classes

classes <- sapply(first_row, class)

# Start and end dt for the range of interest

start_datetime <- strptime("2007-02-01 00:00:00", format = "%Y-%m-%d %H:%M:%S")
end_datetime <- strptime("2007-02-02 23:59:00", format = "%Y-%m-%d %H:%M:%S")

# Determine the number of rows to skip and the number to read

skips <- difftime(start_datetime, file_start_datetime, units = "mins")
reads <- difftime(end_datetime, start_datetime, units = "mins")+1

# Use colClasses, skip and nrows to load data quickly

data <- read.table(data_file, header = TRUE,
                   sep = ";", na.strings = "?",
                   colClasses = classes,
                   skip = skips,
                   nrows = reads)

# Recover column names
colnames(data) <- column_names
dt <- strptime(paste(data$Date, data$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2,2))
plot(dt, data$Global_active_power, type="l", xlab="", ylab="Global Active Power")
plot(dt, data$Voltage, type="l", ylab="Voltage", xlab="datetime")
plot(dt, data$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
points(dt, data$Sub_metering_2,type="l", col="red")
points(dt, data$Sub_metering_3,type="l", col="blue")
legend("topright", col=c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
plot(dt, data$Global_reactive_power,type="l", xlab="datetime", ylab="Global_reactive_power")
dev.off()