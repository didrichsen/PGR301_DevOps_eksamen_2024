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

```

## Oppgave 4
Det er satt opp en, DevOpsEksamen2024-40-sqs-age-alarm, som sender mail til variablen som er lagt inn med en default inn under variables.tf.
Alarmen går hvis en melding blir liggende lenger enn 5 sekunder.

## Oppgave 5

## Automatisering og kontinuerlig levering (CI/CD):

### Serverless
En serverless FaaS-applikasjon gjør det enkelt å distribuere koden, ettersom alt er delt opp i små, uavhengige funksjoner. Deploy skjer ofte via konfigurasjonsfiler som tydelig angir hvilke innstillinger som gjelder, og gir full oversikt over tidligere versjoner gjennom versjonskontrollsystemer.

Deploy av enkeltfunksjoner åpner for rask utrulling og continues integration, da det ikke er behov for å håndtere flere komponenter samtidig. Dette kan føre til en mer strømlinjeformet og fleksibel deployment prosess.

En ulempe ved å deploye små, uavhengige funksjoner er at de kan være avhengige av hverandre, noe som kan komplisere håndteringen sammenlignet med mikrotjenestebaserte applikasjoner, der koden vanligvis er mer samlet. I tillegg kan det være behov for ekstra verktøy for å håndtere disse avhengighetene, noe som kan gjøre systemet mer utfordrende å teste og administrere.

### Mikrotjenester
Hver mikrotjeneste kan ha sitt eget repository, som gjør det enklere å sette opp en solid CI/CD-pipeline. Ved å ha all koden for en tjeneste i ett repository, blir det enklere å automatisere tester som dekker hele tjenesten.

Mikrotjenester krever imidlertid mer infrastruktur for å håndtere distribusjon og testing, som kan innebære ekstra kompleksitet. Dette er noe som serverless-plattformer ofte tar seg av, og dermed reduserer den operasjonelle belastningen på DevOps-teamet. Mikrotjenester kan derfor ha en mer krevende oppsettfase, selv om det finnes gode verktøy for å håndtere infrastrukturen.

## Observability (overvåkning):

### Serverless 
En serverless FaaS-applikasjon kan dra nytte av overvåkningsverktøy levert av serverless-leverandører som AWS CloudWatch, 
Azure Monitor eller tilsvarende. Disse verktøyene tilbyr god innsikt i ytelsen til individuelle funksjoner. 
Dette gjør det mulig å overvåke funksjonene i sanntid.

En utfordring med serverless arkitektur er imidlertid debugging, spesielt i et miljø med mange distribuerte funksjoner. 
Når funksjoner er avhengig av hverandre kan det være vanskelig å identifisere hvor en feil oppstår eller å spore 
hvordan data flyter gjennom systemet.

### Microservice 
En applikasjon bygget med en mikrotjenestearkitektur kan være enklere å teste og overvåke hvis logger samles og struktureres på en god måte. 
Hver tjeneste i en slik arkitektur inneholder all funksjonalitet den trenger for å operere selvstendig, uten direkte avhengighet av andre tjenester. 
Dette gjør det enklere å isolere feil til en spesifikk tjeneste, noe som kan forenkle feilsøking sammenlignet med serverless-arkitekturer.

En mulig utfordring ligger likevel i at man må feilsøke på tvers av tjenester som samhandler. 
Selv om dette kan komplisere prosessen, kan en velimplementert overvåkningsstack, som bruker verktøy for logging og 
overvåkning, gjøre denne utfordringen håndterbar.

## Skalerbarhet og kostnadskontroll

### Serverless
En serverless FaaS-applikasjon kan være et svært kostnadseffektivt alternativ når trafikken varierer. Kostnadene er basert på faktisk bruk, og for eksempel Amazon fakturerer ned til millisekunder, noe som betyr at du kun betaler for den tiden funksjonene faktisk kjører.

I tillegg til kostnadseffektivitet kan serverless-applikasjoner skalere opp automatisk ved høy trafikk. Cloud-leverandører som Amazon har mekanismer som håndterer denne skaleringsprosessen, noe som gjør det enklere å takle økt trafikk uten å administrere infrastruktur manuelt.

Ulemper kan imidlertid oppstå ved jevn og høy trafikk. Da kan kostnadene for serverless bli høyere enn for containerbaserte eller mikrotjenestebaserte arkitekturer som tilbyr faste og forutseigbare kostnader. En annen utfordring med serverless er kaldstart (cold start), der funksjoner som har vært inaktive bruker lengre tid på oppstart.

Videre kan skaleringen av en funksjon føre til økt belastning på integrerte tjenester som SQS, DynamoDB eller S3. Disse må også være dimensjonert for å håndtere den ekstra trafikken som genereres av skalerte funksjoner.

### Microservice
Mikrotjenestearkitekturer har en annen tilnærming, der tjenestene vanligvis kjører kontinuerlig. Dette kan være mer kostnadseffektivt hvis systemet opplever en jevn strøm av data og forespørsler siden man unngår kostnadene knyttet til funksjonsbasert fakturering.

Mikrotjenestearkitekturer tillater skalering av individuelle tjenester, men skaleringsprosessen er ofte mer kompleks sammenlignet med serverless. I mange tilfeller må hele tjenesten skaleres, selv om det bare er spesifikke funksjoner eller deler av tjenesten som opplever økt belastning. Dette kan føre til ineffektiv ressursbruk.

For applikasjoner med varierende trafikkmønstre kan den kontinuerlige driften av mikrotjenester skape unødvendige kostnader, særlig hvis noen tjenester kjører uten å være i aktiv bruk.

## Eierskap og ansvar 

### Serverless 
I en serverless-applikasjon kan utviklere fokusere mer på applikasjonslogikk, ettersom mye av infrastrukturen håndteres av cloud-leverandøren. Dette inkluderer oppgaver som administrasjon av servere, oppdateringer og patching, noe som reduserer driftansvaret for utviklingsteamet. Resultatet er at teamet kan bruke mer tid på koding og utvikling av forretningslogikk, mens leverandøren sørger for at infrastrukturen er oppdatert og skalerbar.

En utfordring med dette er at teamet blir sterkt avhengig av leverandørens infrastruktur, noe som kan føre til at man låses til en hvis grad til leverandøren. Dette kan gjøre det vanskeligere å feilsøke og få full oversikt over systemet, spesielt når leverandøren håndterer mye av driften i bakgrunnen.

Eierskap til applikasjonen kan også bli fragmentert, da systemet ofte består av mange enkeltfunksjoner. Dette kan gjøre det mer utfordrende å holde oversikt over hvordan ulike funksjoner samhandler og påvirker hverandre.

### Microservice
En applikasjon med en mikrotjenestearkitektur plasserer mer av ansvaret for infrastruktur, som patching og serveradministrasjon, på hvert enkelt utviklerteam. Dette gir teamene større kontroll over den underliggende infrastrukturen og reduserer avhengigheten av en spesifikk cloud-leverandør.

En mikrotjenestearkitektur kan også gjøre det enklere for utviklere å få tydelig eierskap over tjenestene de jobber med, siden all nødvendig funksjonalitet ofte er samlet i ett repository med et klart skille for hver enkelt tjeneste.

Videre kan utviklere spesialisere seg innenfor sitt ansvarsområde, noe som styrker eierskapet og bidrar til bedre forståelse og drift av tjenesten de utvikler.



