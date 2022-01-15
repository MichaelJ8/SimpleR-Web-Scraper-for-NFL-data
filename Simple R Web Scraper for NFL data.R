#web scraper to gather nfl stats from rotoguru (please review website for scraping rules before scraping)
dflist <- map(.x = 1:17, .f = function(x) {
  Sys.sleep(1)
  url <- paste0("http://rotoguru1.com/cgi-bin/fyday.pl?week=",x,"&game=fd&scsv=1")
  read_html(url) %>%
    html_nodes("pre") %>%
    html_text() %>%
    as.data.frame()
}) %>% do.call(rbind, .)

#create table
write.table(dflist,"Fantasy FB data full",row.names=FALSE, col.names=FALSE, quote=FALSE)
url_df_list<-read.delim("Fantasy FB data full", sep=";", header=FALSE)
url_df_list<-url_df_list[rowSums(url_df_list=="")!=ncol(url_df_list),]
url_df_list<-url_df_list[!(url_df_list$V1=="Week"),]
write.table(url_df_list,"Fantasy FB data full",sep=";",row.names=FALSE, col.names=TRUE, quote=FALSE)
url_table_final<-read.delim("Fantasy FB data full", sep=";",header=TRUE)
colnames(url_table_final)<-c("Week","Year","GID","Name","Pos","Team","h/a","Oppt","FD_points","FD_salary")

#make some basic features
url_table_final<-url_table_final%>%group_by(Name)%>%mutate(FD_SALARY_AVG=mean(FD_salary), FD_points_AVG=mean(FD_points))%>%filter(FD_SALARY_AVG>0)%>%ungroup()
head(url_table_final)
summary(url_table_final)

#now go do your own predictive analytics and make more features
