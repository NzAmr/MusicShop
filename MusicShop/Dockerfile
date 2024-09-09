FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

COPY MusicShop.sln ./
COPY MusicShop/ MusicShop/
COPY MusicShop.Model/ MusicShop.Model/
COPY MusicShop.Services/ MusicShop.Services/

RUN dotnet restore MusicShop/MusicShop.csproj
RUN dotnet build MusicShop/MusicShop.csproj -c Release -o /app/build

FROM build AS publish
RUN dotnet publish MusicShop/MusicShop.csproj -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MusicShop.dll"]
