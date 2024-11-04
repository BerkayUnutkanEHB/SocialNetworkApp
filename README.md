# Sociaal Netwerk App

## Beschrijving

Dit project is een iOS-app waarmee gebruikers evenementen kunnen maken, bekijken en eraan kunnen deelnemen. De app biedt een realtime chatfunctie en maakt gebruik van **Firebase** voor veilige gegevensopslag en synchronisatie. Gebruikers kunnen evenementen vinden op basis van hun locatie en zich registreren via Firebase Authentication.

## Doel van de Opdracht

- Ervaring opdoen met **Firebase** voor cloudopslag en synchronisatie.
- Een realtime chatfunctie implementeren voor directe communicatie tussen gebruikers.
- Gebruikersauthenticatie opzetten via **Firebase Authentication** voor veilige toegang.
- Locatiegebaseerde evenementweergave integreren met behulp van **CoreLocation**.
- Ontwikkelen van een gebruiksvriendelijke UI/UX voor het aanmaken van evenementen en deelnemen aan chats.

## Functionaliteiten

### Basisfunctionaliteiten

1. **Gebruikersauthenticatie**:
   - Registreren en inloggen via Firebase voor veilige en eenvoudige toegang.

2. **Evenementen maken en bekijken**:
   - Gebruikers kunnen evenementen aanmaken, beschrijvingen toevoegen, en zien welke evenementen binnenkort plaatsvinden.

3. **Realtime Chat**:
   - Mogelijkheid om berichten in realtime te versturen en ontvangen binnen de evenementen-chat.


### Uitbreidingen

1. **Sorteerfunctie voor evenementen**:
   - Gebruikers kunnen evenementen sorteren op alfabetisch en verte.

2. **Profielfoto's instellen**:
   - Gebruikers hebben de optie om een profielfoto te kiezen en toe te voegen aan hun profiel.

3. **Locatie selecteren bij het maken van evenementen**:
   - Bij het aanmaken van een evenement kan de gebruiker een specifieke locatie selecteren.

## Installatie

Volg deze stappen om het project lokaal te installeren en te starten:

1. **Kloon de repository**:

   ```bash
   git clone https://github.com/BerkayUnutkanEHB/SocialNetworkApp.git
   cd sociaal-netwerk-app
   ```

2. **Installeer afhankelijkheden via Swift Package Manager of CocoaPods**:

   - Open je Xcode-project en voeg de Firebase-pakketten toe via Swift Package Manager:
     ```swift
     // Voorbeeld voor Firebase afhankelijkheden in Swift Package Manager
     // URL: https://github.com/firebase/firebase-ios-sdk
     ```

3. **Firebase-configuratie**:
   - Maak een nieuw project aan in de [Firebase Console](https://console.firebase.google.com/).
   - Voeg de `GoogleService-Info.plist` toe aan het Xcode-project om Firebase te configureren.

4. **Open het `.xcworkspace` bestand in Xcode**:

   ```bash
   open sociaal-netwerk-app.xcworkspace
   ```

5. **Start de app in de simulator**:
   - Klik op **Run** of gebruik `Cmd + R` in Xcode.

## Gebruik

Met deze app kunnen gebruikers evenementen organiseren en eraan deelnemen. Ze kunnen evenementen vinden op basis van hun locatie en berichten versturen via de ingebouwde chatfunctie. 

## Licentie

Dit project is gelicentieerd onder de MIT-licentie.

