use axum::{Router, routing::get};
use opentelemetry_appender_tracing::layer::OpenTelemetryTracingBridge;
use opentelemetry_otlp::{LogExporter, WithExportConfig};
use opentelemetry_sdk::logs::SdkLoggerProvider;
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

#[tokio::main]
async fn main() {
    let exporter = LogExporter::builder()
        .with_http()
        .with_endpoint("http://127.0.0.1:4318/v1/logs")
        .build()
        .map_err(|e| format!("Can't initialize the exporter: {e}"))
        .unwrap();

    let logging_provider = SdkLoggerProvider::builder()
        .with_batch_exporter(exporter)
        .build();

    let otel_layer = OpenTelemetryTracingBridge::new(&logging_provider);
    tracing_subscriber::registry()
        .with(tracing_subscriber::fmt::layer())
        .with(otel_layer)
        .init();

    let app = Router::new().route("/info", get(info));
    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    println!("Server listening on 0.0.0.0:3000");
    axum::serve(listener, app).await.unwrap()
}

async fn info() -> String {
    tracing::info!("New request received.");
    "Server running on EC2".to_string()
}
