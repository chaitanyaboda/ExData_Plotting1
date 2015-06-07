download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","data.tgz", method = "curl")#downloads from the link to local

data <- read.table(unz("data.tgz", "household_power_consumption.txt"),sep=";",header=TRUE)#unzips the file and reads into table

dateConvert<-function(x){
	as.Date(x,'%d/%m/%Y')
} #to convert string to date

data['Date']=lapply(data['Date'],dateConvert) #converts the date column to R date format

data<-data[which(data$Date == as.Date('2007-02-01','%Y-%m-%d') | data$Date == as.Date('2007-02-02','%Y-%m-%d')),] #removes all entries outside the requirement

timeConvert<-function(x){
	strptime(x,'%H:%M:%S')
} # to convert string to time

data['Time']=lapply(data['Time'],timeConvert) #converts the time column to R time that is POSIX format

data$Global_active_power<-as.numeric(as.matrix(data$Global_active_power)) #converts the column from factor to numeric

png("plot1.png")

hist(data$Global_active_power,col="red",main="Global Active Power",xlab="Global Active Power(kilowatts)")
dev.off()
