# README

## Oppgave 1

### a)
API: https://d7s36trw2m.execute-api.eu-west-1.amazonaws.com/Prod/generate-image

### b)
Github actions workflow: https://github.com/didrichsen/PGR301_DevOps_eksamen_2024/actions/runs/11800910514

Gå over de 4 warnings som finnes.

## Oppgave 2

- **Workflow run on main**  
  https://github.com/didrichsen/PGR301_DevOps_eksamen_2024/actions/runs/11818956184/job/32927745362

- **Workflow run on another branch**  
  https://github.com/didrichsen/PGR301_DevOps_eksamen_2024/actions/runs/11837415068/job/32984333691

- **SQS-kø**  
  https://sqs.eu-west-1.amazonaws.com/244530008913/DevOpsEksamen2024-_40_lambda_queue

## Oppgave 3

### Beskrivelse av tagge-strategien for container imagene:
Jeg har valgt en strategi der hvert container image tagges med to forskjellige tagger:

- **`latest`**: Representerer alltid den nyeste versjonen av imaget. Dette er nyttig for testing og utvikling, da det gir en enkel måte å referere til den seneste versjonen.
- **Commit-hash-taggen**: (for eksempel `abc1234`) gir en unik referanse til den spesifikke versjonen av koden som ble brukt til å bygge imaget. Dette gjør det mulig å spore tilbake til den eksakte kildekoden.

**Begrunnelse for strategien:**
Ved å bruke `latest` kan utviklere og testmiljøer hente og kjøre den nyeste tilgjengelige versjonen. Ved å ha commit-hash som en del av taggen sikrer jeg sporbarhet; hver unike tag peker til en spesifikk tilstand i koden.

### Container Image:
**didrichsen/java-sqs-client:latest**

```bash
docker run -e AWS_ACCESS_KEY_ID=XXX -e AWS_SECRET_ACCESS_KEY=XXX -e SQS_QUEUE_URL=https://sqs.eu-west-1.amazonaws.com/244530008913/DevOpsEksamen2024-_40_lambda_queue didrichsen/java-sqs-client:latest "me on top of a baloon"
