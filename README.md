
```markdown
# Terraform AWS CodePipeline e CodeBuild (iTalents AWS DEVOPS) 

Este projeto foi desenvolvido com o objetivo de fornecer um código simples, modular e reutilizável para fácil implementação de pipelines de integração contínua (CI) e entrega contínua (CD) na AWS utilizando Terraform. Ele permite a criação de pipelines que integram o AWS CodePipeline e o AWS CodeBuild, oferecendo flexibilidade e rapidez na implementação em outras soluções.

## Pré-requisitos

- [Terraform](https://www.terraform.io/downloads.html) instalado na sua máquina local.
- Credenciais válidas para acessar a AWS.

## Instalação do Terraform

1. Acesse o [site oficial do Terraform](https://www.terraform.io/downloads.html) e baixe a versão correspondente ao seu sistema operacional.
2. Extraia o binário e adicione-o ao seu `PATH`.
3. Verifique a instalação executando `terraform --version` no terminal. Você deve ver a versão instalada retornada.

## Inicialização do Projeto

1. Clone este repositório:
   ```bash
   git clone https://github.com/23Ant/terraform-awscodepipe-codebuild.git
   ```
2. Navegue até o diretório do projeto:
   ```bash
   cd terraform-awscodepipe-codebuild
   ```
3. Inicialize o Terraform:
   ```bash
   terraform init
   ```

## Construção do Código

1. Após inicializar o Terraform, autentique-se na AWS e configure suas credenciais.
2. Execute o seguinte comando para criar o plano de execução:
   ```bash
   terraform plan
   ```
3. Para aplicar as mudanças e provisionar os recursos, execute:
   ```bash
   terraform apply
   ```
   Confirme a aplicação, se solicitada, digitando `yes`.


```

