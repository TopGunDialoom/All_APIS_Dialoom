# Escalabilidad y Crecimiento en Dialoom

Este documento describe lineamientos y configuraciones para escalar la plataforma Dialoom:

1. **Escalado Horizontal**
   - Lanzar múltiples instancias (contenedores Docker) de `dialoom-backend`.
   - Usar un load balancer (Nginx o AWS Lightsail LB) para distribuir tráfico.
   - Asegurarse de que la aplicación es stateless (basado en JWT, con Redis y DB compartida).

2. **Escalado Vertical**
   - Aumentar recursos del servidor (RAM/CPU).
   - Migrar a instancias más potentes en Lightsail si la carga lo requiere.

3. **Microservicios (Futuro)**
   - Separar ciertos módulos en servicios independientes (p.ej. notifications, chat, etc.).
   - Comunicar via colas (RabbitMQ/SQS) o HTTP internal load balancing.

4. **Automatización**
   - Pipeline CI/CD con contenedores. Cada push -> test -> build -> push a registry -> deploy.
   - Monitorizar logs (CloudWatch / Grafana) para detectar cuellos de botella.

5. **Monitorización**
   - Revisar métricas (CPU, mem, response times) con NestJS + prom-client o StatsD.
   - Integrar alertas (ej. Slack) si sube latencia de forma anormal.

6. **Consideraciones DB**
   - Si MySQL se satura, usar read replicas para queries intensivas.
   - Ajustar pool de conexiones typeORM. Revisar `.env` para DB pool max size.

7. **Referencia**
   - `GrowthService` (src/modules/scalability/services/growth.service.ts) maneja la concurrency y la
     estrategia. Podrías expandirlo con la lógica real de orquestación o integración en un orquestador
     (K8s).

## Variables en .env
- `DIALOOM_MAX_WORKERS`: número de procesos o hilos que se podrían usar.
- `SCALING_STRATEGY`: "horizontal" o "vertical" (o "auto").

Implementando estas pautas, Dialoom puede crecer de forma ágil y confiable.
