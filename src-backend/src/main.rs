use actix_cors::Cors;
use actix_web::{get, web, App, HttpRequest, HttpResponse, HttpServer, Responder};
use actix_ws::Message;

#[get("/health")]
async fn health() -> impl Responder {
    HttpResponse::Ok().json(serde_json::json!({ "status": "ok" }))
}

#[get("/ws")]
async fn ws_handler(req: HttpRequest, body: web::Payload) -> actix_web::Result<HttpResponse> {
    let (response, mut session, mut msg_stream) = actix_ws::handle(&req, body)?;
    actix_web::rt::spawn(async move {
        while let Some(Ok(msg)) = msg_stream.recv().await {
            if let Message::Text(text) = msg {
                tracing::info!("ws received: {}", text);
                if session.text(text).await.is_err() {
                    break;
                }
            }
        }
        let _ = session.close(None).await;
    });
    Ok(response)
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    tracing_subscriber::fmt::init();
    tracing::info!("symposium-backend listening on 0.0.0.0:8080");

    HttpServer::new(|| {
        let cors = Cors::permissive();
        App::new()
            .wrap(cors)
            .service(health)
            .service(ws_handler)
    })
    .bind("0.0.0.0:8080")?
    .run()
    .await
}
