Este é um projeto simples que estou utilizando para estudar o Spring. O projeto prático está sendo desenvolvido a partir de aulas ministradas pelo professor [Nélio Alves](https://github.com/devsuperior).
Parte das imagens abaixo foram disponibilizadas no curso. 
O texto a seguir foi por mim construído, no intuito de documentar o meu progresso com as aulas e também para criar um material do que aprendi/pratiquei, para fins de consultas futuras e revisão.

# Padrão de camadas
Para este projeto, utilizei o padrão de camadas, observando o seguinte esquema:
![enter image description here](https://i.postimg.cc/QNvWkgD7/dslist-layered-pattern.png)

# Modelo de Domínio
Este é o modelo de domínio do projeto
![domain model](https://i.postimg.cc/fWqNS5xc/dslist-model.png)
# Conceitos que pratiquei e outros que aprendi com este projeto

## Padrão de Camadas (Arquitetura em três camadas: Entities, Repositories, Services e Controllers)
A Arquitetura em Camadas normalmente é dividida em três camadas principais:

1.  **Camada de Apresentação (Controllers)**
    -   Responsável pela interface do usuário e pela interação com o usuário.
    -   Lida com a entrada e saída de dados.
    -   Contém os controllers que recebem as requisições HTTP e retornam as respostas.
2.  **Camada de Negócio (Services)**
    -   Contém a lógica de negócios da aplicação.
    -   Realiza o processamento dos dados e aplica as regras de negócio.
    -   Chama os repositórios para acessar os dados e retorna os resultados para os controllers.
3.  **Camada de Dados (Entities e Repositories )**
    -   Gerencia a persistência dos dados.
    -   Contém as entidades que representam as tabelas do banco de dados.
    -   Contém os repositórios que provêm métodos para operações CRUD.

- **Controllers** são classes responsáveis por lidar com as requisições HTTP e devolver as respostas HTTP. Eles recebem as requisições do cliente, chamam os serviços apropriados, e retornam os dados ou resultados ao cliente. Em frameworks web como o Spring, os controllers são anotados com @RestController ou @Controller.
- **Services** são classes que contêm a lógica de negócios da aplicação. Eles são responsáveis por processar dados, aplicar regras de negócio e orquestrar chamadas a repositórios e outros serviços. Usar serviços ajuda a manter a separação de preocupações e facilita a manutenção do código.
- **Entities** são objetos que representam tabelas no banco de dados. Cada instância de uma entidade corresponde a uma linha na tabela. Eles são usados para mapear os dados do banco de dados para objetos em seu código usando ORM (Object-Relational Mapping).
- **Repositories** são interfaces que provêm mecanismos para operações CRUD (Create, Read, Update, Delete) nas entidades. Eles abstraem a camada de persistência e permitem que você trabalhe com os dados sem precisar escrever código SQL diretamente.

## Injeção de Dependência e Inversão de Controle
### Injeção de Dependência (DI)
**Injeção de Dependência** permite que objetos recebam suas dependências de uma fonte externa em vez de criarem suas próprias dependências.
Uma **dependência** refere-se a um objeto que uma classe precisa para executar sua função. Em outras palavras, se a classe `A` usa a classe `B` para realizar algumas de suas tarefas, `B` é uma dependência de `A`.

### Inversão de Controle (IoC)
**Inversão de Controle** permite que o controle da criação e gerenciamento dos objetos seja transferido do código para um contêiner ou framework, neste caso o Spring. O termo "Inversão" refere-se ao fato de que, em vez de um objeto criar suas dependências, o contêiner é responsável por fornecer as dependências necessárias.

Um **contêiner do Spring**, chamado **Spring IoC Container (Inversion of Control Container)**, é um componente central do Spring Framework que gerencia a criação, configuração e ciclo de vida dos **beans** (objetos) em uma aplicação. 
**Bean**: No contexto do Spring, um bean é simplesmente um objeto que é instanciado, montado e gerenciado pelo contêiner Spring.  Os Beans são definidos na configuração da aplicação (através de arquivos XML, anotações ou classe Java com a anotação `@Configuration`).

**Tipos de Contêiner Spring**:
    -   O **BeanFactory** é a implementação mais básica do contêiner. Ele fornece a configuração básica e a criação de beans.
    -   O **ApplicationContext** é uma implementação mais avançada que adiciona funcionalidades como suporte a eventos, mensagens internacionais e injeção de dependência automática.

**Configuração de Beans**:
    -   **Anotações** como `@Component`, `@Service`, `@Repository` e `@Controller` são usadas para marcar classes como beans.
    -   **Classes Java** com a anotação `@Configuration` e métodos anotados com `@Bean` também são usadas para definir beans.

**Injeção de Dependência (DI)**:
    -   O Spring IoC Container é responsável por injetar as dependências dos beans. Isso pode ser feito através de **injeção de construtor**, **injeção de método setter** ou **injeção de campo**.

**Ciclo de Vida dos Beans**:
    -   O contêiner Spring gerencia todo o ciclo de vida dos beans, desde a criação até a destruição.

## DTO
DTO é a sigla para "Data Transfer Object" (Objeto de Transferência de Dados, em português). Ele é um padrão de design usado para transferir dados entre diferentes camadas de uma aplicação. O principal objetivo de um DTO é encapsular dados e transportá-los sem expor detalhes de implementação de outras camadas, como a camada de persistência (banco de dados) ou a camada de lógica de negócios.
### Vantagens de Usar DTOs
-   **Encapsulamento**: Isola detalhes de implementação e mantém a separação de preocupações.
-   **Redução de Dados**: Permite transferir apenas os dados necessários, evitando a transferência de informações desnecessárias.
-   **Segurança**: Reduz o risco de expor detalhes sensíveis da aplicação.
-   **Facilidade de Uso**: Facilita a serialização e desserialização de dados para formatos como JSON ou XML.

## Consultas SQL personalizadas no Spring Data JPA
Esse tipo de personalização permite a escrita de consultas mais complexas diretamente nos métodos do repositório, o que pode ser útil para resolver alguns problemas de recuperação de dados do banco quando as consultas automáticas geradas pelo Spring Data JPA não são suficientes. A consulta pode ser com SQL ou JPQL. Exemplo com JPQL:
```java 
public interface GameRepository extends JpaRepository<Game, Long> {
    @Query("SELECT g FROM Game g WHERE g.title = :title")
    List<Game> findByTitle(@Param("title") String title);
}
```
Exemplo com SQL:
```java
public interface GameRepository extends JpaRepository<Game, Long> {

    @Query(nativeQuery = true, value = """
        SELECT tb_game.id, tb_game.title, tb_game.game_year AS gameYear, tb_game.img_url AS imgUrl,
        tb_game.short_description AS shortDescription, tb_belonging.position
        FROM tb_game
        INNER JOIN tb_belonging ON tb_game.id = tb_belonging.game_id
        WHERE tb_belonging.list_id = :listId
        ORDER BY tb_belonging.position
        """)
    List<GameMinProjection> searchByList(@Param("listId") Long listId);
}
```

