#!/usr/bin/env bash
# ==========================================================================
# dialoom_backend_snapshot.sh
# Este script recreará la estructura de carpetas y archivos de tu backend
# tal como estaba cuando lo generaste con "compri.sh".
# ==========================================================================

echo 'Creando estructura de directorios...'
mkdir -p "."
mkdir -p "locales"
mkdir -p "test"
mkdir -p "Firebase"
mkdir -p "src"
mkdir -p "src/types"
mkdir -p "src/config"
mkdir -p "src/auth"
mkdir -p "src/auth/guards"
mkdir -p "src/common"
mkdir -p "src/common/interceptors"
mkdir -p "src/common/decorators"
mkdir -p "src/common/guards"
mkdir -p "src/modules"
mkdir -p "src/modules/payments"
mkdir -p "src/modules/payments/entities"
mkdir -p "src/modules/auth"
mkdir -p "src/modules/auth/strategies"
mkdir -p "src/modules/auth/guards"
mkdir -p "src/modules/gamification"
mkdir -p "src/modules/gamification/entities"
mkdir -p "src/modules/admin"
mkdir -p "src/modules/admin/entities"
mkdir -p "src/modules/support"
mkdir -p "src/modules/support/entities"
mkdir -p "src/modules/users"
mkdir -p "src/modules/users/entities"
mkdir -p "src/modules/notifications"
mkdir -p "src/modules/notifications/entities"
mkdir -p "src/modules/notifications/channels"

echo 'Creando ficheros...'
cat << '__EOC__' > ".DS_Store"
Bud1
lesbwspbllocalesbwspblobbplist00]ShowStatusBar[ShowToolbar[ShowTabView_ContainerShowSidebar\WindowBounds[ShowSidebar		_{{550, -61}, {1043, 1055}}	#/;R_klmnolocalesdsclboollocaleslg1ScomplocalesmoDDblobAlocalesmodDblobAlocalesph1ScompPlocalesvSrnlongsrcdsclboolsrclg1Scomp<srcmoDDblobX_AsrcmodDblobX_Asrcph1Scomptestdsclbooltestlg1ScomptestmoDDblob9AtestmodDblob9Atestph1Scomp @ @ @ @E
DSDB \` @ @ @
__EOC__

cat << '__EOC__' > "locales/nl.yaml"
errors:
  unexpected_error: "Er is een onverwachte fout opgetreden. Probeer het later opnieuw."
  invalid_credentials: "Ongeldige gebruikersnaam of wachtwoord."
  unauthorized: "Je bent niet bevoegd om deze actie uit te voeren."
  forbidden: "Toegang geweigerd."
  not_found: "Bron niet gevonden."
  user_not_found: "Gebruiker niet gevonden."
  email_exists: "Dit e-mailadres is al in gebruik."
  username_exists: "Deze gebruikersnaam is al in gebruik."
  account_disabled: "Dit account is gedeactiveerd."
  session_expired: "Sessie verlopen. Log opnieuw in."
  rate_limit: "Te veel aanvragen. Probeer het later opnieuw."
  server_error: "Interne serverfout."
validation:
  required_field: "Dit veld is verplicht."
  invalid_email: "Vul een geldig e-mailadres in."
  min_length: "Moet minimaal {min} tekens bevatten."
  max_length: "Mag maximaal {max} tekens bevatten."
  password_mismatch: "Wachtwoorden komen niet overeen."
  invalid_format: "Ongeldig formaat."
  only_numbers: "Alleen numerieke waarden zijn toegestaan."
  min_value: "Waarde moet minimaal {min} zijn."
  max_value: "Waarde mag maximaal {max} zijn."
  too_short: "Te kort."
  too_long: "Te lang."
notifications:
  new_message: "Nieuw bericht van {name}."
  friend_request: "Je hebt een nieuw vriendverzoek."
  meeting_reminder: "Herinnering: vergadering \"{title}\" om {time}."
  task_due_soon: "Taak \"{task}\" verloopt binnenkort."
  new_notification: "Je hebt een nieuwe melding."
  promo_offer: "Nieuwe promotionele aanbieding beschikbaar."
  account_approved: "Je account is goedgekeurd."
  account_rejected: "Je account is afgekeurd."
  update_available: "Een nieuwe update is beschikbaar."
  event_starting: "Het evenement \"{event}\" begint nu."
emails:
  welcome_subject: "Welkom bij Dialoom!"
  welcome_body: "Hallo {name},\n\nBedankt voor je aanmelding bij Dialoom. We zijn blij dat je erbij bent. Als je vragen hebt, neem dan gerust contact op met ons ondersteuningsteam.\n\nMet vriendelijke groet,\nHet Dialoom-team"
  reset_password_subject: "Stel je Dialoom-wachtwoord opnieuw in"
  reset_password_body: "Hallo {name},\n\nWe hebben een verzoek ontvangen om je wachtwoord opnieuw in te stellen. Klik op de onderstaande link om een nieuw wachtwoord in te stellen. Als je deze aanvraag niet hebt gedaan, kun je deze e-mail negeren.\n\nBedankt,\nDialoom ondersteuning"
  verify_email_subject: "Bevestig je e-mailadres"
  verify_email_body: "Hallo {name},\n\nBevestig je e-mailadres door op de onderstaande link te klikken. Als je geen Dialoom-account hebt aangemaakt, kun je deze e-mail negeren.\n\nBedankt,\nHet Dialoom-team"
  password_changed_subject: "Je wachtwoord is gewijzigd"
  password_changed_body: "Hallo {name},\n\nDit is een bevestiging dat je wachtwoord succesvol is gewijzigd. Als je deze wijziging niet hebt uitgevoerd, neem dan onmiddellijk contact op met onze ondersteuning.\n\nMet vriendelijke groet,\nHet Dialoom-team"
api:
  created_success: "Met succes aangemaakt."
  updated_success: "Met succes bijgewerkt."
  deleted_success: "Met succes verwijderd."
  operation_success: "Bewerking succesvol voltooid."
  operation_failed: "Bewerking mislukt."
  invalid_token: "Ongeldige token."
  authentication_required: "Authenticatie vereist."
  permission_denied: "Toestemming geweigerd."
  resource_not_found: "Bron niet gevonden."
  bad_request: "Ongeldig verzoek."
  conflict_error: "Conflictfout."
  server_error: "Serverfout."
  service_unavailable: "Dienst niet beschikbaar. Probeer het later opnieuw."
  too_many_requests: "Te veel verzoeken."
  missing_fields: "Verplichte velden ontbreken."
  invalid_parameters: "Ongeldige parameters."
  method_not_allowed: "Methode niet toegestaan."
  request_timeout: "Time-out van verzoek."
general:
  ok: "OK"
  cancel: "Annuleren"
  confirm: "Bevestigen"
  yes: "Ja"
  no: "Nee"
  back: "Terug"
  next: "Volgende"
  close: "Sluiten"
  save: "Opslaan"
  delete: "Verwijderen"
  search: "Zoeken"
  login: "Inloggen"
  logout: "Uitloggen"
  sign_up: "Registreren"
  profile: "Profiel"
  settings: "Instellingen"
  send: "Verzenden"
  submit: "Indienen"
  loading: "Laden..."
  no_results: "Geen resultaten gevonden."
  welcome: "Welkom!"
  goodbye: "Tot ziens!"
  thank_you: "Bedankt."
  try_again: "Probeer het opnieuw."
  contact_support: "Neem contact op met de ondersteuning."
__EOC__

cat << '__EOC__' > "locales/en.yaml"
errors:
  unexpected_error: "An unexpected error occurred. Please try again later."
  invalid_credentials: "Invalid username or password."
  unauthorized: "You are not authorized to perform this action."
  forbidden: "Access forbidden."
  not_found: "Resource not found."
  user_not_found: "User not found."
  email_exists: "This email address is already in use."
  username_exists: "This username is already taken."
  account_disabled: "This account has been disabled."
  session_expired: "Session expired. Please log in again."
  rate_limit: "Too many requests. Please try again later."
  server_error: "Internal server error."
validation:
  required_field: "This field is required."
  invalid_email: "Please enter a valid email address."
  min_length: "Must be at least {min} characters."
  max_length: "Must be at most {max} characters."
  password_mismatch: "Passwords do not match."
  invalid_format: "Invalid format."
  only_numbers: "Only numeric values are allowed."
  min_value: "Value must be at least {min}."
  max_value: "Value must be at most {max}."
  too_short: "Too short."
  too_long: "Too long."
notifications:
  new_message: "New message from {name}."
  friend_request: "You have a new friend request."
  meeting_reminder: "Reminder: Meeting \"{title}\" at {time}."
  task_due_soon: "Task \"{task}\" is due soon."
  new_notification: "You have a new notification."
  promo_offer: "New promotional offer available."
  account_approved: "Your account has been approved."
  account_rejected: "Your account has been rejected."
  update_available: "A new update is available."
  event_starting: "Event \"{event}\" is starting now."
emails:
  welcome_subject: "Welcome to Dialoom!"
  welcome_body: "Hello {name},\n\nThank you for joining Dialoom. We're excited to have you on board. If you have any questions, feel free to contact our support team.\n\nBest regards,\nThe Dialoom Team"
  reset_password_subject: "Reset your Dialoom password"
  reset_password_body: "Hello {name},\n\nWe received a request to reset your password. Click the link below to set a new password. If you didn’t request this, please ignore this email.\n\nThank you,\nDialoom Support"
  verify_email_subject: "Verify your email address"
  verify_email_body: "Hello {name},\n\nPlease verify your email address by clicking the link below. If you did not create a Dialoom account, you can ignore this email.\n\nThank you,\nThe Dialoom Team"
  password_changed_subject: "Your password has been changed"
  password_changed_body: "Hello {name},\n\nThis is a confirmation that your password was successfully changed. If you did not make this change, please contact support immediately.\n\nRegards,\nThe Dialoom Team"
api:
  created_success: "Created successfully."
  updated_success: "Updated successfully."
  deleted_success: "Deleted successfully."
  operation_success: "Operation completed successfully."
  operation_failed: "Operation failed."
  invalid_token: "Invalid token."
  authentication_required: "Authentication is required."
  permission_denied: "Permission denied."
  resource_not_found: "Resource not found."
  bad_request: "Bad request."
  conflict_error: "Conflict error."
  server_error: "Server error."
  service_unavailable: "Service unavailable. Please try again later."
  too_many_requests: "Too many requests."
  missing_fields: "Missing required fields."
  invalid_parameters: "Invalid parameters."
  method_not_allowed: "Method not allowed."
  request_timeout: "Request timeout."
general:
  ok: "OK"
  cancel: "Cancel"
  confirm: "Confirm"
  yes: "Yes"
  no: "No"
  back: "Back"
  next: "Next"
  close: "Close"
  save: "Save"
  delete: "Delete"
  search: "Search"
  login: "Log In"
  logout: "Log Out"
  sign_up: "Sign Up"
  profile: "Profile"
  settings: "Settings"
  send: "Send"
  submit: "Submit"
  loading: "Loading..."
  no_results: "No results found."
  welcome: "Welcome!"
  goodbye: "Goodbye!"
  thank_you: "Thank you."
  try_again: "Please try again."
  contact_support: "Contact support."
__EOC__

cat << '__EOC__' > "locales/it.yaml"
errors:
  unexpected_error: "Si è verificato un errore imprevisto. Per favore riprova più tardi."
  invalid_credentials: "Nome utente o password non validi."
  unauthorized: "Non sei autorizzato a eseguire questa azione."
  forbidden: "Accesso negato."
  not_found: "Risorsa non trovata."
  user_not_found: "Utente non trovato."
  email_exists: "Questo indirizzo email è già in uso."
  username_exists: "Questo nome utente è già in uso."
  account_disabled: "Questo account è stato disabilitato."
  session_expired: "La sessione è scaduta. Effettua di nuovo l'accesso."
  rate_limit: "Troppe richieste. Riprova più tardi."
  server_error: "Errore interno del server."
validation:
  required_field: "Questo campo è obbligatorio."
  invalid_email: "Per favore, inserisci un indirizzo email valido."
  min_length: "Deve contenere almeno {min} caratteri."
  max_length: "Può contenere al massimo {max} caratteri."
  password_mismatch: "Le password non corrispondono."
  invalid_format: "Formato non valido."
  only_numbers: "Sono consentiti solo valori numerici."
  min_value: "Il valore deve essere almeno {min}."
  max_value: "Il valore deve essere al massimo {max}."
  too_short: "Troppo corto."
  too_long: "Troppo lungo."
notifications:
  new_message: "Nuovo messaggio da {name}."
  friend_request: "Hai una nuova richiesta di amicizia."
  meeting_reminder: "Promemoria: riunione \"{title}\" alle {time}."
  task_due_soon: "L'attività \"{task}\" scade a breve."
  new_notification: "Hai una nuova notifica."
  promo_offer: "Nuova offerta promozionale disponibile."
  account_approved: "Il tuo account è stato approvato."
  account_rejected: "Il tuo account è stato rifiutato."
  update_available: "È disponibile un nuovo aggiornamento."
  event_starting: "L'evento \"{event}\" sta iniziando ora."
emails:
  welcome_subject: "Benvenuto su Dialoom!"
  welcome_body: "Ciao {name},\n\nGrazie per esserti unito a Dialoom. Siamo entusiasti di averti con noi. Se hai domande, non esitare a contattare il nostro team di supporto.\n\nCordiali saluti,\nIl team di Dialoom"
  reset_password_subject: "Reimposta la tua password Dialoom"
  reset_password_body: "Ciao {name},\n\nAbbiamo ricevuto una richiesta di reimpostazione della tua password. Clicca sul link sottostante per impostare una nuova password. Se non hai richiesto questo, ignora questa email.\n\nGrazie,\nIl team di supporto Dialoom"
  verify_email_subject: "Verifica il tuo indirizzo email"
  verify_email_body: "Ciao {name},\n\nPer favore verifica il tuo indirizzo email cliccando sul link qui sotto. Se non hai creato un account Dialoom, puoi ignorare questa email.\n\nGrazie,\nIl team di Dialoom"
  password_changed_subject: "La tua password è stata cambiata"
  password_changed_body: "Ciao {name},\n\nTi confermiamo che la tua password è stata cambiata con successo. Se non hai effettuato questo cambiamento, contatta immediatamente il supporto.\n\nCordiali saluti,\nIl team di Dialoom"
api:
  created_success: "Creato con successo."
  updated_success: "Aggiornato con successo."
  deleted_success: "Eliminato con successo."
  operation_success: "Operazione completata con successo."
  operation_failed: "Operazione non riuscita."
  invalid_token: "Token non valido."
  authentication_required: "Autenticazione richiesta."
  permission_denied: "Permesso negato."
  resource_not_found: "Risorsa non trovata."
  bad_request: "Richiesta non valida."
  conflict_error: "Errore di conflitto."
  server_error: "Errore del server."
  service_unavailable: "Servizio non disponibile. Riprova più tardi."
  too_many_requests: "Troppe richieste."
  missing_fields: "Campi obbligatori mancanti."
  invalid_parameters: "Parametri non validi."
  method_not_allowed: "Metodo non consentito."
  request_timeout: "Timeout della richiesta."
general:
  ok: "OK"
  cancel: "Annulla"
  confirm: "Conferma"
  yes: "Sì"
  no: "No"
  back: "Indietro"
  next: "Avanti"
  close: "Chiudi"
  save: "Salva"
  delete: "Elimina"
  search: "Cerca"
  login: "Accedi"
  logout: "Esci"
  sign_up: "Registrati"
  profile: "Profilo"
  settings: "Impostazioni"
  send: "Invia"
  submit: "Invia"
  loading: "Caricamento..."
  no_results: "Nessun risultato trovato."
  welcome: "Benvenuto!"
  goodbye: "Arrivederci!"
  thank_you: "Grazie."
  try_again: "Per favore, riprova."
  contact_support: "Contatta il supporto."
__EOC__

cat << '__EOC__' > "locales/en.json"
{
  "general": {
    "hello": "Hello in English"
  }
}
__EOC__

cat << '__EOC__' > "locales/pl.yaml"
errors:
  unexpected_error: "Wystąpił nieoczekiwany błąd. Spróbuj ponownie później."
  invalid_credentials: "Nieprawidłowa nazwa użytkownika lub hasło."
  unauthorized: "Nie masz uprawnień do wykonania tej akcji."
  forbidden: "Dostęp zabroniony."
  not_found: "Nie znaleziono zasobu."
  user_not_found: "Nie znaleziono użytkownika."
  email_exists: "Ten adres e-mail jest już używany."
  username_exists: "Ta nazwa użytkownika jest już zajęta."
  account_disabled: "To konto zostało dezaktywowane."
  session_expired: "Sesja wygasła. Zaloguj się ponownie."
  rate_limit: "Zbyt wiele żądań. Spróbuj ponownie później."
  server_error: "Wewnętrzny błąd serwera."
validation:
  required_field: "To pole jest wymagane."
  invalid_email: "Wprowadź prawidłowy adres e-mail."
  min_length: "Musi mieć co najmniej {min} znaków."
  max_length: "Może mieć maksymalnie {max} znaków."
  password_mismatch: "Hasła nie są zgodne."
  invalid_format: "Nieprawidłowy format."
  only_numbers: "Dozwolone są tylko wartości numeryczne."
  min_value: "Wartość musi wynosić co najmniej {min}."
  max_value: "Wartość może wynosić co najwyżej {max}."
  too_short: "Za krótki."
  too_long: "Za długi."
notifications:
  new_message: "Nowa wiadomość od {name}."
  friend_request: "Masz nowe zaproszenie do znajomych."
  meeting_reminder: "Przypomnienie: spotkanie \"{title}\" o {time}."
  task_due_soon: "Termin zadania \"{task}\" wkrótce upływa."
  new_notification: "Masz nowe powiadomienie."
  promo_offer: "Nowa oferta promocyjna dostępna."
  account_approved: "Twoje konto zostało zatwierdzone."
  account_rejected: "Twoje konto zostało odrzucone."
  update_available: "Dostępna jest nowa aktualizacja."
  event_starting: "Wydarzenie \"{event}\" właśnie się zaczyna."
emails:
  welcome_subject: "Witamy w Dialoom!"
  welcome_body: "Cześć {name},\n\nDziękujemy za dołączenie do Dialoom. Cieszymy się, że jesteś z nami. Jeśli masz jakiekolwiek pytania, skontaktuj się z naszym zespołem wsparcia.\n\nPozdrawiamy,\nZespół Dialoom"
  reset_password_subject: "Zresetuj swoje hasło w Dialoom"
  reset_password_body: "Cześć {name},\n\nOtrzymaliśmy prośbę o zresetowanie Twojego hasła. Kliknij poniższy link, aby ustawić nowe hasło. Jeśli nie wysłałeś tej prośby, zignoruj tę wiadomość.\n\nDziękujemy,\nZespół wsparcia Dialoom"
  verify_email_subject: "Potwierdź swój adres e-mail"
  verify_email_body: "Cześć {name},\n\nPotwierdź swój adres e-mail, klikając poniższy link. Jeśli nie tworzyłeś konta Dialoom, zignoruj tę wiadomość.\n\nDziękujemy,\nZespół Dialoom"
  password_changed_subject: "Twoje hasło zostało zmienione"
  password_changed_body: "Cześć {name},\n\nPotwierdzamy, że Twoje hasło zostało pomyślnie zmienione. Jeśli to nie Ty dokonałeś tej zmiany, natychmiast skontaktuj się z pomocą techniczną.\n\nPozdrawiamy,\nZespół Dialoom"
api:
  created_success: "Utworzono pomyślnie."
  updated_success: "Zaktualizowano pomyślnie."
  deleted_success: "Usunięto pomyślnie."
  operation_success: "Operacja zakończona pomyślnie."
  operation_failed: "Operacja nie powiodła się."
  invalid_token: "Nieprawidłowy token."
  authentication_required: "Wymagane uwierzytelnienie."
  permission_denied: "Brak uprawnień."
  resource_not_found: "Nie znaleziono zasobu."
  bad_request: "Nieprawidłowe żądanie."
  conflict_error: "Błąd konfliktu."
  server_error: "Błąd serwera."
  service_unavailable: "Usługa niedostępna. Spróbuj ponownie później."
  too_many_requests: "Zbyt wiele żądań."
  missing_fields: "Brak wymaganych pól."
  invalid_parameters: "Nieprawidłowe parametry."
  method_not_allowed: "Metoda niedozwolona."
  request_timeout: "Przekroczono limit czasu żądania."
general:
  ok: "OK"
  cancel: "Anuluj"
  confirm: "Potwierdź"
  yes: "Tak"
  no: "Nie"
  back: "Wstecz"
  next: "Dalej"
  close: "Zamknij"
  save: "Zapisz"
  delete: "Usuń"
  search: "Szukaj"
  login: "Zaloguj się"
  logout: "Wyloguj się"
  sign_up: "Zarejestruj się"
  profile: "Profil"
  settings: "Ustawienia"
  send: "Wyślij"
  submit: "Prześlij"
  loading: "Ładowanie..."
  no_results: "Nie znaleziono wyników."
  welcome: "Witamy!"
  goodbye: "Do widzenia!"
  thank_you: "Dziękujemy."
  try_again: "Spróbuj ponownie."
  contact_support: "Skontaktuj się z pomocą techniczną."
__EOC__

cat << '__EOC__' > "locales/de.yaml"
errors:
  unexpected_error: "Es ist ein unerwarteter Fehler aufgetreten. Bitte versuchen Sie es später noch einmal."
  invalid_credentials: "Benutzername oder Passwort ungültig."
  unauthorized: "Sie sind nicht berechtigt, diese Aktion durchzuführen."
  forbidden: "Zugriff verweigert."
  not_found: "Ressource nicht gefunden."
  user_not_found: "Benutzer nicht gefunden."
  email_exists: "Diese E-Mail-Adresse ist bereits registriert."
  username_exists: "Dieser Benutzername ist bereits vergeben."
  account_disabled: "Dieses Konto wurde deaktiviert."
  session_expired: "Die Sitzung ist abgelaufen. Bitte melden Sie sich erneut an."
  rate_limit: "Zu viele Anfragen. Bitte versuchen Sie es später erneut."
  server_error: "Interner Serverfehler."
validation:
  required_field: "Dieses Feld ist erforderlich."
  invalid_email: "Bitte geben Sie eine gültige E-Mail-Adresse ein."
  min_length: "Muss mindestens {min} Zeichen lang sein."
  max_length: "Darf höchstens {max} Zeichen lang sein."
  password_mismatch: "Passwörter stimmen nicht überein."
  invalid_format: "Ungültiges Format."
  only_numbers: "Es sind nur numerische Werte erlaubt."
  min_value: "Der Wert muss mindestens {min} betragen."
  max_value: "Der Wert darf höchstens {max} betragen."
  too_short: "Zu kurz."
  too_long: "Zu lang."
notifications:
  new_message: "Neue Nachricht von {name}."
  friend_request: "Sie haben eine neue Freundschaftsanfrage."
  meeting_reminder: "Erinnerung: Besprechung \"{title}\" um {time}."
  task_due_soon: "Aufgabe \"{task}\" ist bald fällig."
  new_notification: "Sie haben eine neue Benachrichtigung."
  promo_offer: "Neues Sonderangebot verfügbar."
  account_approved: "Ihr Konto wurde genehmigt."
  account_rejected: "Ihr Konto wurde abgelehnt."
  update_available: "Ein neues Update ist verfügbar."
  event_starting: "Das Ereignis \"{event}\" beginnt jetzt."
emails:
  welcome_subject: "Willkommen bei Dialoom!"
  welcome_body: "Hallo {name},\n\nvielen Dank, dass Sie sich bei Dialoom angemeldet haben. Wir freuen uns, Sie an Bord zu haben. Wenn Sie Fragen haben, können Sie sich gerne an unser Support-Team wenden.\n\nMit freundlichen Grüßen,\nIhr Dialoom-Team"
  reset_password_subject: "Setzen Sie Ihr Dialoom-Passwort zurück"
  reset_password_body: "Hallo {name},\n\nwir haben eine Anfrage zum Zurücksetzen Ihres Passworts erhalten. Klicken Sie auf den untenstehenden Link, um ein neues Passwort festzulegen. Falls Sie diese Anfrage nicht gestellt haben, ignorieren Sie bitte diese E-Mail.\n\nVielen Dank,\nIhr Dialoom-Support-Team"
  verify_email_subject: "Bestätigen Sie Ihre E-Mail-Adresse"
  verify_email_body: "Hallo {name},\n\nbitte bestätigen Sie Ihre E-Mail-Adresse, indem Sie auf den folgenden Link klicken. Wenn Sie kein Dialoom-Konto erstellt haben, können Sie diese E-Mail ignorieren.\n\nVielen Dank,\nIhr Dialoom-Team"
  password_changed_subject: "Ihr Passwort wurde geändert"
  password_changed_body: "Hallo {name},\n\nhiermit bestätigen wir, dass Ihr Passwort erfolgreich geändert wurde. Sollten Sie diese Änderung nicht vorgenommen haben, kontaktieren Sie bitte umgehend unseren Support.\n\nMit freundlichen Grüßen,\nIhr Dialoom-Team"
api:
  created_success: "Erfolgreich erstellt."
  updated_success: "Erfolgreich aktualisiert."
  deleted_success: "Erfolgreich gelöscht."
  operation_success: "Vorgang erfolgreich abgeschlossen."
  operation_failed: "Vorgang fehlgeschlagen."
  invalid_token: "Ungültiges Token."
  authentication_required: "Authentifizierung erforderlich."
  permission_denied: "Zugriff verweigert."
  resource_not_found: "Ressource nicht gefunden."
  bad_request: "Ungültige Anfrage."
  conflict_error: "Konfliktfehler."
  server_error: "Serverfehler."
  service_unavailable: "Dienst nicht verfügbar. Bitte versuchen Sie es später erneut."
  too_many_requests: "Zu viele Anfragen."
  missing_fields: "Erforderliche Felder fehlen."
  invalid_parameters: "Ungültige Parameter."
  method_not_allowed: "Methode nicht erlaubt."
  request_timeout: "Zeitüberschreitung der Anfrage."
general:
  ok: "OK"
  cancel: "Abbrechen"
  confirm: "Bestätigen"
  yes: "Ja"
  no: "Nein"
  back: "Zurück"
  next: "Weiter"
  close: "Schließen"
  save: "Speichern"
  delete: "Löschen"
  search: "Suchen"
  login: "Anmelden"
  logout: "Abmelden"
  sign_up: "Registrieren"
  profile: "Profil"
  settings: "Einstellungen"
  send: "Senden"
  submit: "Absenden"
  loading: "Wird geladen..."
  no_results: "Keine Ergebnisse gefunden."
  welcome: "Willkommen!"
  goodbye: "Auf Wiedersehen!"
  thank_you: "Danke."
  try_again: "Bitte versuchen Sie es erneut."
  contact_support: "Wenden Sie sich an den Support."
__EOC__

cat << '__EOC__' > "locales/ca.yaml"
errors:
  unexpected_error: "S'ha produït un error inesperat. Si us plau, torna-ho a intentar més tard."
  invalid_credentials: "Nom d'usuari o contrasenya incorrectes."
  unauthorized: "No estàs autoritzat a realitzar aquesta acció."
  forbidden: "Accés prohibit."
  not_found: "Recurs no trobat."
  user_not_found: "Usuari no trobat."
  email_exists: "Aquesta adreça de correu electrònic ja està en ús."
  username_exists: "Aquest nom d'usuari ja està en ús."
  account_disabled: "Aquest compte ha estat deshabilitat."
  session_expired: "La sessió ha expirat. Si us plau, inicia sessió de nou."
  rate_limit: "Massa sol·licituds. Si us plau, torna-ho a intentar més tard."
  server_error: "Error intern del servidor."
validation:
  required_field: "Aquest camp és obligatori."
  invalid_email: "Si us plau, introdueix una adreça de correu electrònic vàlida."
  min_length: "Ha de tenir almenys {min} caràcters."
  max_length: "Ha de tenir com a màxim {max} caràcters."
  password_mismatch: "Les contrasenyes no coincideixen."
  invalid_format: "Format no vàlid."
  only_numbers: "Només es permeten valors numèrics."
  min_value: "El valor ha de ser com a mínim {min}."
  max_value: "El valor ha de ser com a màxim {max}."
  too_short: "Massa curt."
  too_long: "Massa llarg."
notifications:
  new_message: "Nou missatge de {name}."
  friend_request: "Tens una nova sol·licitud d'amistat."
  meeting_reminder: "Recordatori: Reunió \"{title}\" a les {time}."
  task_due_soon: "La tasca \"{task}\" venç aviat."
  new_notification: "Tens una nova notificació."
  promo_offer: "Nova oferta promocional disponible."
  account_approved: "El teu compte ha estat aprovat."
  account_rejected: "El teu compte ha estat rebutjat."
  update_available: "Hi ha una nova actualització disponible."
  event_starting: "L'esdeveniment \"{event}\" està començant ara."
emails:
  welcome_subject: "Benvingut a Dialoom!"
  welcome_body: "Hola {name},\n\nGràcies per unir-te a Dialoom. Estem molt contents de tenir-te amb nosaltres. Si tens cap pregunta, no dubtis a contactar amb el nostre equip de suport.\n\nSalutacions,\nL'equip de Dialoom"
  reset_password_subject: "Restableix la teva contrasenya de Dialoom"
  reset_password_body: "Hola {name},\n\nHem rebut una sol·licitud per restablir la teva contrasenya. Fes clic a l'enllaç següent per crear una contrasenya nova. Si no has sol·licitat això, ignora aquest correu electrònic.\n\nGràcies,\nL'equip de suport de Dialoom"
  verify_email_subject: "Verifica la teva adreça de correu electrònic"
  verify_email_body: "Hola {name},\n\nSi us plau, verifica la teva adreça de correu electrònic fent clic a l'enllaç següent. Si no has creat un compte de Dialoom, pots ignorar aquest correu.\n\nGràcies,\nL'equip de Dialoom"
  password_changed_subject: "La teva contrasenya ha estat canviada"
  password_changed_body: "Hola {name},\n\nAquesta és una confirmació que la teva contrasenya s'ha canviat correctament. Si no has fet aquest canvi, contacta immediatament amb el suport.\n\nSalutacions,\nL'equip de Dialoom"
api:
  created_success: "Creat amb èxit."
  updated_success: "Actualitzat amb èxit."
  deleted_success: "Eliminat amb èxit."
  operation_success: "Operació completada amb èxit."
  operation_failed: "Operació fallida."
  invalid_token: "Token no vàlid."
  authentication_required: "Cal autenticació."
  permission_denied: "Permís denegat."
  resource_not_found: "Recurs no trobat."
  bad_request: "Sol·licitud incorrecta."
  conflict_error: "Error de conflicte."
  server_error: "Error de servidor."
  service_unavailable: "Servei no disponible. Si us plau, torna-ho a intentar més tard."
  too_many_requests: "Massa sol·licituds."
  missing_fields: "Falten camps obligatoris."
  invalid_parameters: "Paràmetres no vàlids."
  method_not_allowed: "Mètode no permès."
  request_timeout: "Temps d'espera esgotat."
general:
  ok: "D'acord"
  cancel: "Cancel·lar"
  confirm: "Confirmar"
  yes: "Sí"
  no: "No"
  back: "Atràs"
  next: "Següent"
  close: "Tancar"
  save: "Desar"
  delete: "Eliminar"
  search: "Cercar"
  login: "Inicia sessió"
  logout: "Tanca sessió"
  sign_up: "Registra't"
  profile: "Perfil"
  settings: "Configuració"
  send: "Enviar"
  submit: "Enviar"
  loading: "Carregant..."
  no_results: "No s'han trobat resultats."
  welcome: "Benvingut!"
  goodbye: "Adéu!"
  thank_you: "Gràcies."
  try_again: "Si us plau, torna-ho a intentar."
  contact_support: "Contacta amb el suport."
__EOC__

cat << '__EOC__' > "locales/fr.yaml"
errors:
  unexpected_error: "Une erreur inattendue s'est produite. Veuillez réessayer plus tard."
  invalid_credentials: "Nom d'utilisateur ou mot de passe incorrect."
  unauthorized: "Vous n'êtes pas autorisé à effectuer cette action."
  forbidden: "Accès refusé."
  not_found: "Ressource introuvable."
  user_not_found: "Utilisateur introuvable."
  email_exists: "Cette adresse e-mail est déjà utilisée."
  username_exists: "Ce nom d'utilisateur est déjà pris."
  account_disabled: "Ce compte a été désactivé."
  session_expired: "La session a expiré. Veuillez vous reconnecter."
  rate_limit: "Trop de demandes. Veuillez réessayer plus tard."
  server_error: "Erreur interne du serveur."
validation:
  required_field: "Ce champ est obligatoire."
  invalid_email: "Veuillez saisir une adresse e-mail valide."
  min_length: "Doit contenir au moins {min} caractères."
  max_length: "Doit contenir au maximum {max} caractères."
  password_mismatch: "Les mots de passe ne correspondent pas."
  invalid_format: "Format invalide."
  only_numbers: "Seules les valeurs numériques sont autorisées."
  min_value: "La valeur doit être au moins {min}."
  max_value: "La valeur doit être au maximum {max}."
  too_short: "Trop court."
  too_long: "Trop long."
notifications:
  new_message: "Nouveau message de {name}."
  friend_request: "Vous avez une nouvelle demande d'amitié."
  meeting_reminder: "Rappel : réunion \"{title}\" à {time}."
  task_due_soon: "La tâche \"{task}\" arrive bientôt à échéance."
  new_notification: "Vous avez une nouvelle notification."
  promo_offer: "Nouvelle offre promotionnelle disponible."
  account_approved: "Votre compte a été approuvé."
  account_rejected: "Votre compte a été refusé."
  update_available: "Une nouvelle mise à jour est disponible."
  event_starting: "L'événement \"{event}\" commence maintenant."
emails:
  welcome_subject: "Bienvenue sur Dialoom!"
  welcome_body: "Bonjour {name},\n\nMerci de vous être inscrit sur Dialoom. Nous sommes ravis de vous compter parmi nos utilisateurs. Si vous avez des questions, n'hésitez pas à contacter notre équipe d'assistance.\n\nCordialement,\nL'équipe Dialoom"
  reset_password_subject: "Réinitialisez votre mot de passe Dialoom"
  reset_password_body: "Bonjour {name},\n\nNous avons reçu une demande de réinitialisation de votre mot de passe. Cliquez sur le lien ci-dessous pour définir un nouveau mot de passe. Si vous n'êtes pas à l'origine de cette demande, veuillez ignorer cet e-mail.\n\nMerci,\nL'équipe d'assistance Dialoom"
  verify_email_subject: "Vérifiez votre adresse e-mail"
  verify_email_body: "Bonjour {name},\n\nVeuillez vérifier votre adresse e-mail en cliquant sur le lien ci-dessous. Si vous n'avez pas créé de compte Dialoom, vous pouvez ignorer cet e-mail.\n\nMerci,\nL'équipe Dialoom"
  password_changed_subject: "Votre mot de passe a été changé"
  password_changed_body: "Bonjour {name},\n\nNous vous confirmons que votre mot de passe a bien été modifié. Si vous n'êtes pas à l'origine de ce changement, veuillez contacter notre équipe d'assistance immédiatement.\n\nCordialement,\nL'équipe Dialoom"
api:
  created_success: "Créé avec succès."
  updated_success: "Mis à jour avec succès."
  deleted_success: "Supprimé avec succès."
  operation_success: "Opération réussie."
  operation_failed: "Opération échouée."
  invalid_token: "Jeton invalide."
  authentication_required: "Authentification requise."
  permission_denied: "Permission refusée."
  resource_not_found: "Ressource introuvable."
  bad_request: "Requête incorrecte."
  conflict_error: "Conflit détecté."
  server_error: "Erreur serveur."
  service_unavailable: "Service indisponible. Veuillez réessayer plus tard."
  too_many_requests: "Trop de demandes."
  missing_fields: "Champs obligatoires manquants."
  invalid_parameters: "Paramètres invalides."
  method_not_allowed: "Méthode non autorisée."
  request_timeout: "Délai d'attente dépassé."
general:
  ok: "OK"
  cancel: "Annuler"
  confirm: "Confirmer"
  yes: "Oui"
  no: "Non"
  back: "Retour"
  next: "Suivant"
  close: "Fermer"
  save: "Enregistrer"
  delete: "Supprimer"
  search: "Rechercher"
  login: "Connexion"
  logout: "Déconnexion"
  sign_up: "Inscription"
  profile: "Profil"
  settings: "Paramètres"
  send: "Envoyer"
  submit: "Valider"
  loading: "Chargement..."
  no_results: "Aucun résultat trouvé."
  welcome: "Bienvenue!"
  goodbye: "Au revoir!"
  thank_you: "Merci."
  try_again: "Veuillez réessayer."
  contact_support: "Contactez le support."
__EOC__

cat << '__EOC__' > "locales/es.yaml"
errors:
  unexpected_error: "Ha ocurrido un error inesperado. Por favor, inténtalo de nuevo más tarde."
  invalid_credentials: "Usuario o contraseña incorrectos."
  unauthorized: "No estás autorizado para realizar esta acción."
  forbidden: "Acceso prohibido."
  not_found: "Recurso no encontrado."
  user_not_found: "Usuario no encontrado."
  email_exists: "Esta dirección de correo electrónico ya está en uso."
  username_exists: "Este nombre de usuario ya está en uso."
  account_disabled: "Esta cuenta ha sido deshabilitada."
  session_expired: "La sesión ha expirado. Por favor, inicia sesión de nuevo."
  rate_limit: "Demasiadas solicitudes. Por favor, inténtalo de nuevo más tarde."
  server_error: "Error interno del servidor."
validation:
  required_field: "Este campo es obligatorio."
  invalid_email: "Por favor, introduzca una dirección de correo electrónico válida."
  min_length: "Debe tener al menos {min} caracteres."
  max_length: "Debe tener como máximo {max} caracteres."
  password_mismatch: "Las contraseñas no coinciden."
  invalid_format: "Formato no válido."
  only_numbers: "Solo se permiten valores numéricos."
  min_value: "El valor debe ser como mínimo {min}."
  max_value: "El valor debe ser como máximo {max}."
  too_short: "Demasiado corto."
  too_long: "Demasiado largo."
notifications:
  new_message: "Nuevo mensaje de {name}."
  friend_request: "Tienes una nueva solicitud de amistad."
  meeting_reminder: "Recordatorio: Reunión \"{title}\" a las {time}."
  task_due_soon: "La tarea \"{task}\" vence pronto."
  new_notification: "Tienes una nueva notificación."
  promo_offer: "Nueva oferta promocional disponible."
  account_approved: "Tu cuenta ha sido aprobada."
  account_rejected: "Tu cuenta ha sido rechazada."
  update_available: "Hay una nueva actualización disponible."
  event_starting: "El evento \"{event}\" está comenzando ahora."
emails:
  welcome_subject: "¡Bienvenido a Dialoom!"
  welcome_body: "Hola {name},\n\nGracias por unirte a Dialoom. Estamos encantados de tenerte con nosotros. Si tienes alguna pregunta, no dudes en contactar a nuestro equipo de soporte.\n\nSaludos,\nEl equipo de Dialoom"
  reset_password_subject: "Restablece tu contraseña de Dialoom"
  reset_password_body: "Hola {name},\n\nHemos recibido una solicitud para restablecer tu contraseña. Haz clic en el siguiente enlace para crear una nueva contraseña. Si no solicitaste esto, por favor ignora este correo.\n\nGracias,\nEl equipo de soporte de Dialoom"
  verify_email_subject: "Verifica tu dirección de correo electrónico"
  verify_email_body: "Hola {name},\n\nPor favor, verifica tu dirección de correo electrónico haciendo clic en el siguiente enlace. Si tú no creaste una cuenta de Dialoom, puedes ignorar este correo.\n\nGracias,\nEl equipo de Dialoom"
  password_changed_subject: "Tu contraseña ha sido cambiada"
  password_changed_body: "Hola {name},\n\nEsta es una confirmación de que tu contraseña se ha cambiado exitosamente. Si tú no realizaste este cambio, por favor contacta con nuestro equipo de soporte de inmediato.\n\nSaludos,\nEl equipo de Dialoom"
api:
  created_success: "Creado con éxito."
  updated_success: "Actualizado con éxito."
  deleted_success: "Eliminado con éxito."
  operation_success: "Operación completada con éxito."
  operation_failed: "Operación fallida."
  invalid_token: "Token no válido."
  authentication_required: "Se requiere autenticación."
  permission_denied: "Permiso denegado."
  resource_not_found: "Recurso no encontrado."
  bad_request: "Solicitud incorrecta."
  conflict_error: "Error de conflicto."
  server_error: "Error del servidor."
  service_unavailable: "Servicio no disponible. Por favor, inténtalo de nuevo más tarde."
  too_many_requests: "Demasiadas solicitudes."
  missing_fields: "Faltan campos obligatorios."
  invalid_parameters: "Parámetros no válidos."
  method_not_allowed: "Método no permitido."
  request_timeout: "Tiempo de espera agotado."
general:
  ok: "Aceptar"
  cancel: "Cancelar"
  confirm: "Confirmar"
  yes: "Sí"
  no: "No"
  back: "Atrás"
  next: "Siguiente"
  close: "Cerrar"
  save: "Guardar"
  delete: "Eliminar"
  search: "Buscar"
  login: "Iniciar sesión"
  logout: "Cerrar sesión"
  sign_up: "Registrarse"
  profile: "Perfil"
  settings: "Configuración"
  send: "Enviar"
  submit: "Enviar"
  loading: "Cargando..."
  no_results: "No se encontraron resultados."
  welcome: "¡Bienvenido!"
  goodbye: "¡Adiós!"
  thank_you: "Gracias."
  try_again: "Por favor, inténtalo de nuevo."
  contact_support: "Contacta con soporte."
__EOC__

cat << '__EOC__' > "locales/es.json"
{
  "general": {
    "hello": "Hola en Español"
  }
}
__EOC__

cat << '__EOC__' > "locales/da.yaml"
errors:
  unexpected_error: "Der opstod en uventet fejl. Prøv venligst igen senere."
  invalid_credentials: "Ugyldigt brugernavn eller adgangskode."
  unauthorized: "Du har ikke tilladelse til at udføre denne handling."
  forbidden: "Adgang nægtet."
  not_found: "Ressource ikke fundet."
  user_not_found: "Bruger ikke fundet."
  email_exists: "Denne e-mailadresse er allerede i brug."
  username_exists: "Dette brugernavn er allerede optaget."
  account_disabled: "Denne konto er blevet deaktiveret."
  session_expired: "Sessionen er udløbet. Log venligst ind igen."
  rate_limit: "For mange forespørgsler. Prøv igen senere."
  server_error: "Intern serverfejl."
validation:
  required_field: "Dette felt er påkrævet."
  invalid_email: "Indtast venligst en gyldig e-mailadresse."
  min_length: "Skal være mindst {min} tegn."
  max_length: "Skal være højst {max} tegn."
  password_mismatch: "Adgangskoderne stemmer ikke overens."
  invalid_format: "Ugyldigt format."
  only_numbers: "Kun numeriske værdier er tilladt."
  min_value: "Værdien skal være mindst {min}."
  max_value: "Værdien skal være højst {max}."
  too_short: "For kort."
  too_long: "For lang."
notifications:
  new_message: "Ny besked fra {name}."
  friend_request: "Du har fået en ny venneanmodning."
  meeting_reminder: "Påmindelse: møde \"{title}\" kl. {time}."
  task_due_soon: "Opgaven \"{task}\" forfalder snart."
  new_notification: "Du har en ny meddelelse."
  promo_offer: "Nyt kampagnetilbud tilgængeligt."
  account_approved: "Din konto er blevet godkendt."
  account_rejected: "Din konto er blevet afvist."
  update_available: "En ny opdatering er tilgængelig."
  event_starting: "Begivenheden \"{event}\" starter nu."
emails:
  welcome_subject: "Velkommen til Dialoom!"
  welcome_body: "Hej {name},\n\nTak fordi du har tilmeldt dig Dialoom. Vi er glade for at have dig med om bord. Hvis du har spørgsmål, kontakt venligst vores supportteam.\n\nMed venlig hilsen,\nDialoom-teamet"
  reset_password_subject: "Nulstil din Dialoom-adgangskode"
  reset_password_body: "Hej {name},\n\nVi har modtaget en anmodning om at nulstille din adgangskode. Klik på linket nedenfor for at oprette en ny adgangskode. Hvis du ikke har anmodet om dette, skal du ignorere denne e-mail.\n\nTak,\nDialoom-supportteamet"
  verify_email_subject: "Bekræft din e-mailadresse"
  verify_email_body: "Hej {name},\n\nBekræft venligst din e-mailadresse ved at klikke på linket nedenfor. Hvis du ikke har oprettet en Dialoom-konto, kan du ignorere denne e-mail.\n\nTak,\nDialoom-teamet"
  password_changed_subject: "Din adgangskode er blevet ændret"
  password_changed_body: "Hej {name},\n\nDette er en bekræftelse på, at din adgangskode er blevet ændret. Hvis du ikke har foretaget denne ændring, kontakt venligst vores support med det samme.\n\nMed venlig hilsen,\nDialoom-teamet"
api:
  created_success: "Oprettet."
  updated_success: "Opdateret."
  deleted_success: "Slettet."
  operation_success: "Handlingen blev gennemført."
  operation_failed: "Handlingen mislykkedes."
  invalid_token: "Ugyldigt token."
  authentication_required: "Godkendelse påkrævet."
  permission_denied: "Tilladelse nægtet."
  resource_not_found: "Ressourcen blev ikke fundet."
  bad_request: "Ugyldigt anmodning."
  conflict_error: "Konfliktfejl."
  server_error: "Serverfejl."
  service_unavailable: "Tjenesten er utilgængelig. Prøv igen senere."
  too_many_requests: "For mange anmodninger."
  missing_fields: "Obligatoriske felter mangler."
  invalid_parameters: "Ugyldige parametre."
  method_not_allowed: "Metoden er ikke tilladt."
  request_timeout: "Forespørgslen overskred tidsgrænsen."
general:
  ok: "OK"
  cancel: "Annuller"
  confirm: "Bekræft"
  yes: "Ja"
  no: "Nej"
  back: "Tilbage"
  next: "Næste"
  close: "Luk"
  save: "Gem"
  delete: "Slet"
  search: "Søg"
  login: "Log ind"
  logout: "Log ud"
  sign_up: "Registrer dig"
  profile: "Profil"
  settings: "Indstillinger"
  send: "Send"
  submit: "Indsend"
  loading: "Indlæser..."
  no_results: "Ingen resultater fundet."
  welcome: "Velkommen!"
  goodbye: "Farvel!"
  thank_you: "Tak."
  try_again: "Prøv igen."
  contact_support: "Kontakt support."
__EOC__

cat << '__EOC__' > "locales/no.yaml"
errors:
  unexpected_error: "Det oppstod en uventet feil. Vennligst prøv igjen senere."
  invalid_credentials: "Ugyldig brukernavn eller passord."
  unauthorized: "Du har ikke tillatelse til å utføre denne handlingen."
  forbidden: "Adgang nektet."
  not_found: "Ressurs ikke funnet."
  user_not_found: "Bruker ikke funnet."
  email_exists: "E-postadressen er allerede i bruk."
  username_exists: "Brukernavnet er allerede tatt."
  account_disabled: "Denne kontoen har blitt deaktivert."
  session_expired: "Økten er utløpt. Vennligst logg inn på nytt."
  rate_limit: "For mange forespørsler. Vennligst prøv igjen senere."
  server_error: "Intern serverfeil."
validation:
  required_field: "Dette feltet er obligatorisk."
  invalid_email: "Vennligst oppgi en gyldig e-postadresse."
  min_length: "Må være minst {min} tegn."
  max_length: "Må være maksimalt {max} tegn."
  password_mismatch: "Passordene samsvarer ikke."
  invalid_format: "Ugyldig format."
  only_numbers: "Kun numeriske verdier er tillatt."
  min_value: "Verdien må være minst {min}."
  max_value: "Verdien kan være høyst {max}."
  too_short: "For kort."
  too_long: "For lang."
notifications:
  new_message: "Ny melding fra {name}."
  friend_request: "Du har fått en ny venneforespørsel."
  meeting_reminder: "Påminnelse: møte \"{title}\" kl. {time}."
  task_due_soon: "Oppgaven \"{task}\" forfaller snart."
  new_notification: "Du har et nytt varsel."
  promo_offer: "Nytt kampanjetilbud er tilgjengelig."
  account_approved: "Kontoen din har blitt godkjent."
  account_rejected: "Kontoen din har blitt avvist."
  update_available: "En ny oppdatering er tilgjengelig."
  event_starting: "Arrangementet \"{event}\" starter nå."
emails:
  welcome_subject: "Velkommen til Dialoom!"
  welcome_body: "Hei {name},\n\nTakk for at du har registrert deg hos Dialoom. Vi er glade for å ha deg med oss. Hvis du har noen spørsmål, vennligst kontakt vårt supportteam.\n\nVennlig hilsen,\nDialoom-teamet"
  reset_password_subject: "Tilbakestill ditt Dialoom-passord"
  reset_password_body: "Hei {name},\n\nVi har mottatt en forespørsel om å tilbakestille ditt passord. Klikk på lenken nedenfor for å opprette et nytt passord. Hvis du ikke har bedt om dette, vennligst se bort fra denne e-posten.\n\nTakk,\nDialoom-supportteamet"
  verify_email_subject: "Bekreft din e-postadresse"
  verify_email_body: "Hei {name},\n\nVennligst bekreft din e-postadresse ved å klikke på lenken nedenfor. Hvis du ikke har opprettet en Dialoom-konto, kan du se bort fra denne e-posten.\n\nTakk,\nDialoom-teamet"
  password_changed_subject: "Ditt passord har blitt endret"
  password_changed_body: "Hei {name},\n\nDette er en bekreftelse på at ditt passord ble endret. Hvis du ikke utførte denne endringen, vennligst kontakt vår support umiddelbart.\n\nVennlig hilsen,\nDialoom-teamet"
api:
  created_success: "Opprettet."
  updated_success: "Oppdatert."
  deleted_success: "Slettet."
  operation_success: "Operasjonen ble fullført."
  operation_failed: "Operasjonen mislyktes."
  invalid_token: "Ugyldig token."
  authentication_required: "Autentisering kreves."
  permission_denied: "Ingen tilgang."
  resource_not_found: "Ressurs ikke funnet."
  bad_request: "Ugyldig forespørsel."
  conflict_error: "Konflikt oppstod."
  server_error: "Serverfeil."
  service_unavailable: "Tjenesten er utilgjengelig. Vennligst prøv igjen senere."
  too_many_requests: "For mange forespørsler."
  missing_fields: "Manglende obligatoriske felter."
  invalid_parameters: "Ugyldige parametere."
  method_not_allowed: "Metoden er ikke tillatt."
  request_timeout: "Tidsavbrudd for forespørsel."
general:
  ok: "OK"
  cancel: "Avbryt"
  confirm: "Bekreft"
  yes: "Ja"
  no: "Nei"
  back: "Tilbake"
  next: "Neste"
  close: "Lukk"
  save: "Lagre"
  delete: "Slett"
  search: "Søk"
  login: "Logg inn"
  logout: "Logg ut"
  sign_up: "Registrer deg"
  profile: "Profil"
  settings: "Innstillinger"
  send: "Send"
  submit: "Send inn"
  loading: "Laster..."
  no_results: "Ingen resultater funnet."
  welcome: "Velkommen!"
  goodbye: "Ha det bra!"
  thank_you: "Takk."
  try_again: "Vennligst prøv igjen."
  contact_support: "Kontakt support."
__EOC__

cat << '__EOC__' > "test/app.e2e-spec.ts"
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('AppController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/health (GET)', () => {
    return request(app.getHttpServer())
      .get('/health')
      .expect(200)
      .expect('OK');
  });

  afterAll(async () => {
    await app.close();
  });
});
__EOC__

cat << '__EOC__' > "Dockerfile"
# Dockerfile: Construye la imagen para el backend de Dialoom (versión final optimizada)

# Etapa 1: build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# Etapa 2: runtime
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "dist/main.js"]
__EOC__

cat << '__EOC__' > "dialoom_fix.sh"
#!/usr/bin/env bash
set -e  # Si algo falla, que el script se detenga

############################################
# 1. Instalar dependencias que faltan      #
############################################

echo "==> Instalando @nestjs/config, helmet y @types/helmet..."

# Añadimos las dependencias al package.json
#npm install --save @nestjs/config@^2.2.0 helmet@^6.0.0
#npm install --save-dev @types/helmet@^6.1.3

# Añadimos tipado para 'passport-apple' si deseas forzar su reconocimiento
# (no existe paquete oficial, así que sólo “declare module”)
# Ojo: si no deseas forzar, puedes omitirlo
echo "==> Creando src/types/passport-apple.d.ts si no existe..."
mkdir -p src/types
if [ ! -f "src/types/passport-apple.d.ts" ]; then
cat <<EOF > src/types/passport-apple.d.ts
declare module 'passport-apple';
EOF
fi

############################################
# 2. Crear/corregir archivo JwtAuthGuard   #
############################################

echo "==> Creando src/auth/guards/jwt-auth.guard.ts si no existe..."
mkdir -p src/auth/guards
if [ ! -f "src/auth/guards/jwt-auth.guard.ts" ]; then
cat <<EOF > src/auth/guards/jwt-auth.guard.ts
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
EOF
fi

############################################
# 3. Añadir ConfigModule.forRoot() en app.module.ts (opcional)
############################################

# Este sed es “ingenuo”. Sólo si no tienes ya ConfigModule importado.
# Ajusta a tu gusto si ya lo tienes.
# Sustituirá la línea 'imports: [' por un bloque con ConfigModule.
# Ojo: Si ya tienes algo, revisa manualmente.
if grep -q "ConfigModule.forRoot" src/app.module.ts; then
  echo "==> app.module.ts ya parece tener ConfigModule.forRoot. No modifico."
else
  echo "==> Insertando ConfigModule.forRoot() en app.module.ts (ingenuo sed)..."
  sed -i.bak '/imports: \[/a \
\ \ \ \ ConfigModule.forRoot({\\n      isGlobal: true,\\n    }),\
' src/app.module.ts || true
fi

############################################
# 4. Reemplazar imports de dayjs ("import * as dayjs")
#    por "import dayjs from 'dayjs';" en *.service.ts
############################################

echo "==> Corrigiendo import de dayjs (de '* as dayjs' a default) en 'src/modules/*service.ts'..."
find src/modules -type f -name "*service.ts" -exec sed -i.bak \
  "s/import \* as dayjs from 'dayjs'/import dayjs from 'dayjs'/g" {} \; || true

############################################
# 5. Añadir '!' en propiedades de las Entities (TS2564).
#    Este es el cambio más delicado:
#    Reemplazamos "id: number;" por "id!: number;", etc.
#    Igualmente con string, boolean, etc.
############################################

echo "==> Aplicando naive sed para poner '!' en entidades..."

# Lista de patrones típicos. Puedes extender con number, boolean, string, Date...
# Ten en cuenta que esto es un “approach” muy ingenuo. No cubre todo.
# Aplica a .entity.ts. Ajusta según tus nombres de ficheros.
declare -a TSTYPES=("number" "string" "boolean" "Date" "UserRole" "TransactionStatus" "TicketStatus" "Achievement" "User" "Setting" "Host" "any")

for T in "${TSTYPES[@]}"; do
  echo "    -> Insertando '!' en propiedades con tipo '$T'"
  find src/modules -type f -name "*.entity.ts" -exec sed -i.bak \
    "s/\([A-Za-z0-9_]\+\): $T;/\1!: $T;/g" {} \; || true
done

# Podríamos hacer un second pass si tuvieras '?:' o '| null', etc.
# O substitución genérica: '^[^!]+: [^;]+;$' ...
# Pero es arriesgado en sed.
# Revisa luego manualmente.

############################################
# 6. Revisar backticks rotos en interceptors / Twilio
############################################

echo "==> Corrigiendo backticks (ingenuo) en logging.interceptor.ts y twilio.service.ts..."

# logging.interceptor.ts:
# Buscamos algo como:  const logMessage = \\`User \${ ... } ...\\`;
# A veces se corrompe al copiar. Dejamos uno correcto:
if [ -f "src/common/interceptors/logging.interceptor.ts" ]; then
cat <<EOF > src/common/interceptors/logging.interceptor.ts
import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const userId = request.user?.id || 'anonymous';
    const method = request.method;
    const originalUrl = request.url;

    const logMessage = \\`User \${userId} -> [\${method}] \${originalUrl}\\`;
    console.log(logMessage);

    return next.handle();
  }
}
EOF
fi

# twilio.service.ts:
# (Si existe, reescribimos parte con un snippet que contenga backticks bien formados.)
if [ -f "src/modules/notifications/channels/twilio.service.ts" ]; then
  echo "==> Reemplazando 'twilio.service.ts' con un snippet que asume la client/messages usage..."
  cat <<EOF > src/modules/notifications/channels/twilio.service.ts
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Twilio from 'twilio';

@Injectable()
export class TwilioService {
  private readonly client: Twilio.Twilio;
  constructor(private readonly configService: ConfigService) {
    const accountSid = this.configService.get<string>('TWILIO_ACCOUNT_SID') || '';
    const authToken = this.configService.get<string>('TWILIO_AUTH_TOKEN') || '';
    this.client = Twilio(accountSid, authToken);
  }

  async sendWhatsappMessage(toNumber: string, message: string, fromWhatsapp: string) {
    return this.client.messages.create({
      body: message,
      from: fromWhatsapp,
      to: \\`whatsapp:\${toNumber}\\`,
    });
  }
}
EOF
fi

############################################
# 7. Ajustes de Services que devuelven "User | null"
############################################

echo "==> Aviso: Revisa manualmente los returns de 'User | null'."
echo "    Si findOne() puede retornar null, o lanza NotFoundException, o devuelves 'User | null'."

############################################
# 8. Final
############################################

echo "==> Script de fix finalizado."
echo "    1) Por favor, revisa los archivos .bak en cada carpeta: sed deja backups."
echo "    2) Compara los cambios (git diff) y confirma que todo se haya modificado correctamente."
echo "    3) Una vez conforme: 'npm run build' y comprueba si ya compila sin errores."
exit 0
__EOC__

cat << '__EOC__' > "README.md"
# Dialoom Backend

Este repositorio contiene el **backend** de la plataforma **Dialoom**, un servicio que conecta a usuarios con mentores mediante sesiones de videollamada.  
El objetivo principal es gestionar la **autenticación**, la **lógica de reservas**, los **pagos** (Stripe), la **gamificación** (insignias y logros), y proveer un **panel de administración** para supervisar y configurar la plataforma.

## Características Destacadas

- **NestJS (Node.js + TypeScript):** Estructura modular y orientada a objetos que facilita la escalabilidad y el mantenimiento.
- **Videollamadas con Agora:** Generación de tokens de acceso seguros para sesiones en tiempo real con alta calidad de audio y video.
- **Sistema de Pagos Integrado (Stripe):** Retención de comisiones (p. ej. 10% + IVA) y pago diferido a los mentores mediante Stripe Connect.
- **Autenticación Robusta:**
  - JWT (JSON Web Tokens) para sesiones stateless.
  - Login Social (Google, Apple, Microsoft, Facebook).
  - 2FA (opcional) para mayor seguridad.
- **Gamificación y Engagement:** Insignias, puntos, niveles y rankings para fomentar la participación activa.
- **Moderación y Reportes:** Los usuarios pueden reportar incidentes; el panel admin gestiona bloqueos, advertencias y acciones de seguridad.
- **Notificaciones Multicanal:** Emails transaccionales (SendGrid), notificaciones push (Firebase Cloud Messaging) y mensajería (WhatsApp/SMS) para recordatorios críticos.
- **Panel de Administración:** Permite ver estadísticas, gestionar usuarios/mentores, reservas y pagos, configurar comisiones y reglas globales.
- **Multidioma y Accesibilidad (WCAG 2.1):** Textos en varios idiomas (JSON/YAML) y diseño enfocado en la inclusión.

## Requisitos Previos

1. **Node.js** (versión 14+ o 16+)
2. **Docker** y **Docker Compose** (para desplegar contenedores)
3. **PostgreSQL** (si no lo ejecutas en contenedor, necesitas la DB instalada)
4. **Redis** (para caché y optimizaciones; también puede ir en contenedor)
5. **Stripe** (cuenta activa para procesar pagos, incl. claves API)
6. **Agora** (cuenta para videollamadas, incl. App ID y App Certificate)

## Configuración de Variables de Entorno

Crea un archivo \`.env\` en la raíz del proyecto con las siguientes variables (ejemplo):

Ejemplo de .env

PORT=3000
DATABASE_URL=postgres://usuario:password@host:5432/dialoomdb
REDIS_HOST=localhost
REDIS_PORT=6379

STRIPE_SECRET_KEY=sk_test_***********
AGORA_APP_ID=***********
AGORA_APP_CERTIFICATE=***********
SENDGRID_API_KEY=***********
JWT_SECRET=***********

*(Ajusta nombres y valores según tu infraestructura.)*

## Instalación y Ejecución (Local sin Docker)

1. **Clona** el repositorio:
   \`\`\`bash
   git clone https://github.com/TopGunDialoom/dialoom-backend.git
   cd dialoom-backend

	2.	Instala dependencias:

npm install


	3.	Configura el archivo .env (ver sección anterior).
	4.	Inicia la aplicación:

npm run start:dev


	5.	Accede a la API en http://localhost:3000 (o el puerto definido en .env).

Despliegue con Docker
	1.	Asegúrate de tener Docker y Docker Compose instalados.
	2.	Clona el repositorio y ubícate en la carpeta raíz.
	3.	Crea tu archivo .env con las credenciales.
	4.	Ejecuta:

docker-compose up -d

Esto levantará el contenedor del backend y (opcionalmente) contenedores para PostgreSQL y Redis, si están configurados en el docker-compose.yml.

	5.	Comprueba que el servicio está corriendo en http://localhost:3000.

Estructura del Proyecto

dialoom-backend/
  ├── src/
  │   ├── app.module.ts         # Módulo raíz
  │   ├── main.ts               # Punto de entrada NestJS
  │   ├── modules/
  │   │   ├── auth/             # Autenticación (JWT, 2FA, login social)
  │   │   ├── users/            # Usuarios (clientes) y Hosts
  │   │   ├── reservations/     # Lógica de reservas
  │   │   ├── payments/         # Integración Stripe
  │   │   ├── gamification/     # Insignias, puntos, etc.
  │   │   ├── moderation/       # Reportes y acciones admin
  │   │   └── notifications/    # Emails, push, SMS
  │   └── ...otros
  ├── test/                     # Pruebas unitarias
  ├── docker-compose.yml
  ├── package.json
  ├── .env.example              # Ejemplo de variables de entorno
  └── README.md

Uso Básico
	•	Autenticación y Sesiones:
Envía el token JWT en la cabecera Authorization: Bearer <token> en cada petición protegida.
	•	Reservas:
	•	POST /reservations para crear una nueva reserva.
	•	GET /reservations/me para ver tus reservas.
	•	Videollamadas:
	•	El backend genera un token de Agora que el cliente usa para unirse al canal.
	•	Pagos (Stripe):
	•	El usuario ingresa su método de pago, el backend crea un PaymentIntent y retiene comisión.
	•	Gamificación:
	•	Cada acción (ej. completar sesión) suma puntos; si llegas a un umbral, se asigna una insignia.

Panel de Administración
	•	Ruta típica: http://<server>:3000/admin (o según configuración).
	•	Sólo superadministradores con credenciales de admin y (opcionalmente) 2FA pueden acceder.
	•	Permite visualizar usuarios/hosts, reservas, reportes, pagos y modificar configuraciones globales (comisión, políticas, etc.).

Contribución
	•	Pull Requests y Issues son bienvenidos para reportar bugs o proponer mejoras.
	•	Siéntete libre de abrir discusiones sobre nuevas funcionalidades, siempre alineadas con la visión de la plataforma.

Licencia

“Free Use”
Este proyecto es de uso público y propietario de la plataforma Dialoom, de Marc Garcia Garcia. Acceso libre para ChatGPT y análisis permitido.
Todos los derechos reservados. No se permite su uso, copia o distribución sin autorización expresa.

Dialoom: Conectamos usuarios con mentores expertos de forma segura, práctica y escalable. ¡Gracias por tu interés en nuestro backend!
__EOC__

cat << '__EOC__' > "Firebase/GoogleService-Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CLIENT_ID</key>
	<string>279884688149-0nl4fgggl4leph87ganmu8vlfd3lujdn.apps.googleusercontent.com</string>
	<key>REVERSED_CLIENT_ID</key>
	<string>com.googleusercontent.apps.279884688149-0nl4fgggl4leph87ganmu8vlfd3lujdn</string>
	<key>ANDROID_CLIENT_ID</key>
	<string>279884688149-eso98mqg35lqkiagrkjgtkl296ip5slj.apps.googleusercontent.com</string>
	<key>API_KEY</key>
	<string>AIzaSyBKychLJqF3_xNZtmL19YLxy4tOT8mOXyI</string>
	<key>GCM_SENDER_ID</key>
	<string>279884688149</string>
	<key>PLIST_VERSION</key>
	<string>1</string>
	<key>BUNDLE_ID</key>
	<string>com.paras.Dialoom</string>
	<key>PROJECT_ID</key>
	<string>dialoom-c912e</string>
	<key>STORAGE_BUCKET</key>
	<string>dialoom-c912e.firebasestorage.app</string>
	<key>IS_ADS_ENABLED</key>
	<false></false>
	<key>IS_ANALYTICS_ENABLED</key>
	<false></false>
	<key>IS_APPINVITE_ENABLED</key>
	<true></true>
	<key>IS_GCM_ENABLED</key>
	<true></true>
	<key>IS_SIGNIN_ENABLED</key>
	<true></true>
	<key>GOOGLE_APP_ID</key>
	<string>1:279884688149:ios:831df6e496eac17794571c</string>
</dict>
</plist>
__EOC__

cat << '__EOC__' > "Firebase/google-services.json"
{
  "project_info": {
    "project_number": "279884688149",
    "project_id": "dialoom-c912e",
    "storage_bucket": "dialoom-c912e.firebasestorage.app"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:279884688149:android:c2c8f06dc91b397a94571c",
        "android_client_info": {
          "package_name": "com.dialoom"
        }
      },
      "oauth_client": [
        {
          "client_id": "279884688149-eso98mqg35lqkiagrkjgtkl296ip5slj.apps.googleusercontent.com",
          "client_type": 1,
          "android_info": {
            "package_name": "com.dialoom",
            "certificate_hash": "87f5e44d15a152e680511668010d61045e4f2a48"
          }
        },
        {
          "client_id": "279884688149-l8rvlcuvdd681c63c3getvfp5spf80s6.apps.googleusercontent.com",
          "client_type": 1,
          "android_info": {
            "package_name": "com.dialoom",
            "certificate_hash": "7f06965fad2dbe60459db44f83dd6ed033a3ab76"
          }
        },
        {
          "client_id": "279884688149-gdi7abbhrjt1i77hpus0at0eq3dgapkr.apps.googleusercontent.com",
          "client_type": 3
        }
      ],
      "api_key": [
        {
          "current_key": "AIzaSyB6GuXpyRqzAUMR0jVYFOAC7VxyXEb9SAI"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": [
            {
              "client_id": "279884688149-3n98e2lkm2q5used0883fefmrsusbtie.apps.googleusercontent.com",
              "client_type": 3
            },
            {
              "client_id": "279884688149-0nl4fgggl4leph87ganmu8vlfd3lujdn.apps.googleusercontent.com",
              "client_type": 2,
              "ios_info": {
                "bundle_id": "com.paras.Dialoom",
                "app_store_id": "1661606157"
              }
            }
          ]
        }
      }
    }
  ],
  "configuration_version": "1"
}
__EOC__

cat << '__EOC__' > "package.json"
{
  "name": "dialoom-backend",
  "version": "1.0.0",
  "description": "Backend NestJS for Dialoom platform",
  "scripts": {
    "start": "nest start",
    "start:dev": "nest start --watch",
    "build": "nest build",
    "start:prod": "node dist/main.js",
    "test": "jest --coverage"
  },
  "dependencies": {
    "@nestjs/common": "^9.0.0",
    "@nestjs/core": "^9.0.0",
    "@nestjs/jwt": "^9.0.0",
    "@nestjs/passport": "^9.0.0",
    "@nestjs/platform-express": "^9.0.0",
    "@nestjs/typeorm": "^9.0.0",
    "@sendgrid/mail": "^7.7.0",
    "agora-access-token": "^2.0.0",
    "bcrypt": "^5.1.0",
    "class-validator": "^0.14.0",
    "class-transformer": "^0.5.1",
    "firebase-admin": "^11.0.0",
    "helmet": "^6.0.0",
    "ioredis": "^5.2.0",
    "passport": "^0.6.0",
    "passport-apple": "^2.0.2",
    "passport-facebook": "^3.0.0",
    "passport-google-oauth20": "^2.0.0",
    "passport-jwt": "^4.0.0",
    "passport-microsoft": "^1.0.0",
    "redis": "^4.0.11",
    "reflect-metadata": "^0.1.13",
    "rxjs": "^7.0.0",
    "stripe": "^11.0.0",
    "twilio": "^3.84.0",
    "typeorm": "^0.3.12",
    "@nestjs/config": "^2.2.0"
  },
  "devDependencies": {
    "@nestjs/cli": "^9.0.0",
    "@nestjs/schematics": "^9.0.0",
    "@types/bcrypt": "^5.0.0",
    "@types/express": "^4.17.13",
    "@types/jest": "^28.1.1",
    "@types/node": "^18.0.0",
    "@types/passport-facebook": "^3.0.0",
    "@types/passport-google-oauth20": "^2.0.16",
    "@types/passport-jwt": "^3.0.6",
    "@types/passport-microsoft": "^1.0.0",
    "@types/redis": "^4.0.11",
    "@types/socket.io": "^3.0.2",
    "@types/stripe": "^8.0.0",
    "@typescript-eslint/eslint-plugin": "^5.0.0",
    "@typescript-eslint/parser": "^5.0.0",
    "eslint": "^8.0.0",
    "jest": "^28.1.1",
    "ts-jest": "^28.0.8",
    "ts-loader": "^9.2.6",
    "typescript": "^4.6.4"
  },
  "jest": {
    "moduleFileExtensions": [
      "js",
      "json",
      "ts"
    ],
    "rootDir": "src",
    "testRegex": ".*\\.spec\\.ts$",
    "transform": {
      "^.+\\.(t|j)s$": "ts-jest"
    },
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  }
}
__EOC__

cat << '__EOC__' > "tsconfig.json"
//{
//  "compilerOptions": {
//    "module": "commonjs",
//    "target": "ES2021",
//    "lib": ["ES2021", "DOM"],
//    "outDir": "./dist",
//   "rootDir": "./src",
//    "strict": true,
//   "esModuleInterop": true,
//   "emitDecoratorMetadata": true,
//  "experimentalDecorators": true,
//   "skipLibCheck": true
//  },
//"include": ["src/**/*"],
// "exclude": ["node_modules", "dist", "test"]
//}

{
  "compilerOptions": {
    // Módulo de salida (usualmente CommonJS en NestJS)
    "module": "commonjs",
    // Target ECMAScript
    "target": "ES2021",
    // Librerías a usar
    "lib": ["ES2021", "DOM"],
    // Carpeta de salida con el build compilado
    "outDir": "./dist",
    // Carpeta base de tu código fuente
    "rootDir": "./src",
    
    // Habilita el modo estricto
    "strict": true,
    // Pero desactiva la inicialización estricta de propiedades en las clases
    "strictPropertyInitialization": false,

    // Permite import/export de módulos ES
    "esModuleInterop": true,
    // Decoradores y metadatos (Nest los requiere)
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    
    // Salta la comprobación de los tipos de las dependencias (para evitar problemas con @types)
    "skipLibCheck": true
  },
  // Incluye tu carpeta src
  "include": ["src/**/*"],
  // Excluye node_modules, dist, test (o lo que desees)
  "exclude": ["node_modules", "dist", "test"]
}
__EOC__

cat << '__EOC__' > "docker-compose.yml"
version: '3.8'
services:
  api:
    build: .
    image: dialoom-backend:latest
    container_name: dialoom-api
    env_file: .env
    ports:
      - "3000:3000"
    depends_on:
      - db
      - redis
    restart: unless-stopped
  
  db:
    image: postgres:15-alpine
    container_name: dialoom-db
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_USER=${POSTGRES_USER}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: dialoom-redis
    restart: unless-stopped

volumes:
  postgres_data:
__EOC__

cat << '__EOC__' > ".env.example"
# Ejemplo de variables de entorno para Dialoom

# PostgreSQL
POSTGRES_DB=dialoomdb
POSTGRES_USER=dialoom
POSTGRES_PASSWORD=password
POSTGRES_HOST=localhost
POSTGRES_PORT=5432

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# JWT
JWT_SECRET=tu_jwt_secret

# OAuth credentials (ejemplo Google)
GOOGLE_CLIENT_ID=xxx.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=xxx
GOOGLE_CALLBACK_URL=http://localhost:3000/auth/google/callback

# Facebook, Microsoft, Apple...
FACEBOOK_APP_ID=xxx
FACEBOOK_APP_SECRET=xxx
MICROSOFT_CLIENT_ID=xxx
MICROSOFT_CLIENT_SECRET=xxx
APPLE_CLIENT_ID=xxx
APPLE_TEAM_ID=xxx
APPLE_KEY_ID=xxx
APPLE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nxxxxx\n-----END PRIVATE KEY-----"

# Stripe
STRIPE_SECRET_KEY=sk_test_xxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxx

# Firebase
FIREBASE_PROJECT_ID=tu_project_id
FIREBASE_CLIENT_EMAIL=tu_firebase_email
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\nxxxx\n-----END PRIVATE KEY-----"

# Twilio
TWILIO_ACCOUNT_SID=xxx
TWILIO_AUTH_TOKEN=xxx
TWILIO_SMS_FROM=+123456789
TWILIO_WHATSAPP_FROM=whatsapp:+14155238886

# Commission & VAT
DEFAULT_COMMISSION_RATE=0.10
DEFAULT_VAT_RATE=0.21

# Retention settings (días)
PAYMENT_RETENTION_DAYS=7
__EOC__

cat << '__EOC__' > "src/types/passport-apple.d.ts"
declare module 'passport-apple';
__EOC__

cat << '__EOC__' > "src/.DS_Store"
Bud1
ondsclboolcommondsclboolcommonlg1ScompcommonmoDDblobY^AcommonmodDblobY^Acommonph1Scomp\`configdsclboolconfiglg1ScompconfigmoDDblob AconfigmodDblob Aconfigph1Scompmodulesbwspblobbplist00]ShowStatusBar[ShowToolbar[ShowTabView_ContainerShowSidebar\WindowBounds[ShowSidebar		_{{724, 271}, {920, 464}}	#/;R_klmnomodulesdsclboolmoduleslg1ScompmodulesmoDDblob]{oAmodulesmodDblob]{oAmodulesph1ScompmodulesvSrnlong @ @ @ @E
DSDB \` @ @ @
__EOC__

cat << '__EOC__' > "src/main.ts"
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import helmet from 'helmet';
import { json, urlencoded } from 'express';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Seguridad HTTP
  app.use(helmet());
  // Aceptar cuerpos de cierto tamaño
  app.use(json({ limit: '10mb' }));
  app.use(urlencoded({ extended: true, limit: '10mb' }));

  // Versionado global (opcional)
  // app.setGlobalPrefix('api/v1');
  // O bien:
  // import { VersioningType } from '@nestjs/common';
  // app.enableVersioning({
  //   type: VersioningType.URI,
  //   defaultVersion: '1'
  // });

  // Validación de DTOs global
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true
  }));

  app.enableCors({ origin: '*' });
  await app.listen(3000);
  console.log('Dialoom backend running on port 3000');
}
bootstrap();
__EOC__

cat << '__EOC__' > "src/auth/guards/jwt-auth.guard.ts"
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
__EOC__

cat << '__EOC__' > "src/app.service.ts"
import { Injectable } from '@nestjs/common';

@Injectable()
export class AppService {
  getHello(): string {
    return 'Hello Dialoom!';
  }
}
__EOC__

cat << '__EOC__' > "src/app.module.ts"
import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { GamificationModule } from './modules/gamification/gamification.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { SupportModule } from './modules/support/support.module';
import { AdminModule } from './modules/admin/admin.module';
// Ejemplo: import { ThrottlerModule } from '@nestjs/throttler';

@Module({
  imports: [
    ConfigModule.forRoot({ isGlobal: true }),
    // Ejemplo Throttler:
    // ThrottlerModule.forRoot({
    //   ttl: 60,
    //   limit: 100,
    // }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        type: 'postgres',
        host: config.get<string>('POSTGRES_HOST', 'localhost'),
        port: +config.get<number>('POSTGRES_PORT', 5432),
        username: config.get<string>('POSTGRES_USER'),
        password: config.get<string>('POSTGRES_PASSWORD'),
        database: config.get<string>('POSTGRES_DB'),
        entities: [__dirname + '/modules/**/*.entity.{js,ts}'],
        synchronize: false, // En producción usar migraciones
      }),
      inject: [ConfigService],
    }),
    AuthModule,
    UsersModule,
    PaymentsModule,
    GamificationModule,
    NotificationsModule,
    SupportModule,
    AdminModule
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
__EOC__

cat << '__EOC__' > "src/common/interceptors/logging.interceptor.ts"
import { CallHandler, ExecutionContext, Injectable, NestInterceptor } from '@nestjs/common';
import { Observable } from 'rxjs';

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const userId = request.user?.id || 'anonymous';
    const method = request.method;
    const originalUrl = request.url;

    const logMessage = \`User ${userId} -> [${method}] ${originalUrl}\`;
    console.log(logMessage);

    return next.handle();
  }
}
__EOC__

cat << '__EOC__' > "src/common/.DS_Store"
Bud1
rators
decoratorsdsclbool
decoratorslg1Scomp
decoratorsmoDDblob}'A
decoratorsmodDblob}'A
decoratorsph1Scompguardsdsclboolguardslg1ScompguardsmoDDblobr<'AguardsmodDblobr<'Aguardsph1Scomp interceptorsdsclboolinterceptorslg1ScompinterceptorsmoDDblob6(AinterceptorsmodDblob6(Ainterceptorsph1Scomp @ @ @ @E
DSDB \` @ @ @
__EOC__

cat << '__EOC__' > "src/common/decorators/roles.decorator.ts"
import { SetMetadata } from '@nestjs/common';
import { UserRole } from '../../modules/users/entities/user.entity';

export const Roles = (...roles: UserRole[]) => SetMetadata('roles', roles);
__EOC__

cat << '__EOC__' > "src/common/guards/roles.guard.ts"
import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { UserRole } from '../../modules/users/entities/user.entity';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.get<UserRole[]>('roles', context.getHandler());
    if (!requiredRoles || requiredRoles.length === 0) {
      return true; // no se requiere rol específico
    }
    const request = context.switchToHttp().getRequest();
    const user = request.user;
    if (!user) {
      return false;
    }
    const hasRole = requiredRoles.includes(user.role);
    if (!hasRole) {
      throw new ForbiddenException('No tienes permiso para acceder a este recurso');
    }
    return true;
  }
}
__EOC__

cat << '__EOC__' > "src/common/guards/jwt-auth.guard.ts"
import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
__EOC__

cat << '__EOC__' > "src/app.controller.ts"
import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get('/health')
  healthCheck(): string {
    return 'OK';
  }
}
__EOC__

cat << '__EOC__' > "src/modules/payments/stripe.service.ts"
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';

@Injectable()
export class StripeService {
  private stripe: Stripe;
  constructor(private config: ConfigService) {
    this.stripe = new Stripe(this.config.get<string>('STRIPE_SECRET_KEY'), {
      apiVersion: '2022-11-15'
    });
  }

  async createPaymentIntent(amount: number, currency: string, hostStripeAccount: string, commission: number, vat: number) {
    const applicationFee = commission + vat; // en centavos si se requiere
    return this.stripe.paymentIntents.create({
      amount: Math.round(amount),
      currency,
      payment_method_types: ['card'],
      transfer_data: {
        destination: hostStripeAccount,
      },
      application_fee_amount: Math.round(applicationFee)
    });
  }

  async createTransfer(amount: number, currency: string, destination: string) {
    return this.stripe.transfers.create({
      amount: Math.round(amount),
      currency,
      destination
    });
  }
}
__EOC__

cat << '__EOC__' > "src/modules/payments/stripe.service.ts.bak"
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Stripe from 'stripe';

@Injectable()
export class StripeService {
  private stripe: Stripe;
  constructor(private config: ConfigService) {
    this.stripe = new Stripe(this.config.get<string>('STRIPE_SECRET_KEY'), {
      apiVersion: '2022-11-15'
    });
  }

  async createPaymentIntent(amount: number, currency: string, hostStripeAccount: string, commission: number, vat: number) {
    const applicationFee = commission + vat; // en centavos si se requiere
    return this.stripe.paymentIntents.create({
      amount: Math.round(amount),
      currency,
      payment_method_types: ['card'],
      transfer_data: {
        destination: hostStripeAccount,
      },
      application_fee_amount: Math.round(applicationFee)
    });
  }

  async createTransfer(amount: number, currency: string, destination: string) {
    return this.stripe.transfers.create({
      amount: Math.round(amount),
      currency,
      destination
    });
  }
}
__EOC__

cat << '__EOC__' > "src/modules/payments/payments.controller.ts"
import { Controller, Post, Body, Req, UseGuards } from '@nestjs/common';
import { PaymentsService } from './payments.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('payments')
export class PaymentsController {
  constructor(private paymentsService: PaymentsService) {}

  @Post('charge')
  @UseGuards(JwtAuthGuard)
  async chargeHost(@Req() req: any, @Body() body: { hostId: number, amount: number }) {
    const clientId = req.user.id;
    const { hostId, amount } = body;
    return this.paymentsService.createCharge(clientId, hostId, amount);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/payments/payments.module.ts"
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Transaction } from './entities/transaction.entity';
import { PaymentsService } from './payments.service';
import { PaymentsController } from './payments.controller';
import { StripeService } from './stripe.service';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([Transaction]), UsersModule],
  providers: [PaymentsService, StripeService],
  controllers: [PaymentsController],
  exports: [PaymentsService]
})
export class PaymentsModule {}
__EOC__

cat << '__EOC__' > "src/modules/payments/payments.service.ts.bak"
import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThanOrEqual } from 'typeorm';
import { StripeService } from './stripe.service';
import { Transaction, TransactionStatus } from './entities/transaction.entity';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';
import * as dayjs from 'dayjs';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class PaymentsService {
  private retentionDays: number;
  private defaultCommission: number;
  private defaultVAT: number;

  constructor(
    private stripeService: StripeService,
    private usersService: UsersService,
    @InjectRepository(Transaction) private txRepo: Repository<Transaction>,
    private config: ConfigService
  ) {
    this.retentionDays = this.config.get<number>('PAYMENT_RETENTION_DAYS') || 7;
    this.defaultCommission = this.config.get<number>('DEFAULT_COMMISSION_RATE') || 0.10;
    this.defaultVAT = this.config.get<number>('DEFAULT_VAT_RATE') || 0.21;
  }

  async createCharge(clientId: number, hostId: number, amount: number, currency: string = 'EUR') {
    const host: User = await this.usersService.findById(hostId);
    if (!host) {
      throw new BadRequestException('Host no disponible');
    }
    // Calcular comision + IVA
    const commission = amount * this.defaultCommission;
    const vat = commission * this.defaultVAT;
    const totalFee = commission + vat;

    // Crear PaymentIntent en Stripe
    const paymentIntent = await this.stripeService.createPaymentIntent(
      amount, currency, host.stripeAccountId, Math.round(commission), Math.round(vat)
    );

    const now = new Date();
    const availableOn = dayjs(now).add(this.retentionDays, 'day').toDate();

    const tx = this.txRepo.create({
      amount,
      currency,
      commissionRate: this.defaultCommission,
      vatRate: this.defaultVAT,
      feeAmount: totalFee,
      hostId: hostId,
      status: TransactionStatus.HOLD,
      user: { id: clientId } as User
    });
    await this.txRepo.save(tx);

    return { paymentIntentClientSecret: paymentIntent.client_secret };
  }

  async processPayouts(): Promise<void> {
    const now = new Date();
    const dueTxs = await this.txRepo.find({
      where: {
        status: TransactionStatus.HOLD,
        createdAt: LessThanOrEqual(dayjs(now).subtract(this.retentionDays, 'day').toDate())
      }
    });
    for (const tx of dueTxs) {
      // Transferir la parte neta al host
      tx.status = TransactionStatus.PAID_OUT;
      await this.txRepo.save(tx);
      // TODO: Llamar a stripeService.createTransfer(...) si no se hizo automatic
    }
  }
}
__EOC__

cat << '__EOC__' > "src/modules/payments/payments.service.ts"
import { Injectable, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, LessThanOrEqual } from 'typeorm';
import { StripeService } from './stripe.service';
import { Transaction, TransactionStatus } from './entities/transaction.entity';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';
import dayjs from 'dayjs';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class PaymentsService {
  private retentionDays: number;
  private defaultCommission: number;
  private defaultVAT: number;

  constructor(
    private stripeService: StripeService,
    private usersService: UsersService,
    @InjectRepository(Transaction) private txRepo: Repository<Transaction>,
    private config: ConfigService
  ) {
    this.retentionDays = this.config.get<number>('PAYMENT_RETENTION_DAYS') || 7;
    this.defaultCommission = this.config.get<number>('DEFAULT_COMMISSION_RATE') || 0.10;
    this.defaultVAT = this.config.get<number>('DEFAULT_VAT_RATE') || 0.21;
  }

  async createCharge(clientId: number, hostId: number, amount: number, currency: string = 'EUR') {
    const host: User = await this.usersService.findById(hostId);
    if (!host) {
      throw new BadRequestException('Host no disponible');
    }
    // Calcular comision + IVA
    const commission = amount * this.defaultCommission;
    const vat = commission * this.defaultVAT;
    const totalFee = commission + vat;

    // Crear PaymentIntent en Stripe
    const paymentIntent = await this.stripeService.createPaymentIntent(
      amount, currency, host.stripeAccountId, Math.round(commission), Math.round(vat)
    );

    const now = new Date();
    const availableOn = dayjs(now).add(this.retentionDays, 'day').toDate();

    const tx = this.txRepo.create({
      amount,
      currency,
      commissionRate: this.defaultCommission,
      vatRate: this.defaultVAT,
      feeAmount: totalFee,
      hostId: hostId,
      status: TransactionStatus.HOLD,
      user: { id: clientId } as User
    });
    await this.txRepo.save(tx);

    return { paymentIntentClientSecret: paymentIntent.client_secret };
  }

  async processPayouts(): Promise<void> {
    const now = new Date();
    const dueTxs = await this.txRepo.find({
      where: {
        status: TransactionStatus.HOLD,
        createdAt: LessThanOrEqual(dayjs(now).subtract(this.retentionDays, 'day').toDate())
      }
    });
    for (const tx of dueTxs) {
      // Transferir la parte neta al host
      tx.status = TransactionStatus.PAID_OUT;
      await this.txRepo.save(tx);
      // TODO: Llamar a stripeService.createTransfer(...) si no se hizo automatic
    }
  }
}
__EOC__

cat << '__EOC__' > "src/modules/payments/entities/transaction.entity.ts.bak"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum TransactionStatus {
  HOLD = 'hold',
  RELEASED = 'released',
  PAID_OUT = 'paid_out',
  REFUNDED = 'refunded'
}

@Entity()
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  amount: number;  // importe total en centavos

  @Column({ default: 'EUR' })
  currency: string;

  @Column({ type: 'float' })
  commissionRate: number;  // ej 0.10 para 10%

  @Column({ type: 'float' })
  vatRate: number;  // ej 0.21 para 21%

  @Column({ default: 0 })
  feeAmount: number; // comision + IVA

  @Column()
  hostId: number;   // ID del host que recibirá la parte neta

  @Column({ type: 'enum', enum: TransactionStatus, default: TransactionStatus.HOLD })
  status: TransactionStatus;

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  user: User;   // usuario que pagó
}
__EOC__

cat << '__EOC__' > "src/modules/payments/entities/transaction.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { User } from '../../users/entities/user.entity';

export enum TransactionStatus {
  HOLD = 'hold',
  RELEASED = 'released',
  PAID_OUT = 'paid_out',
  REFUNDED = 'refunded'
}

@Entity()
export class Transaction {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  amount: number;  // importe total en centavos

  @Column({ default: 'EUR' })
  currency: string;

  @Column({ type: 'float' })
  commissionRate: number;  // ej 0.10 para 10%

  @Column({ type: 'float' })
  vatRate: number;  // ej 0.21 para 21%

  @Column({ default: 0 })
  feeAmount: number; // comision + IVA

  @Column()
  hostId: number;   // ID del host que recibirá la parte neta

  @Column({ type: 'enum', enum: TransactionStatus, default: TransactionStatus.HOLD })
  status: TransactionStatus;

  @CreateDateColumn()
  createdAt: Date;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  user: User;   // usuario que pagó
}
__EOC__

cat << '__EOC__' > "src/modules/.DS_Store"
Bud1#nbwspblob @ @ @ @#adminbwspblobbplist00]ShowStatusBar[ShowToolbar[ShowTabView_ContainerShowSidebar\WindowBounds[ShowSidebar				_{{1206, 262}, {920, 492}}	#/;R_klmnoadmindsclbooladminlg1ScompadminmoDDblob\`1AadminmodDblob\`1Aadminph1ScompPadminvSrnlongauthdsclboolauthlg1Scomp?
authmoDDblobźAauthmodDblobźAauthph1Scompgamificationdsclboolgamificationlg1Scomp,gamificationmoDDblobtӂAgamificationmodDblobtӂAgamificationph1Scompnotificationsdsclboolnotificationslg1Scomp%notificationsmoDDblobhҋAnotificationsmodDblobhҋAnotificationsph1Scompppaymentsdsclboolpaymentslg1ScompQpaymentsmoDDblob$0ApaymentsmodDblob$0Apaymentsph1ScompPsupportlg1ScompsupportmoDDblob6AsupportmodDblob6Asupportph1ScompPuserslg1ScompusersmoDDblob*-AusersmodDblob*-Ausersph1Scomp@EDSDB \` @ @ @6Asupportph1ScompPuserslg1ScompusersmoDDblob*-AusersmodDblob*-Ausersph1Scomp@
__EOC__

cat << '__EOC__' > "src/modules/auth/auth.controller.ts"
import { Controller, Get, Req, Res, UseGuards } from '@nestjs/common';
import { Response } from 'express';
import { AuthService } from './auth.service';
import { GoogleAuthGuard, FacebookAuthGuard, MicrosoftAuthGuard, AppleAuthGuard } from './guards/oauth.guards';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Get('google')
  @UseGuards(GoogleAuthGuard)
  async googleAuth() {
    // Inicia el flujo OAuth con Google
  }

  @Get('google/redirect')
  @UseGuards(GoogleAuthGuard)
  async googleAuthRedirect(@Req() req: any, @Res() res: Response) {
    const user = req.user;
    const jwt = this.authService.generateJwt(user);
    // Redirigir al frontend con el JWT en query param o cookie
    return res.redirect(\\`dialoom://auth?token=\${jwt}\\`);
  }

  @Get('facebook')
  @UseGuards(FacebookAuthGuard)
  async facebookAuth() {}

  @Get('facebook/redirect')
  @UseGuards(FacebookAuthGuard)
  async facebookAuthRedirect(@Req() req: any, @Res() res: Response) {
    const user = req.user;
    const jwt = this.authService.generateJwt(user);
    return res.redirect(\\`dialoom://auth?token=\${jwt}\\`);
  }

  @Get('microsoft')
  @UseGuards(MicrosoftAuthGuard)
  async microsoftAuth() {}

  @Get('microsoft/redirect')
  @UseGuards(MicrosoftAuthGuard)
  async microsoftAuthRedirect(@Req() req: any, @Res() res: Response) {
    const user = req.user;
    const jwt = this.authService.generateJwt(user);
    return res.redirect(\\`dialoom://auth?token=\${jwt}\\`);
  }

  @Get('apple')
  @UseGuards(AppleAuthGuard)
  async appleAuth() {}

  @Get('apple/redirect')
  @UseGuards(AppleAuthGuard)
  async appleAuthRedirect(@Req() req: any, @Res() res: Response) {
    const user = req.user;
    const jwt = this.authService.generateJwt(user);
    return res.redirect(\\`dialoom://auth?token=\${jwt}\\`);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/auth/.DS_Store"
Bud1	
dsdsclbool
guardsdsclboolguardslg1ScompguardsmoDDblob8)AguardsmodDblob8)Aguardsph1Scomp
strategiesdsclbool
strategieslg1Scomp
strategiesmoDDblob	+A
strategiesmodDblob	+A
strategiesph1ScompP @ @ @ @E	DSDB \` @ @ @
__EOC__

cat << '__EOC__' > "src/modules/auth/auth.service.ts"
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { User, UserRole } from '../users/entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async validateOAuthLogin(provider: string, oauthProfile: any): Promise<User> {
    // Se espera que oauthProfile contenga email y un id unico
    const email = oauthProfile.email;
    const name = oauthProfile.name || oauthProfile.displayName;
    if (!email) {
      throw new UnauthorizedException('No email provided by OAuth profile');
    }
    // Buscar usuario
    let user = await this.usersService.findByEmail(email);
    if (!user) {
      // Crear usuario
      user = await this.usersService.createOAuthUser(name, email, UserRole.USER);
    }
    return user;
  }

  generateJwt(user: User): string {
    const payload = { sub: user.id, role: user.role, email: user.email };
    return this.jwtService.sign(payload);
  }

  // Verificar 2FA (ejemplo, supón que tenemos guardado secret TOTP en user.twoFactorSecret)
  verify2FA(user: User, code: string): boolean {
    // Implementar la verificación real (ej: speakeasy.totp.verify...)
    if (!user.twoFactorEnabled) return true; // no requiere 2FA
    // TODO: Lógica real
    return true;
  }
}
__EOC__

cat << '__EOC__' > "src/modules/auth/strategies/jwt.strategy.ts"
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(config: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: config.get<string>('JWT_SECRET'),
    });
  }

  async validate(payload: any) {
    // Retornar un objeto que se adjuntará a req.user
    return { id: payload.sub, email: payload.email, role: payload.role };
  }
}
__EOC__

cat << '__EOC__' > "src/modules/auth/strategies/facebook.strategy.ts"
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-facebook';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class FacebookStrategy extends PassportStrategy(Strategy, 'facebook') {
  constructor(private configService: ConfigService, private authService: AuthService) {
    super({
      clientID: configService.get<string>('FACEBOOK_APP_ID'),
      clientSecret: configService.get<string>('FACEBOOK_APP_SECRET'),
      callbackURL: 'http://localhost:3000/auth/facebook/redirect',
      profileFields: ['id', 'emails', 'name']
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any) {
    const { name, emails } = profile;
    const email = emails && emails[0]?.value;
    const fullName = name?.givenName + ' ' + name?.familyName;
    const oauthProfile = { name: fullName, email };
    const user = await this.authService.validateOAuthLogin('facebook', oauthProfile);
    return user;
  }
}
__EOC__

cat << '__EOC__' > "src/modules/auth/strategies/apple.strategy.ts"
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import AppleStrategyPassport from 'passport-apple';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

const AppleStrategy = AppleStrategyPassport.Strategy;

@Injectable()
export class AppleStrategy extends PassportStrategy(AppleStrategy, 'apple') {
  constructor(config: ConfigService, private authService: AuthService) {
    super({
      clientID: config.get<string>('APPLE_CLIENT_ID'),
      teamID: config.get<string>('APPLE_TEAM_ID'),
      keyID: config.get<string>('APPLE_KEY_ID'),
      privateKeyString: config.get<string>('APPLE_PRIVATE_KEY')?.replace(/\\n/g, '\n'),
      callbackURL: 'http://localhost:3000/auth/apple/redirect',
      scope: ['name', 'email'],
    });
  }

  async validate(accessToken: string, refreshToken: string, idToken: any, profile: any) {
    // Se valida la firma del idToken si es necesario
    const email = profile.email || profile._json.email;
    const name = profile.name?.firstName || profile.displayName || 'AppleUser';
    const oauthProfile = { email, name };
    const user = await this.authService.validateOAuthLogin('apple', oauthProfile);
    return user;
  }
}
__EOC__

cat << '__EOC__' > "src/modules/auth/strategies/google.strategy.ts"
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy, VerifyCallback } from 'passport-google-oauth20';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class GoogleStrategy extends PassportStrategy(Strategy, 'google') {
  constructor(private configService: ConfigService, private authService: AuthService) {
    super({
      clientID: configService.get<string>('GOOGLE_CLIENT_ID'),
      clientSecret: configService.get<string>('GOOGLE_CLIENT_SECRET'),
      callbackURL: configService.get<string>('GOOGLE_CALLBACK_URL') || 'http://localhost:3000/auth/google/redirect',
      scope: ['email', 'profile'],
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any, done: VerifyCallback): Promise<any> {
    const email = profile.emails[0].value;
    const name = profile.displayName;
    const oauthProfile = { email, name, displayName: profile.displayName };
    const user = await this.authService.validateOAuthLogin('google', oauthProfile);
    return done(null, user);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/auth/strategies/microsoft.strategy.ts"
import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-microsoft';
import { ConfigService } from '@nestjs/config';
import { AuthService } from '../auth.service';

@Injectable()
export class MicrosoftStrategy extends PassportStrategy(Strategy, 'microsoft') {
  constructor(config: ConfigService, private authService: AuthService) {
    super({
      clientID: config.get<string>('MICROSOFT_CLIENT_ID'),
      clientSecret: config.get<string>('MICROSOFT_CLIENT_SECRET'),
      callbackURL: 'http://localhost:3000/auth/microsoft/redirect',
      scope: ['user.read']
    });
  }

  async validate(accessToken: string, refreshToken: string, profile: any) {
    const email = profile.emails && profile.emails[0]?.value;
    const name = profile.displayName;
    const oauthProfile = { email, name };
    const user = await this.authService.validateOAuthLogin('microsoft', oauthProfile);
    return user;
  }
}
__EOC__

cat << '__EOC__' > "src/modules/auth/auth.module.ts"
import { Module } from '@nestjs/common';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { UsersModule } from '../users/users.module';
import { GoogleStrategy } from './strategies/google.strategy';
import { FacebookStrategy } from './strategies/facebook.strategy';
import { MicrosoftStrategy } from './strategies/microsoft.strategy';
import { AppleStrategy } from './strategies/apple.strategy';
import { JwtStrategy } from './strategies/jwt.strategy';

@Module({
  imports: [
    UsersModule,
    PassportModule.register({ session: false }),
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get<string>('JWT_SECRET'),
        signOptions: { expiresIn: '2h' }
      })
    })
  ],
  providers: [
    AuthService,
    GoogleStrategy,
    FacebookStrategy,
    MicrosoftStrategy,
    AppleStrategy,
    JwtStrategy
  ],
  controllers: [AuthController],
  exports: [AuthService]
})
export class AuthModule {}
__EOC__

cat << '__EOC__' > "src/modules/auth/auth.service.ts.bak"
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import { User, UserRole } from '../users/entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
  ) {}

  async validateOAuthLogin(provider: string, oauthProfile: any): Promise<User> {
    // Se espera que oauthProfile contenga email y un id unico
    const email = oauthProfile.email;
    const name = oauthProfile.name || oauthProfile.displayName;
    if (!email) {
      throw new UnauthorizedException('No email provided by OAuth profile');
    }
    // Buscar usuario
    let user = await this.usersService.findByEmail(email);
    if (!user) {
      // Crear usuario
      user = await this.usersService.createOAuthUser(name, email, UserRole.USER);
    }
    return user;
  }

  generateJwt(user: User): string {
    const payload = { sub: user.id, role: user.role, email: user.email };
    return this.jwtService.sign(payload);
  }

  // Verificar 2FA (ejemplo, supón que tenemos guardado secret TOTP en user.twoFactorSecret)
  verify2FA(user: User, code: string): boolean {
    // Implementar la verificación real (ej: speakeasy.totp.verify...)
    if (!user.twoFactorEnabled) return true; // no requiere 2FA
    // TODO: Lógica real
    return true;
  }
}
__EOC__

cat << '__EOC__' > "src/modules/auth/guards/oauth.guards.ts"
import { AuthGuard } from '@nestjs/passport';
import { Injectable } from '@nestjs/common';

@Injectable()
export class GoogleAuthGuard extends AuthGuard('google') {}

@Injectable()
export class FacebookAuthGuard extends AuthGuard('facebook') {}

@Injectable()
export class MicrosoftAuthGuard extends AuthGuard('microsoft') {}

@Injectable()
export class AppleAuthGuard extends AuthGuard('apple') {}
__EOC__

cat << '__EOC__' > "src/modules/gamification/.DS_Store"
Bud1tiesdsclentitiesdsclboolentitieslg1ScompentitiesmoDDblobz1AentitiesmodDblobz1Aentitiesph1Scomp0 @ @ @ @EDSDB \` @ @ @
__EOC__

cat << '__EOC__' > "src/modules/gamification/gamification.controller.ts"
import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { GamificationService } from './gamification.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from '../users/entities/user.entity';

@Controller('gamification')
@UseGuards(RolesGuard)
export class GamificationController {
  constructor(private gamificationService: GamificationService) {}

  @Post('achievements')
  @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  async createAchievement(@Body() body: { name: string, description: string, points?: number }) {
    const { name, description, points } = body;
    return this.gamificationService.createAchievement(name, description, points || 0);
  }

  @Post('levels')
  @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  async createLevel(@Body() body: { levelNumber: number, requiredPoints: number }) {
    const { levelNumber, requiredPoints } = body;
    return this.gamificationService.createLevel(levelNumber, requiredPoints);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/gamification/gamification.service.ts.bak"
import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Achievement } from './entities/achievement.entity';
import { Level } from './entities/level.entity';
import { UserAchievement } from './entities/user-achievement.entity';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';

@Injectable()
export class GamificationService {
  constructor(
    @InjectRepository(Achievement) private achieveRepo: Repository<Achievement>,
    @InjectRepository(Level) private levelRepo: Repository<Level>,
    @InjectRepository(UserAchievement) private userAchRepo: Repository<UserAchievement>,
    private usersService: UsersService,
  ) {}

  async awardAchievement(userId: number, achievementId: number) {
    const user = await this.usersService.findById(userId);
    const achievement = await this.achieveRepo.findOne({ where: { id: achievementId } });
    if (!user || !achievement) return;
    // Verificar si ya existe
    const exists = await this.userAchRepo.findOne({ where: { user: { id: userId }, achievement: { id: achievementId } } });
    if (!exists) {
      const ua = this.userAchRepo.create({ user, achievement });
      await this.userAchRepo.save(ua);
      // Sumar puntos si achievement.points > 0
      if (achievement.points > 0) {
        await this.addPoints(userId, achievement.points);
      }
    }
  }

  async addPoints(userId: number, points: number) {
    const user = await this.usersService.findById(userId);
    if (!user) return;
    user.points += points;
    // Check nivel
    const levels = await this.levelRepo.find();
    levels.sort((a,b) => a.requiredPoints - b.requiredPoints);
    let newLevel = user.level;
    for (const lvl of levels) {
      if (user.points >= lvl.requiredPoints && lvl.levelNumber > newLevel) {
        newLevel = lvl.levelNumber;
      }
    }
    user.level = newLevel;
    await this.usersService.updateProfile(user.id, { points: user.points, level: user.level });
  }

  // CRUD básicos para logros, niveles
  async createAchievement(name: string, description: string, points: number = 0) {
    const achieve = this.achieveRepo.create({ name, description, points });
    return this.achieveRepo.save(achieve);
  }

  async createLevel(levelNumber: number, requiredPoints: number) {
    const lvl = this.levelRepo.create({ levelNumber, requiredPoints });
    return this.levelRepo.save(lvl);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/gamification/gamification.module.ts"
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Achievement } from './entities/achievement.entity';
import { Level } from './entities/level.entity';
import { UserAchievement } from './entities/user-achievement.entity';
import { GamificationService } from './gamification.service';
import { GamificationController } from './gamification.controller';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Achievement, Level, UserAchievement]),
    UsersModule
  ],
  controllers: [GamificationController],
  providers: [GamificationService],
  exports: [GamificationService]
})
export class GamificationModule {}
__EOC__

cat << '__EOC__' > "src/modules/gamification/gamification.service.ts"
import { Injectable } from '@nestjs/common';
import { Repository } from 'typeorm';
import { InjectRepository } from '@nestjs/typeorm';
import { Achievement } from './entities/achievement.entity';
import { Level } from './entities/level.entity';
import { UserAchievement } from './entities/user-achievement.entity';
import { UsersService } from '../users/users.service';
import { User } from '../users/entities/user.entity';

@Injectable()
export class GamificationService {
  constructor(
    @InjectRepository(Achievement) private achieveRepo: Repository<Achievement>,
    @InjectRepository(Level) private levelRepo: Repository<Level>,
    @InjectRepository(UserAchievement) private userAchRepo: Repository<UserAchievement>,
    private usersService: UsersService,
  ) {}

  async awardAchievement(userId: number, achievementId: number) {
    const user = await this.usersService.findById(userId);
    const achievement = await this.achieveRepo.findOne({ where: { id: achievementId } });
    if (!user || !achievement) return;
    // Verificar si ya existe
    const exists = await this.userAchRepo.findOne({ where: { user: { id: userId }, achievement: { id: achievementId } } });
    if (!exists) {
      const ua = this.userAchRepo.create({ user, achievement });
      await this.userAchRepo.save(ua);
      // Sumar puntos si achievement.points > 0
      if (achievement.points > 0) {
        await this.addPoints(userId, achievement.points);
      }
    }
  }

  async addPoints(userId: number, points: number) {
    const user = await this.usersService.findById(userId);
    if (!user) return;
    user.points += points;
    // Check nivel
    const levels = await this.levelRepo.find();
    levels.sort((a,b) => a.requiredPoints - b.requiredPoints);
    let newLevel = user.level;
    for (const lvl of levels) {
      if (user.points >= lvl.requiredPoints && lvl.levelNumber > newLevel) {
        newLevel = lvl.levelNumber;
      }
    }
    user.level = newLevel;
    await this.usersService.updateProfile(user.id, { points: user.points, level: user.level });
  }

  // CRUD básicos para logros, niveles
  async createAchievement(name: string, description: string, points: number = 0) {
    const achieve = this.achieveRepo.create({ name, description, points });
    return this.achieveRepo.save(achieve);
  }

  async createLevel(levelNumber: number, requiredPoints: number) {
    const lvl = this.levelRepo.create({ levelNumber, requiredPoints });
    return this.levelRepo.save(lvl);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/gamification/entities/user-achievement.entity.ts.bak"
import { Entity, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Achievement } from './achievement.entity';

@Entity()
export class UserAchievement {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, user => user.id, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Achievement, { onDelete: 'CASCADE' })
  achievement: Achievement;

  @CreateDateColumn()
  achievedAt: Date;
}
__EOC__

cat << '__EOC__' > "src/modules/gamification/entities/achievement.entity.ts.bak"
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Achievement {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  name: string;

  @Column()
  description: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ default: 0 })
  points: number;
}
__EOC__

cat << '__EOC__' > "src/modules/gamification/entities/achievement.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Achievement {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  name: string;

  @Column()
  description: string;

  @Column({ nullable: true })
  icon: string;

  @Column({ default: 0 })
  points: number;
}
__EOC__

cat << '__EOC__' > "src/modules/gamification/entities/user-achievement.entity.ts"
import { Entity, PrimaryGeneratedColumn, ManyToOne, CreateDateColumn } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Achievement } from './achievement.entity';

@Entity()
export class UserAchievement {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => User, user => user.id, { onDelete: 'CASCADE' })
  user: User;

  @ManyToOne(() => Achievement, { onDelete: 'CASCADE' })
  achievement: Achievement;

  @CreateDateColumn()
  achievedAt: Date;
}
__EOC__

cat << '__EOC__' > "src/modules/gamification/entities/level.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Level {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  levelNumber: number;

  @Column()
  requiredPoints: number;
}
__EOC__

cat << '__EOC__' > "src/modules/gamification/entities/level.entity.ts.bak"
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Level {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  levelNumber: number;

  @Column()
  requiredPoints: number;
}
__EOC__

cat << '__EOC__' > "src/modules/admin/admin.controller.ts"
import { Controller, Get, Put, Param, Body, UseGuards } from '@nestjs/common';
import { AdminService } from './admin.service';
import { SupportService } from '../support/support.service';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from '../users/entities/user.entity';

@UseGuards(RolesGuard)
@Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
@Controller('admin')
export class AdminController {
  constructor(
    private adminService: AdminService,
    private supportService: SupportService
  ) {}

  @Get('support/tickets')
  async listSupportTickets() {
    return this.supportService.listTickets();
  }

  @Put('users/ban/:id')
  async banUser(@Param('id') userId: string) {
    await this.adminService.banUser(Number(userId));
    return { status: 'banned' };
  }

  @Get('settings/:key')
  async getSetting(@Param('key') key: string) {
    return this.adminService.getSetting(key);
  }

  @Put('settings/:key')
  async updateSetting(@Param('key') key: string, @Body() body: { value: string }) {
    const { value } = body;
    return this.adminService.updateSetting(key, value);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/admin/admin.module.ts"
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminService } from './admin.service';
import { AdminController } from './admin.controller';
import { Setting } from './entities/setting.entity';
import { Log } from './entities/log.entity';
import { UsersModule } from '../users/users.module';
import { PaymentsModule } from '../payments/payments.module';
import { GamificationModule } from '../gamification/gamification.module';
import { SupportModule } from '../support/support.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Setting, Log]),
    UsersModule,
    PaymentsModule,
    GamificationModule,
    SupportModule
  ],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
__EOC__

cat << '__EOC__' > "src/modules/admin/admin.service.ts.bak"
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Setting } from './entities/setting.entity';
import { Log } from './entities/log.entity';
import { UsersService } from '../users/users.service';
import { PaymentsService } from '../payments/payments.service';
import { GamificationService } from '../gamification/gamification.service';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(Setting) private settingsRepo: Repository<Setting>,
    @InjectRepository(Log) private logRepo: Repository<Log>,
    private usersService: UsersService,
    private paymentsService: PaymentsService,
    private gamificationService: GamificationService,
  ) {}

  async getSetting(key: string): Promise<Setting> {
    return this.settingsRepo.findOne({ where: { key } });
  }

  async updateSetting(key: string, value: string): Promise<Setting> {
    let setting = await this.settingsRepo.findOne({ where: { key } });
    if (!setting) {
      setting = this.settingsRepo.create({ key, value });
    } else {
      setting.value = value;
    }
    const saved = await this.settingsRepo.save(setting);
    await this.logRepo.save({ action: \\`UPDATE_SETTING:\${key}=\${value}\\`, performedBy: 'admin' });
    return saved;
  }

  async banUser(userId: number) {
    // Cambia el rol o marca al usuario inactivo
    await this.usersService.updateProfile(userId, { role: 'banned' } as any);
    await this.logRepo.save({ action: \\`BAN_USER:\${userId}\\`, performedBy: 'admin' });
  }
}
__EOC__

cat << '__EOC__' > "src/modules/admin/admin.service.ts"
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Setting } from './entities/setting.entity';
import { Log } from './entities/log.entity';
import { UsersService } from '../users/users.service';
import { PaymentsService } from '../payments/payments.service';
import { GamificationService } from '../gamification/gamification.service';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(Setting) private settingsRepo: Repository<Setting>,
    @InjectRepository(Log) private logRepo: Repository<Log>,
    private usersService: UsersService,
    private paymentsService: PaymentsService,
    private gamificationService: GamificationService,
  ) {}

  async getSetting(key: string): Promise<Setting> {
    return this.settingsRepo.findOne({ where: { key } });
  }

  async updateSetting(key: string, value: string): Promise<Setting> {
    let setting = await this.settingsRepo.findOne({ where: { key } });
    if (!setting) {
      setting = this.settingsRepo.create({ key, value });
    } else {
      setting.value = value;
    }
    const saved = await this.settingsRepo.save(setting);
    await this.logRepo.save({ action: \\`UPDATE_SETTING:\${key}=\${value}\\`, performedBy: 'admin' });
    return saved;
  }

  async banUser(userId: number) {
    // Cambia el rol o marca al usuario inactivo
    await this.usersService.updateProfile(userId, { role: 'banned' } as any);
    await this.logRepo.save({ action: \\`BAN_USER:\${userId}\\`, performedBy: 'admin' });
  }
}
__EOC__

cat << '__EOC__' > "src/modules/admin/entities/log.entity.ts.bak"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Log {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  action: string;

  @Column()
  performedBy: string;

  @CreateDateColumn()
  timestamp: Date;
}
__EOC__

cat << '__EOC__' > "src/modules/admin/entities/log.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Log {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  action: string;

  @Column()
  performedBy: string;

  @CreateDateColumn()
  timestamp: Date;
}
__EOC__

cat << '__EOC__' > "src/modules/admin/entities/setting.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Setting {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  key: string;

  @Column()
  value: string;
}
__EOC__

cat << '__EOC__' > "src/modules/admin/entities/setting.entity.ts.bak"
import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Setting {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  key: string;

  @Column()
  value: string;
}
__EOC__

cat << '__EOC__' > "src/modules/support/support.service.ts"
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket, TicketStatus } from './entities/ticket.entity';
import { Message } from './entities/message.entity';
import { UsersService } from '../users/users.service';

@Injectable()
export class SupportService {
  constructor(
    @InjectRepository(Ticket) private ticketRepo: Repository<Ticket>,
    @InjectRepository(Message) private messageRepo: Repository<Message>,
    private usersService: UsersService,
  ) {}

  async createTicket(userId: number, subject: string): Promise<Ticket> {
    const user = { id: userId } as any;
    const ticket = this.ticketRepo.create({ user, subject });
    return this.ticketRepo.save(ticket);
  }

  async postMessage(ticketId: number, senderId: number, content: string): Promise<Message> {
    const ticket = await this.ticketRepo.findOne({ where: { id: ticketId } });
    const sender = await this.usersService.findById(senderId);
    const message = this.messageRepo.create({ ticket, sender, content });
    return this.messageRepo.save(message);
  }

  async closeTicket(ticketId: number) {
    await this.ticketRepo.update(ticketId, { status: TicketStatus.CLOSED });
  }

  async listTickets(): Promise<Ticket[]> {
    return this.ticketRepo.find({ relations: ['user'] });
  }

  async getMessages(ticketId: number): Promise<Message[]> {
    return this.messageRepo.find({ where: { ticket: { id: ticketId } }, relations: ['sender'] });
  }
}
__EOC__

cat << '__EOC__' > "src/modules/support/support.service.ts.bak"
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Ticket, TicketStatus } from './entities/ticket.entity';
import { Message } from './entities/message.entity';
import { UsersService } from '../users/users.service';

@Injectable()
export class SupportService {
  constructor(
    @InjectRepository(Ticket) private ticketRepo: Repository<Ticket>,
    @InjectRepository(Message) private messageRepo: Repository<Message>,
    private usersService: UsersService,
  ) {}

  async createTicket(userId: number, subject: string): Promise<Ticket> {
    const user = { id: userId } as any;
    const ticket = this.ticketRepo.create({ user, subject });
    return this.ticketRepo.save(ticket);
  }

  async postMessage(ticketId: number, senderId: number, content: string): Promise<Message> {
    const ticket = await this.ticketRepo.findOne({ where: { id: ticketId } });
    const sender = await this.usersService.findById(senderId);
    const message = this.messageRepo.create({ ticket, sender, content });
    return this.messageRepo.save(message);
  }

  async closeTicket(ticketId: number) {
    await this.ticketRepo.update(ticketId, { status: TicketStatus.CLOSED });
  }

  async listTickets(): Promise<Ticket[]> {
    return this.ticketRepo.find({ relations: ['user'] });
  }

  async getMessages(ticketId: number): Promise<Message[]> {
    return this.messageRepo.find({ where: { ticket: { id: ticketId } }, relations: ['sender'] });
  }
}
__EOC__

cat << '__EOC__' > "src/modules/support/support.controller.ts"
import { Controller, Post, Get, Patch, Param, Body, Req, UseGuards } from '@nestjs/common';
import { SupportService } from './support.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('support')
@UseGuards(JwtAuthGuard)
export class SupportController {
  constructor(private supportService: SupportService) {}

  @Post('tickets')
  async createTicket(@Req() req: any, @Body() body: { subject: string }) {
    const userId = req.user.id;
    return this.supportService.createTicket(userId, body.subject);
  }

  @Get('tickets/:id/messages')
  async getTicketMessages(@Param('id') ticketId: string) {
    return this.supportService.getMessages(Number(ticketId));
  }

  @Patch('tickets/:id/close')
  async closeTicket(@Param('id') ticketId: string) {
    await this.supportService.closeTicket(Number(ticketId));
    return { status: 'closed' };
  }

  @Get('tickets')
  async listAllTickets() {
    return this.supportService.listTickets();
  }
}
__EOC__

cat << '__EOC__' > "src/modules/support/entities/ticket.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, OneToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Message } from './message.entity';

export enum TicketStatus {
  OPEN = 'open',
  CLOSED = 'closed'
}

@Entity()
export class Ticket {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 200 })
  subject: string;

  @Column({ type: 'enum', enum: TicketStatus, default: TicketStatus.OPEN })
  status: TicketStatus;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  user: User; // usuario que creó el ticket

  @CreateDateColumn()
  createdAt: Date;

  @OneToMany(() => Message, (message) => message.ticket)
  messages: Message[];
}
__EOC__

cat << '__EOC__' > "src/modules/support/entities/ticket.entity.ts.bak"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, OneToMany } from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Message } from './message.entity';

export enum TicketStatus {
  OPEN = 'open',
  CLOSED = 'closed'
}

@Entity()
export class Ticket {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 200 })
  subject: string;

  @Column({ type: 'enum', enum: TicketStatus, default: TicketStatus.OPEN })
  status: TicketStatus;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  user: User; // usuario que creó el ticket

  @CreateDateColumn()
  createdAt: Date;

  @OneToMany(() => Message, (message) => message.ticket)
  messages: Message[];
}
__EOC__

cat << '__EOC__' > "src/modules/support/entities/message.entity.ts"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { Ticket } from './ticket.entity';
import { User } from '../../users/entities/user.entity';

@Entity()
export class Message {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Ticket, ticket => ticket.messages, { onDelete: 'CASCADE' })
  ticket: Ticket;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  sender: User;

  @Column()
  content: string;

  @CreateDateColumn()
  timestamp: Date;
}
__EOC__

cat << '__EOC__' > "src/modules/support/entities/message.entity.ts.bak"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne } from 'typeorm';
import { Ticket } from './ticket.entity';
import { User } from '../../users/entities/user.entity';

@Entity()
export class Message {
  @PrimaryGeneratedColumn()
  id: number;

  @ManyToOne(() => Ticket, ticket => ticket.messages, { onDelete: 'CASCADE' })
  ticket: Ticket;

  @ManyToOne(() => User, { onDelete: 'SET NULL' })
  sender: User;

  @Column()
  content: string;

  @CreateDateColumn()
  timestamp: Date;
}
__EOC__

cat << '__EOC__' > "src/modules/support/support.module.ts"
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SupportService } from './support.service';
import { SupportController } from './support.controller';
import { Ticket } from './entities/ticket.entity';
import { Message } from './entities/message.entity';
import { UsersModule } from '../users/users.module';

@Module({
  imports: [TypeOrmModule.forFeature([Ticket, Message]), UsersModule],
  providers: [SupportService],
  controllers: [SupportController],
  exports: [SupportService]
})
export class SupportModule {}
__EOC__

cat << '__EOC__' > "src/modules/users/.DS_Store"
Bud1tiesbwspentitiesbwspblobbplist00]ShowStatusBar[ShowToolbar[ShowTabView_ContainerShowSidebar\WindowBounds[ShowSidebar				_{{527, 317}, {920, 492}}	#/;R_klmnoentitiesvSrnlong @ @ @ @EDSDB \` @ @ @
__EOC__

cat << '__EOC__' > "src/modules/users/users.service.ts"
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from './entities/user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private usersRepo: Repository<User>,
  ) {}

  async findById(id: number): Promise<User | undefined> {
    return this.usersRepo.findOne({ where: { id } });
  }

  async findByEmail(email: string): Promise<User | undefined> {
    return this.usersRepo.findOne({ where: { email } });
  }

  async createOAuthUser(name: string, email: string, role: UserRole = UserRole.USER): Promise<User> {
    const user = this.usersRepo.create({ name, email, role });
    return await this.usersRepo.save(user);
  }

  async createLocalUser(name: string, email: string, password: string): Promise<User> {
    const hashed = await bcrypt.hash(password, 10);
    const user = this.usersRepo.create({ name, email });
    // user.passwordHash = hashed; // si se maneja pass local
    return await this.usersRepo.save(user);
  }

  async updateProfile(id: number, data: Partial<User>): Promise<User> {
    await this.usersRepo.update(id, data);
    return this.findById(id);
  }

  async verifyUser(id: number): Promise<void> {
    await this.usersRepo.update(id, { isVerified: true });
  }
}
__EOC__

cat << '__EOC__' > "src/modules/users/users.controller.ts"
import { Controller, Get, Put, Body, Req, UseGuards, Patch } from '@nestjs/common';
import { UsersService } from './users.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../../common/guards/roles.guard';
import { Roles } from '../../common/decorators/roles.decorator';
import { UserRole } from './entities/user.entity';

@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  constructor(private usersService: UsersService) {}

  @Get('me')
  async getProfile(@Req() req: any) {
    const userId = req.user.id;
    return this.usersService.findById(userId);
  }

  @Put('me')
  async updateProfile(@Req() req: any, @Body() updateDto: any) {
    const userId = req.user.id;
    return this.usersService.updateProfile(userId, updateDto);
  }

  // Solo un admin o superadmin puede verificar a un usuario
  @Patch(':id/verify')
  @Roles(UserRole.ADMIN, UserRole.SUPERADMIN)
  async verifyUser(@Req() req: any) {
    const userId = parseInt(req.params.id, 10);
    await this.usersService.verifyUser(userId);
    return { message: 'Usuario verificado' };
  }
}
__EOC__

cat << '__EOC__' > "src/modules/users/users.module.ts"
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  providers: [UsersService],
  controllers: [UsersController],
  exports: [UsersService]
})
export class UsersModule {}
__EOC__

cat << '__EOC__' > "src/modules/users/users.service.ts.bak"
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User, UserRole } from './entities/user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User) private usersRepo: Repository<User>,
  ) {}

  async findById(id: number): Promise<User | undefined> {
    return this.usersRepo.findOne({ where: { id } });
  }

  async findByEmail(email: string): Promise<User | undefined> {
    return this.usersRepo.findOne({ where: { email } });
  }

  async createOAuthUser(name: string, email: string, role: UserRole = UserRole.USER): Promise<User> {
    const user = this.usersRepo.create({ name, email, role });
    return await this.usersRepo.save(user);
  }

  async createLocalUser(name: string, email: string, password: string): Promise<User> {
    const hashed = await bcrypt.hash(password, 10);
    const user = this.usersRepo.create({ name, email });
    // user.passwordHash = hashed; // si se maneja pass local
    return await this.usersRepo.save(user);
  }

  async updateProfile(id: number, data: Partial<User>): Promise<User> {
    await this.usersRepo.update(id, data);
    return this.findById(id);
  }

  async verifyUser(id: number): Promise<void> {
    await this.usersRepo.update(id, { isVerified: true });
  }
}
__EOC__

cat << '__EOC__' > "src/modules/users/entities/user.entity.ts"
import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn
} from 'typeorm';

export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin',
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id!: number;  // con ! para indicar a TS que lo maneja TypeORM

  @Column({ length: 100 })
  name!: string;

  @Column({ unique: true, length: 150 })
  email!: string;

  @Column({
    type: 'enum',
    enum: UserRole,
    default: UserRole.USER
  })
  role!: UserRole;

  @Column({ default: false })
  isVerified!: boolean;  // verificación de identidad completada?

  @Column({ default: false })
  twoFactorEnabled!: boolean;

  @Column({ nullable: true })
  twoFactorSecret!: string; // Campo opcional

  @Column({ nullable: true })
  stripeAccountId?: string; // También opcional

  // Gamificación
  @Column({ default: 0 })
  points!: number;

  @Column({ default: 1 })
  level!: number;

  @CreateDateColumn()
  createdAt!: Date;
}
__EOC__

cat << '__EOC__' > "src/modules/users/entities/user.entity.ts.bak"
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

export enum UserRole {
  USER = 'user',
  HOST = 'host',
  ADMIN = 'admin',
  SUPERADMIN = 'superadmin'
}

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 100 })
  name: string;

  @Column({ unique: true, length: 150 })
  email: string;

  @Column({ type: 'enum', enum: UserRole, default: UserRole.USER })
  role: UserRole;

  @Column({ default: false })
  isVerified: boolean;  // verificación de identidad completada?

  @Column({ default: false })
  twoFactorEnabled: boolean;

  @Column({ nullable: true })
  twoFactorSecret: string;

  @Column({ nullable: true })
  stripeAccountId?: string;  // ID de cuenta Stripe Connect si es host

  // Gamificación
  @Column({ default: 0 })
  points: number;

  @Column({ default: 1 })
  level: number;

  @CreateDateColumn()
  createdAt: Date;
}
__EOC__

cat << '__EOC__' > "src/modules/notifications/.DS_Store"
Bud1	
nelsdscl
channelsdsclboolchannelslg1ScompchannelsmoDDblob߷4AchannelsmodDblob߷4Achannelsph1Scomp0entitiesdsclboolentitieslg1ScompentitiesmoDDblob AentitiesmodDblob Aentitiesph1Scomp @ @ @ @E	DSDB \` @ @ @
__EOC__

cat << '__EOC__' > "src/modules/notifications/notifications.service.ts.bak"
import { Injectable } from '@nestjs/common';
import { FcmService } from './channels/fcm.service';
import { SendGridService } from './channels/sendgrid.service';
import { TwilioService } from './channels/twilio.service';

@Injectable()
export class NotificationsService {
  constructor(
    private fcmService: FcmService,
    private sendGridService: SendGridService,
    private twilioService: TwilioService
  ) {}

  async sendPush(token: string, title: string, body: string, data?: any) {
    return this.fcmService.sendPushNotification(token, title, body, data);
  }

  async sendEmail(to: string, subject: string, htmlContent: string) {
    return this.sendGridService.sendEmail(to, subject, htmlContent);
  }

  async sendSMS(toNumber: string, message: string) {
    return this.twilioService.sendSms(toNumber, message);
  }

  async sendWhatsApp(toNumber: string, message: string) {
    return this.twilioService.sendWhatsappMessage(toNumber, message);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/notifications/notifications.module.ts"
import { Module } from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { FcmService } from './channels/fcm.service';
import { SendGridService } from './channels/sendgrid.service';
import { TwilioService } from './channels/twilio.service';

@Module({
  imports: [],
  providers: [NotificationsService, FcmService, SendGridService, TwilioService],
  exports: [NotificationsService]
})
export class NotificationsModule {}
__EOC__

cat << '__EOC__' > "src/modules/notifications/notifications.service.ts"
import { Injectable } from '@nestjs/common';
import { FcmService } from './channels/fcm.service';
import { SendGridService } from './channels/sendgrid.service';
import { TwilioService } from './channels/twilio.service';

@Injectable()
export class NotificationsService {
  constructor(
    private fcmService: FcmService,
    private sendGridService: SendGridService,
    private twilioService: TwilioService
  ) {}

  async sendPush(token: string, title: string, body: string, data?: any) {
    return this.fcmService.sendPushNotification(token, title, body, data);
  }

  async sendEmail(to: string, subject: string, htmlContent: string) {
    return this.sendGridService.sendEmail(to, subject, htmlContent);
  }

  async sendSMS(toNumber: string, message: string) {
    return this.twilioService.sendSms(toNumber, message);
  }

  async sendWhatsApp(toNumber: string, message: string) {
    return this.twilioService.sendWhatsappMessage(toNumber, message);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/notifications/channels/sendgrid.service.ts"
import { Injectable } from '@nestjs/common';
import * as sgMail from '@sendgrid/mail';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class SendGridService {
  constructor(private config: ConfigService) {
    sgMail.setApiKey(this.config.get<string>('SENDGRID_API_KEY') || '');
  }

  async sendEmail(to: string, subject: string, htmlContent: string) {
    const msg = {
      to,
      from: this.config.get<string>('SENDGRID_FROM_EMAIL') || 'no-reply@dialoom.com',
      subject,
      html: htmlContent,
    };
    await sgMail.send(msg);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/notifications/channels/fcm.service.ts.bak"
import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';

@Injectable()
export class FcmService {
  constructor() {
    // Se asume que en el AppModule se inicializó firebase-admin
  }

  async sendPushNotification(deviceToken: string, title: string, body: string, data?: any) {
    const message: admin.messaging.Message = {
      token: deviceToken,
      notification: { title, body },
      data: data || {},
      android: { priority: 'high' }
    };
    return admin.messaging().send(message);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/notifications/channels/fcm.service.ts"
import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';

@Injectable()
export class FcmService {
  constructor() {
    // Se asume que en el AppModule se inicializó firebase-admin
  }

  async sendPushNotification(deviceToken: string, title: string, body: string, data?: any) {
    const message: admin.messaging.Message = {
      token: deviceToken,
      notification: { title, body },
      data: data || {},
      android: { priority: 'high' }
    };
    return admin.messaging().send(message);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/notifications/channels/sendgrid.service.ts.bak"
import { Injectable } from '@nestjs/common';
import * as sgMail from '@sendgrid/mail';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class SendGridService {
  constructor(private config: ConfigService) {
    sgMail.setApiKey(this.config.get<string>('SENDGRID_API_KEY') || '');
  }

  async sendEmail(to: string, subject: string, htmlContent: string) {
    const msg = {
      to,
      from: this.config.get<string>('SENDGRID_FROM_EMAIL') || 'no-reply@dialoom.com',
      subject,
      html: htmlContent,
    };
    await sgMail.send(msg);
  }
}
__EOC__

cat << '__EOC__' > "src/modules/notifications/channels/twilio.service.ts.bak"
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import twilio from 'twilio';

@Injectable()
export class TwilioService {
  private client: twilio.Twilio;

  constructor(private config: ConfigService) {
    const accountSid = config.get<string>('TWILIO_ACCOUNT_SID');
    const authToken = config.get<string>('TWILIO_AUTH_TOKEN');
    this.client = twilio(accountSid, authToken);
  }

  async sendSms(toNumber: string, message: string) {
    const fromNumber = this.config.get<string>('TWILIO_SMS_FROM');
    return this.client.messages.create({
      body: message,
      from: fromNumber,
      to: toNumber
    });
  }

  async sendWhatsappMessage(toNumber: string, message: string) {
    const fromWhatsapp = this.config.get<string>('TWILIO_WHATSAPP_FROM');
    return this.client.messages.create({
      body: message,
      from: fromWhatsapp,
      to: \\`whatsapp:\${toNumber}\\`
    });
  }
}
__EOC__

cat << '__EOC__' > "src/modules/notifications/channels/twilio.service.ts"
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Twilio from 'twilio';

@Injectable()
export class TwilioService {
  private readonly client: Twilio.Twilio;
  constructor(private readonly configService: ConfigService) {
    const accountSid = this.configService.get<string>('TWILIO_ACCOUNT_SID') || '';
    const authToken = this.configService.get<string>('TWILIO_AUTH_TOKEN') || '';
    this.client = Twilio(accountSid, authToken);
  }

  async sendWhatsappMessage(toNumber: string, message: string, fromWhatsapp: string) {
    return this.client.messages.create({
      body: message,
      from: fromWhatsapp,
      to: \`whatsapp:${toNumber}\`,
    });
  }
}
__EOC__

echo 'Snapshot recreado con éxito.'
