# flutter_workout_tracker

Aplikacja do zapisywania treningów na siłowni.

## Instrukcja
Aby dodać partię mięśniową lub ćwiczenie, naciśnij ‘+’ w górnym menu, znajdując się odpowiednio na ekranie wyboru partii/ćwiczenia.
Aby przejść do następnego pola formularza/wysłać go, możesz użyć klawiatury. Dotyczy to też zapisywania/edytowania serii oraz czasu odstępu i inkrementu wagi.
Aby klawiatura zniknęła, dotknij w dowolnym miejscu ekranu (oprócz TabBara).
Aby edytować/usunąć serię, dotknij jej wpis w ‘Recorded Sets’ .
Możesz dotykać punktów wykresu, aby zobaczyć informacje o nich.
Aby zmienić czas odstępu między seriami dla danego ćwiczenia, kliknij w niebieski przycisk zegara. Jest on dostępny tylko wtedy, gdy nie ma aktualnego odliczania do powiadomienia.

## Ekrany
*	Ekrany wyboru ćwiczenia: lista partii mięśniowych -> lista ćwiczeń na daną partię
*	Ekran zapisywania serii (wybranego wcześniej ćwiczenia)
*	Ekran historii wybranego ćwiczenia – lista wszystkich serii danego ćwiczenia (ciężar, liczba powtórzeń, data)
*	Ekran historii wybranego ćwiczenia – wykres ciężaru w czasie

## User stories
*	Jako użytkownik mogę dodać własną partię
*	Jako użytkownik mogę dodać własne ćwiczenie
*	Jako użytkownik mogę ustawić/ zmienić czas odstępu między seriami (dla danego ćwiczenia)
*	Jako użytkownik mogę zapisywać serie ćwiczeń z aktualnej bazy (predefiniowane + dodane przeze mnie)
*	Jako użytkownik mogę edytować lub usuwać serie aktualnego (dzisiejszego) treningu
*	Jako użytkownik mogę widzieć, ile czasu zostało do powiadomienia o następnej serii
*	Jako użytkownik mogę zmieniać czas odstępu do (powiadomienia o) następnej serii
*	Jako użytkownik mogę zmieniać inkrementy wagi, czyli o ile kg zmieniają wagę przyciski ‘-‘ / ‘+’ (dla danego ćwiczenia)
*	Jako użytkownik mogę przeglądać wszystkie serie danego ćwiczenia (w historii)
*	Jako użytkownik mogę zobaczyć wykres ciężaru w czasie dla danego ćwiczenia


## Integracje
*	audioplayers: ^5.2.1
*	fl_chart: ^0.65.0
*	shared_preferences: ^2.2.2

## Ekrany - zrzuty ekranu


![Screenshot_2024-02-19-11-06-40-29_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/80a07861-8b2c-4598-b2dc-9c46edb09250)
![Screenshot_2024-02-19-11-06-48-14_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/289b1341-60a3-4f36-a85c-f9043911be1d)
![Screenshot_2024-02-19-11-06-51-69_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/8e8fed3c-8cdb-4210-ac13-79a0c6147876)
![Screenshot_2024-02-19-11-07-00-09_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/72729766-a4e6-4079-8653-109c180f5ebf)
![Screenshot_2024-02-19-11-07-12-03_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/c2fb382d-6be6-43cb-a036-3e957a83bf30)
![Screenshot_2024-02-19-11-07-44-09_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/e14d400c-ea26-42f7-b415-3d30ba3627f3)
![Screenshot_2024-02-19-11-08-00-16_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/3e884f50-556d-4ee5-b745-e4063e92c99f)
![Screenshot_2024-02-19-11-08-20-09_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/6e21b10c-030f-4a6c-85bd-c2893475bc01)
![Screenshot_2024-02-19-11-08-23-82_b2e6ddb98ad5498950d6bb58f30ad800](https://github.com/glowacz/flutter_workout_tracker/assets/94084660/7447c841-4276-4528-98a3-bbaffe65c4f7)
