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

t2<-strftime(data$Time, '%H:%M:S')
t3<-data$Date
data<-  within(data, { timestamp=format(as.POSIXct(paste(t3, t2)), "%Y-%m-%d %H:%M:%S") })
data$timestamp<-as.POSIXct(data$timestamp,format="%Y-%m-%d %H:%M:%S")

#-----------------same as plot2.R---------------#

data$Sub_metering_1<-as.numeric(as.matrix(data$Sub_metering_1))
data$Sub_metering_2<-as.numeric(as.matrix(data$Sub_metering_2))
data$Sub_metering_3<-as.numeric(as.matrix(data$Sub_metering_3)) #converts factor columns to numeric

png("plot3.png")

with(data,plot(data$timestamp,data$Sub_metering_1, type="l",xlab="",ylab="Energy sub metering"))
with(data,lines(data$timestamp,data$Sub_metering_2,col="red"))
with(data,lines(data$timestamp,data$Sub_metering_3,col="blue"))
legend("topright",pch="-",col=c("black","blue","red"),legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))

dev.off()