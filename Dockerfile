# 1. IMAGEN DE CONSTRUCCIÓN (SDK)
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# 2. COPIAR ARCHIVOS
COPY ["Docker practice/Docker practice.csproj", "Docker practice/"]
COPY ["UserManagement.Application/UserManagement.Application.csproj", "UserManagement.Application/"]
COPY ["UserManagement.Domain/UserManagement.Domain.csproj", "UserManagement.Domain/"]
COPY ["UserManagement.Infrastructure/UserManagement.Infrastructure.csproj", "UserManagement.Infrastructure/"]

# 3. RESTAURAR DEPENDENCIAS
RUN dotnet restore "Docker practice/Docker practice.csproj"

# 4. COPIAR EL CÓDIGO FUENTE
COPY . .

# 5. COMPILAR Y PUBLICAR
WORKDIR "/src/Docker practice"
RUN dotnet build "Docker practice.csproj" -c Release -o /app/build
RUN dotnet publish "Docker practice.csproj" -c Release -o /app/publish

# 6. IMAGEN FINAL (RUNTIME)
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
EXPOSE 8080

COPY --from=build /app/publish .

# COPIAR CREDENCIALES
COPY ["Docker practice/firebase_credentials.json", "."]

ENTRYPOINT ["dotnet", "Docker practice.dll"]
