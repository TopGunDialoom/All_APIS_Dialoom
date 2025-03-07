# Dialoom Backend (Corregido)

Este repositorio (generado por export.sh) incluye los ajustes:

1. Se elimina la llamada a `banUser(...)`.
2. Se corrigen métodos que devuelven `Entity | null`.
3. Se cierran backticks y se quitan caracteres raros.
4. Se quita uso de `sendSms(...)` y `sendWhatsappMessage` queda con 2 params.
5. Se verifica `stripeAccountId` antes de usar Stripe.
6. Se maneja `Ticket | null` en `messageRepo.create(...)`.
7. Se corrige duplicación `AppleStrategy`.
8. Se ajusta la import de `JwtAuthGuard`.

## npm audit y posible migración a Nest 11, Twilio 5

