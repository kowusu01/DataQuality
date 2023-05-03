
#FROM mcr.microsoft.com/dotnet/aspnet:6.0 
#WORKDIR /app
#COPY . . 
#EXPOSE 80
#ENTRYPOINT ["dotnet", "TrainService.dll"]

FROM r-base
COPY . /app_base
WORKDIR /appbase

#CMD ["Rscript", "app.R"]