# Etapa 1: Construção da imagem com Maven
FROM maven:3.8.4-openjdk-17-slim AS build

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o arquivo pom.xml e os arquivos de código-fonte para o contêiner
COPY pom.xml .
COPY src ./src

# Compile o projeto usando Maven
RUN mvn clean package -DskipTests

# Etapa 2: Construção da imagem final para execução
FROM openjdk:17-jdk-slim

# Defina o diretório de trabalho dentro do contêiner
WORKDIR /app

# Copie o arquivo JAR da etapa de construção
COPY --from=build /app/target/*.jar app.jar

# Exponha a porta que sua aplicação Spring Boot vai usar
EXPOSE 8080

# Defina o comando para executar o aplicativo
ENTRYPOINT ["java", "-jar", "app.jar"]
