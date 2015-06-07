download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","data.tgz", method = "curl")

data <- read.table(unz("data.tgz", "household_power_consumption.txt"),sep=";",header=TRUE)

dateConvert<-function(x){
	as.Date(x,'%d/%m/%Y')
}
data<-data
data['Date']=lapply(data['Date'],dateConvert)

data<-data[which(data$Date == as.Date('2007-02-01','%Y-%m-%d') | data$Date == as.Date('2007-02-02','%Y-%m-%d')),]

timeConvert<-function(x){
	strptime(x,'%H:%M:%S')
}

data['Time']=lapply(data['Time'],timeConvert)

data$Global_active_power<-as.numeric(as.matrix(data$Global_active_power))

#-----------------same as plot1.R---------------#

t2<-strftime(data$Time, '%H:%M:S') # extracts just the time from POSIX datetime column Time
t3<-data$Date
data<-  within(data, { timestamp=format(as.POSIXct(paste(t3, t2)), "%Y-%m-%d %H:%M:%S") }) #combines date and time to form a string column timestamp and attaches it to data
data$timestamp<-as.POSIXct(data$timestamp,format="%Y-%m-%d %H:%M:%S") #converts the string column timestamp to POSIX datetime

png("plot2.png")

plot(data$timestamp,data$Global_active_power, type="l",xlab="",ylab="Global_active_power(kilowatts)")

dev.off()


