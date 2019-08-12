FROM microsoft/dotnet:2.2-sdk-alpine3.8 AS build
ARG BUILDCONFIG=RELEASE
ARG VERSION=1.0.0

# copy csproj and restore as distinct layers
COPY DockerWithMicroServices/DockerWithMicroServices.csproj /build/
RUN dotnet restore ./build/DockerWithMicroServices.csproj 

# copy everything else and build app
COPY . ./build/
WORKDIR /build
RUN dotnet publish ./DockerWithMicroServices.csproj -c $BUILDCONFIG -o out /p:Version=$VERSION

FROM microsoft/dotnet:2.2.0-aspnetcore-runtime
WORKDIR /app
COPY --from=build /build/out .
ENTRYPOINT ["dotnet", "DockerWithMicroServices.dll"]