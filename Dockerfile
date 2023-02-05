#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["src/DwitTech.OrderService.WebApi/DwitTech.OrderService.WebApi.csproj", "DwitTech.OrderService.WebApi/"]
COPY . .
WORKDIR "src/DwitTech.OrderService.WebApi"
RUN dotnet restore "DwitTech.OrderService.WebApi.csproj"
RUN dotnet build "DwitTech.OrderService.WebApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DwitTech.OrderService.WebApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DwitTech.OrderService.WebApi.dll"]