packagesToInstall <- c("ConsReg")
for (i in packagesToInstall){
     if(! i %in% installed.packages()){
         install.packages(i, dependencies = TRUE, repos='http://cran.us.r-project.org')
     }
}
